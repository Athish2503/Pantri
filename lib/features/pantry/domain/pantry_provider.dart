import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/models/pantry_item.dart';
import '../data/dummy_pantry_items.dart';

// ARCHITECTURE DECISION: Using NotifierProvider for explicit state management.
// Keeps UI reactive and separated from business logic. Allows easy integration
// of Firebase Firestore streams in the future by replacing this in-memory provider.

class PantryNotifier extends Notifier<List<PantryItem>> {
  @override
  List<PantryItem> build() {
    // Initializing with our beginner-friendly starter dummy data
    return starterPantryItems;
  }

  // Add a new item to the pantry
  void addItem(PantryItem item) {
    state = [...state, item];
  }

  // Update existing item's stock or properties
  void updateItem(PantryItem updatedItem) {
    state = [
      for (final item in state)
        if (item.id == updatedItem.id) updatedItem else item,
    ];
  }

  // Increment item quantity easily
  void incrementQuantity(String id) {
    state = [
      for (final item in state)
        if (item.id == id)
          item.copyWith(
            quantity: item.quantity + 1,
            updatedAt: DateTime.now(),
          )
        else
          item,
    ];
  }

  // Decrement item quantity easily
  void decrementQuantity(String id) {
    state = [
      for (final item in state)
        if (item.id == id && item.quantity > 0)
          item.copyWith(
            quantity: item.quantity > 1 ? item.quantity - 1 : 0,
            updatedAt: DateTime.now(),
          )
        else
          item,
    ];
  }

  // Delete an item from the pantry
  void removeItem(String id) {
    state = state.where((item) => item.id != id).toList();
  }
}

// Provider for the main pantry item list
final pantryProvider = NotifierProvider<PantryNotifier, List<PantryItem>>(
  PantryNotifier.new,
);

// State provider for the active category filter selected by the user
final selectedCategoryProvider = StateProvider<String>((ref) => 'All');

// Computed provider that filters the pantry list based on the active category filter
final filteredPantryProvider = Provider<List<PantryItem>>((ref) {
  final items = ref.watch(pantryProvider);
  final selectedCategory = ref.watch(selectedCategoryProvider);

  if (selectedCategory == 'All') {
    return items;
  }
  return items.where((item) => item.category == selectedCategory).toList();
});

// Computed provider to get only low stock items (useful for automated shopping lists)
final lowStockItemsProvider = Provider<List<PantryItem>>((ref) {
  final items = ref.watch(pantryProvider);
  return items.where((item) => item.isLowStock).toList();
});
