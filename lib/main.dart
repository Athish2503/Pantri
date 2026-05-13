import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/constants/app_constants.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

// ARCHITECTURE DECISION: Wrapping application root with Riverpod's ProviderScope.
// Ensures dependency injection and reactive state providers are accessible globally.
// Beginner-friendly entry point maintaining pure separation of routing, theme, and state setup.

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // FUTURE INTEGRATION HOOK: Initialize Firebase backend infrastructure here
  // await Firebase.initializeApp();

  runApp(
    const ProviderScope(
      child: PantriApp(),
    ),
  );
}

class PantriApp extends StatelessWidget {
  const PantriApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      // Material 3 UI enforcement driven through centralized custom theme module
      theme: AppTheme.lightTheme,
      // go_router driven page state routing framework
      routerConfig: appRouter,
    );
  }
}
