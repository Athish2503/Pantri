import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/constants/app_constants.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'firebase_options.dart';

// ARCHITECTURE DECISION: Wrapping application root with Riverpod's ProviderScope.
// Ensures dependency injection and reactive state providers are accessible globally.
// Implements safe startup configurations wrapping Firebase core initialization tasks.

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load Runtime Environment Configurations securely
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    // Fallback gracefully if .env file is omitted during local test runs or layout tests
  }

  // Safe Platform Core Initialization
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    // Gracefully catch secondary execution attempts or absent configurations during layout tests
  }

  runApp(
    const ProviderScope(
      child: PantriApp(),
    ),
  );
}

class PantriApp extends ConsumerWidget {
  const PantriApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      // Material 3 UI enforcement driven through centralized custom theme module
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      // Dynamic reactive router configured with active Riverpod authorization parameters
      routerConfig: router,
    );
  }
}
