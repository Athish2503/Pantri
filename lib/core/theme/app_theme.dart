import 'package:flutter/material.dart';

// ARCHITECTURE DECISION: Encapsulating light and dark theme configurations using Material 3 ThemeData.
// Primary goal includes an elder-friendly UI design: clear contrast, larger standard typography, 
// and a soothing green palette appropriate for a kitchen/pantry utility context.

class AppTheme {
  // A clean, fresh green base suitable for food/pantry tracking
  static const Color primaryColor = Color(0xFF2E7D32); // Material Green 800
  static const Color secondaryColor = Color(0xFF81C784); // Material Green 300
  static const Color accentColor = Color(0xFFFFB300); // Amber for low stock alerts
  static const Color surfaceColor = Color(0xFFF1F8E9); // Light green-tinted white for soft contrast

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: secondaryColor,
        surface: Colors.white,
        onSurface: const Color(0xFF1B5E20), // High contrast dark green/black for readability
      ),
      // Elder-friendly text scaling and contrast
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1B5E20),
        ),
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1B5E20),
        ),
        titleMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: Colors.black87,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: Colors.black87,
        ),
      ),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: surfaceColor,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
