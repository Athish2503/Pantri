import '../../../shared/models/pantry_item.dart';

// ARCHITECTURE DECISION: Providing pre-populated mock data sets up a beginner-friendly demo environment.
// Demonstrates realistic multi-category kitchen items, low-stock threshold triggers, and standard units.

final List<PantryItem> starterPantryItems = [
  PantryItem(
    id: 'p1',
    name: 'Jasmine Rice',
    category: 'Grains & Pasta',
    quantity: 0.5, // Low stock trigger
    unit: 'kg',
    lowStockThreshold: 1.0,
    updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
  ),
  PantryItem(
    id: 'p2',
    name: 'Whole Milk',
    category: 'Dairy',
    quantity: 2.0,
    unit: 'L',
    lowStockThreshold: 0.5,
    updatedAt: DateTime.now().subtract(const Duration(days: 1)),
  ),
  PantryItem(
    id: 'p3',
    name: 'Tomato Paste',
    category: 'Canned Goods',
    quantity: 1.0, // Borderline/low stock trigger
    unit: 'can',
    lowStockThreshold: 2.0,
    updatedAt: DateTime.now().subtract(const Duration(days: 3)),
  ),
  PantryItem(
    id: 'p4',
    name: 'Extra Virgin Olive Oil',
    category: 'Spices & Condiments',
    quantity: 750.0,
    unit: 'ml',
    lowStockThreshold: 200.0,
    updatedAt: DateTime.now().subtract(const Duration(hours: 5)),
  ),
  PantryItem(
    id: 'p5',
    name: 'Fresh Apples',
    category: 'Produce',
    quantity: 6.0,
    unit: 'pcs',
    lowStockThreshold: 3.0,
    updatedAt: DateTime.now().subtract(const Duration(minutes: 30)),
  ),
  PantryItem(
    id: 'p6',
    name: 'Oatmeal',
    category: 'Grains & Pasta',
    quantity: 1.2,
    unit: 'kg',
    lowStockThreshold: 0.5,
    updatedAt: DateTime.now().subtract(const Duration(days: 2)),
  ),
];
