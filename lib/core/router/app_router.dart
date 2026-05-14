import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/domain/auth_provider.dart';
import '../../features/auth/presentation/auth_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/auth/presentation/splash_screen.dart';
import '../../features/family/presentation/family_screen.dart';
import '../../features/pantry/presentation/pantry_screen.dart';
import '../../features/settings/presentation/profile_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/shopping/presentation/shopping_screen.dart';
import '../../shared/widgets/bottom_navigation_scaffold.dart';

// ARCHITECTURE DECISION: Centralized dynamic navigation controller provider.
// Leverages GoRouter redirection loops paired directly to Firebase Auth Session StreamProviders.
// Implements secure auth guards blocking protected tabs unless logged in or explicit guest bypass is active.

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateStreamProvider);
  final guestMode = ref.watch(guestModeProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    routes: [
      // Unprotected Entrance Gates
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const AuthScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      
      // Protected Application Tabs managed under stateful persistent bottom wrappers
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return BottomNavigationScaffold(navigationShell: navigationShell);
        },
        branches: [
          // Branch 1: Pantry Items tracking
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/pantry',
                builder: (context, state) => const PantryScreen(),
              ),
            ],
          ),
          // Branch 2: Smart Shopping List generator
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/shopping',
                builder: (context, state) => const ShoppingScreen(),
              ),
            ],
          ),
          // Branch 3: Multi-user family synchronization
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/family',
                builder: (context, state) => const FamilyScreen(),
              ),
            ],
          ),
          // Branch 4: Application parameters & localization
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      // If developer/guest bypass mode is active, skip all authorization verification hurdles
      if (guestMode) return null;

      final isGoingToLoginOrRegister = state.matchedLocation == '/login' || state.matchedLocation == '/register';
      final isGoingToSplash = state.matchedLocation == '/splash';

      // While initial authentication states resolve, preserve splash UI rendering
      if (authState.isLoading) {
        return '/splash';
      }

      final isAuth = authState.value != null;

      if (!isAuth) {
        // Enforce guard redirecting anonymous entries back to authentication entry point
        if (!isGoingToLoginOrRegister) {
          return '/login';
        }
      } else {
        // Prevent logged-in users from looping back into splash or credential prompt dialogs
        if (isGoingToLoginOrRegister || isGoingToSplash) {
          return '/pantry';
        }
      }

      return null;
    },
  );
});
