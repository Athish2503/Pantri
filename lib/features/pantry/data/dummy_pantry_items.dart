import '../../../shared/models/pantry_item.dart';

// ARCHITECTURE DECISION: Providing pre-populated mock data sets up a beginner-friendly demo environment.
// Demonstrates realistic multi-category kitchen items, low-stock threshold triggers, and standard units.

final List<PantryItem> starterPantryItems = [
  PantryItem(
    id: 'p1',
    name: 'Jasmine Rice',
    category: 'Rice & Grains',
    quantity: 0.5, // Low stock trigger
    unit: 'kg',
    lowStockThreshold: 1.0,
    stockStatus: StockStatus.low,
    createdAt: DateTime.now().subtract(const Duration(days: 10)),
    updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
    isRecurring: true,
  ),
  PantryItem(
    id: 'p2',
    name: 'Mustard Oil',
    category: 'Oils',
    quantity: 2.0,
    unit: 'L',
    lowStockThreshold: 0.5,
    stockStatus: StockStatus.enough,
    createdAt: DateTime.now().subtract(const Duration(days: 5)),
    updatedAt: DateTime.now().subtract(const Duration(days: 1)),
    isRecurring: true,
  ),
  PantryItem(
    id: 'p3',
    name: 'Turmeric Powder',
    category: 'Spices',
    quantity: 0.0, // Finished stock trigger
    unit: 'g',
    lowStockThreshold: 50.0,
    stockStatus: StockStatus.finished,
    createdAt: DateTime.now().subtract(const Duration(days: 20)),
    updatedAt: DateTime.now().subtract(const Duration(days: 3)),
    isRecurring: false,
  ),
  PantryItem(
    id: 'p4',
    name: 'Extra Virgin Olive Oil',
    category: 'Oils',
    quantity: 750.0,
    unit: 'ml',
    lowStockThreshold: 200.0,
    stockStatus: StockStatus.enough,
    createdAt: DateTime.now().subtract(const Duration(days: 12)),
    updatedAt: DateTime.now().subtract(const Duration(hours: 5)),
    isRecurring: true,
  ),
  PantryItem(
    id: 'p5',
    name: 'Fresh Carrots',
    category: 'Vegetables',
    quantity: 6.0,
    unit: 'pcs',
    lowStockThreshold: 3.0,
    stockStatus: StockStatus.enough,
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
    updatedAt: DateTime.now().subtract(const Duration(minutes: 30)),
    isRecurring: false,
  ),
  PantryItem(
    id: 'p6',
    name: 'Green Tea Bags',
    category: 'Beverages',
    quantity: 12.0,
    unit: 'pack',
    lowStockThreshold: 5.0,
    stockStatus: StockStatus.enough,
    createdAt: DateTime.now().subtract(const Duration(days: 8)),
    updatedAt: DateTime.now().subtract(const Duration(days: 2)),
    isRecurring: true,
  ),
];
