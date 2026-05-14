import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/models/app_user.dart';
import '../data/auth_repository.dart';

// ARCHITECTURE DECISION: Decoupled authentication state providers.
// StreamProviders reactively output current session status directly to router redirects and views.
// AuthNotifier cleanly encapsulates async sign-in, signup, and sign-out actions.

// Stream provider monitoring live real-time Firebase Auth session state changes
final authStateStreamProvider = StreamProvider<User?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});

// Stream provider monitoring live Firestore profile document representations
final currentUserProvider = StreamProvider<AppUser?>((ref) {
  return ref.watch(authRepositoryProvider).watchCurrentUser();
});

class AuthNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {
    // Initial loaded idle state ready to dispatch credentials
  }

  // Execute clean sign-in action with loading guard updates
  Future<void> signIn(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).signInWithEmailPassword(email, password);
    });
  }

  // Execute Google OAuth sign-in flow
  Future<void> signInWithGoogle() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).signInWithGoogle();
    });
  }

  // Execute clean account creation logic
  Future<void> register(String email, String password, String displayName) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).registerWithEmailPassword(email, password, displayName);
    });
  }

  // Execute secure session termination
  Future<void> signOut() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).signOut();
    });
  }
}

// Globally accessible AuthNotifier controller instance
final authNotifierProvider = AsyncNotifierProvider<AuthNotifier, void>(
  AuthNotifier.new,
);
