import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Premium Color Palette
  static const Color primaryEmerald = Color(0xFF10B981); // Emerald 500
  static const Color primaryDark = Color(0xFF065F46);    // Emerald 800
  static const Color accentAmber = Color(0xFFF59E0B);    // Amber 500
  
  static const Color lightBg = Color(0xFFF9FAFB);        // Gray 50
  static const Color darkBg = Color(0xFF111827);         // Gray 900
  
  static const Color surfaceLight = Colors.white;
  static const Color surfaceDark = Color(0xFF1F2937);    // Gray 800

  // Backward compatibility aliases
  static const Color primaryColor = primaryEmerald;
  static const Color secondaryColor = primaryDark;
  static const Color accentColor = accentAmber;
  static const Color surfaceColor = lightBg;

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryEmerald,
        primary: primaryEmerald,
        secondary: primaryDark,
        surface: lightBg,
        onSurface: const Color(0xFF111827),
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme).copyWith(
        displayLarge: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: const Color(0xFF111827)),
        headlineMedium: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: const Color(0xFF111827)),
        titleLarge: GoogleFonts.outfit(fontWeight: FontWeight.w600, color: const Color(0xFF111827)),
      ),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: lightBg,
        foregroundColor: const Color(0xFF111827),
        elevation: 0,
        titleTextStyle: GoogleFonts.outfit(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF111827),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.grey.withOpacity(0.1)),
        ),
        color: surfaceLight,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryEmerald,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: primaryEmerald, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.dark,
        seedColor: primaryEmerald,
        primary: primaryEmerald,
        secondary: primaryEmerald.withOpacity(0.8),
        surface: darkBg,
        onSurface: Colors.white,
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).copyWith(
        displayLarge: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: Colors.white),
        headlineMedium: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: Colors.white),
        titleLarge: GoogleFonts.outfit(fontWeight: FontWeight.w600, color: Colors.white),
      ),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: darkBg,
        foregroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: GoogleFonts.outfit(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.white.withOpacity(0.05)),
        ),
        color: surfaceDark,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryEmerald,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: primaryEmerald, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      ),
    );
  }
}
