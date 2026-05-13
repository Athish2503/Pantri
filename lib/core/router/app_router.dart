import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/family/presentation/family_screen.dart';
import '../../features/pantry/presentation/pantry_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/shopping/presentation/shopping_screen.dart';
import '../../shared/widgets/bottom_navigation_scaffold.dart';

// ARCHITECTURE DECISION: Declarative navigation graph defined through go_router.
// Integrates StatefulShellRoute to provide top-level persistent tab navigation.

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/pantry',
  routes: [
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
);
