// Core application constants for Pantri
// ARCHITECTURE DECISION: Centralizing constants avoids magic strings/numbers across the app
// and makes global adjustments (like elder-friendly layout spacing) easy to maintain.

class AppConstants {
  static const String appName = 'Pantri';

  // Layout and Spacing optimized for readability and touch targets (Elder-friendly UI)
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  
  // Touch target sizes for accessibility
  static const double minTouchTarget = 48.0;
  static const double cardBorderRadius = 16.0;

  // Pantry item default categories
  static const List<String> categories = [
    'All',
    'Grains & Pasta',
    'Canned Goods',
    'Dairy',
    'Produce',
    'Spices & Condiments',
    'Snacks',
  ];

  // Common units of measurement
  static const List<String> units = [
    'pcs',
    'g',
    'kg',
    'ml',
    'L',
    'box',
    'pack',
    'can',
  ];
}
