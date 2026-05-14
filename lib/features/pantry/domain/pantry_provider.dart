import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/models/pantry_item.dart';
import '../../auth/domain/auth_provider.dart';
import '../../shopping/domain/shopping_list_provider.dart';
import '../data/pantry_repository.dart';

// ARCHITECTURE DECISION: Utilizing AsyncNotifier<List<PantryItem>> to naturally expose
// loading, error, and loaded states to the UI layer. Delegates persistence actions to the
// PantryRepository. Handles automatic syncing with the shopping list when stock statuses change.
// Integrates reactive Firestore Cloud streaming subscription bound dynamically to user session familyId.

class PantryNotifier extends AsyncNotifier<List<PantryItem>> {
  @override
  Future<List<PantryItem>> build() async {
    // Reactively re-trigger build whenever authenticated profile or household association updates
    final currentUser = ref.watch(currentUserProvider).value;
    final familyId = currentUser?.familyId;
    final repository = ref.read(pantryRepositoryProvider);

    if (familyId != null && familyId.isNotEmpty) {
      // Establish robust real-time cloud inventory subscription
      final subscription = repository.watchCloudItems(familyId).listen((items) {
        state = AsyncData(items);
        // Safely cache retrieved cloud state to local disk fallback engine
        repository.saveLocalItems(items);
      });

      // Ensure cloud stream terminates cleanly upon provider recreation or disposal
      ref.onDispose(() {
        subscription.cancel();
      });

      return await repository.fetchCloudItems(familyId);
    } else {
      // Local disk repository retrieval path for disconnected profiles
      return await repository.fetchLocalItems();
    }
  }

  // Add a new pantry item and persist
  Future<void> addItem(PantryItem item) async {
    final currentUser = ref.read(currentUserProvider).value;
    final familyId = currentUser?.familyId;
    final repository = ref.read(pantryRepositoryProvider);

    final currentItems = state.value ?? [];
    
    // Automatically trigger shopping list addition if starting as low/finished
    if (item.stockStatus == StockStatus.low || item.stockStatus == StockStatus.finished) {
      ref.read(shoppingListProvider.notifier).addItem(item);
    }

    final updatedItems = [...currentItems, item];
    state = AsyncData(updatedItems);

    if (familyId != null && familyId.isNotEmpty) {
      await repository.saveCloudItem(familyId, item);
    } else {
      await repository.saveLocalItems(updatedItems);
    }
  }

  // Update existing item fully
  Future<void> updateItem(PantryItem updatedItem) async {
    final currentUser = ref.read(currentUserProvider).value;
    final familyId = currentUser?.familyId;
    final repository = ref.read(pantryRepositoryProvider);

    final currentItems = state.value ?? [];
    final updatedItems = currentItems.map((item) {
      return item.id == updatedItem.id ? updatedItem : item;
    }).toList();

    state = AsyncData(updatedItems);

    if (familyId != null && familyId.isNotEmpty) {
      await repository.saveCloudItem(familyId, updatedItem);
    } else {
      await repository.saveLocalItems(updatedItems);
    }

    // AUTOMATIC SHOPPING LIST INTEGRATION:
    // If status transitions to Low or Finished, sync immediately to shopping list provider.
    if (updatedItem.stockStatus == StockStatus.low || updatedItem.stockStatus == StockStatus.finished) {
      ref.read(shoppingListProvider.notifier).addItem(updatedItem);
    }
  }

  // Helper method to explicitly mark item stock status
  Future<void> markItemStatus(String id, StockStatus newStatus) async {
    final currentItems = state.value ?? [];
    final targetIndex = currentItems.indexWhere((item) => item.id == id);
    
    if (targetIndex != -1) {
      final item = currentItems[targetIndex];
      final updatedItem = item.copyWith(
        stockStatus: newStatus,
        updatedAt: DateTime.now(),
      );
      await updateItem(updatedItem);
    }
  }

  // Increment item quantity smartly
  Future<void> incrementQuantity(String id) async {
    final currentItems = state.value ?? [];
    final targetIndex = currentItems.indexWhere((item) => item.id == id);
    
    if (targetIndex != -1) {
      final item = currentItems[targetIndex];
      final newQty = item.quantity + 1;
      
      // Smartly derive status if quantity exceeds low stock thresholds
      StockStatus newStatus = item.stockStatus;
      if (newQty > item.lowStockThreshold && item.stockStatus == StockStatus.low) {
        newStatus = StockStatus.enough;
      }

      final updatedItem = item.copyWith(
        quantity: newQty,
        stockStatus: newStatus,
        updatedAt: DateTime.now(),
      );
      await updateItem(updatedItem);
    }
  }

  // Decrement item quantity smartly
  Future<void> decrementQuantity(String id) async {
    final currentItems = state.value ?? [];
    final targetIndex = currentItems.indexWhere((item) => item.id == id);
    
    if (targetIndex != -1) {
      final item = currentItems[targetIndex];
      if (item.quantity > 0) {
        final newQty = item.quantity > 1 ? item.quantity - 1 : 0.0;
        
        // Smartly derive status when inventory runs depleted/low
        StockStatus newStatus = item.stockStatus;
        if (newQty <= 0) {
          newStatus = StockStatus.finished;
        } else if (newQty <= item.lowStockThreshold) {
          newStatus = StockStatus.low;
        }

        final updatedItem = item.copyWith(
          quantity: newQty,
          stockStatus: newStatus,
          updatedAt: DateTime.now(),
        );
        await updateItem(updatedItem);
      }
    }
  }

  // Remove item permanently
  Future<void> removeItem(String id) async {
    final currentUser = ref.read(currentUserProvider).value;
    final familyId = currentUser?.familyId;
    final repository = ref.read(pantryRepositoryProvider);

    final currentItems = state.value ?? [];
    final updatedItems = currentItems.where((item) => item.id != id).toList();
    
    state = AsyncData(updatedItems);

    if (familyId != null && familyId.isNotEmpty) {
      await repository.deleteCloudItem(familyId, id);
    } else {
      await repository.saveLocalItems(updatedItems);
    }
  }
}

// Main Pantry Provider hook exposing AsyncValue state
final pantryProvider = AsyncNotifierProvider<PantryNotifier, List<PantryItem>>(
  PantryNotifier.new,
);

// State Provider: Active category filter
final selectedCategoryProvider = StateProvider<String>((ref) => 'All');

// State Provider: Active stock status filter ('All', 'Low stock', 'Finished')
final stockFilterProvider = StateProvider<String>((ref) => 'All');

// State Provider: Active text search query string
final searchQueryProvider = StateProvider<String>((ref) => '');

// Computed reactive Provider combining filtering and text searches seamlessly
final filteredPantryProvider = Provider<AsyncValue<List<PantryItem>>>((ref) {
  final pantryAsyncValue = ref.watch(pantryProvider);
  final selectedCategory = ref.watch(selectedCategoryProvider);
  final stockFilter = ref.watch(stockFilterProvider);
  final searchQuery = ref.watch(searchQueryProvider);

  return pantryAsyncValue.whenData((items) {
    return items.where((item) {
      // 1. Filter by category
      if (selectedCategory != 'All' && item.category != selectedCategory) {
        return false;
      }
      
      // 2. Filter by stock status
      if (stockFilter == 'Low stock' && item.stockStatus != StockStatus.low) {
        return false;
      }
      if (stockFilter == 'Finished' && item.stockStatus != StockStatus.finished) {
        return false;
      }
      
      // 3. Filter by search input string query
      if (searchQuery.trim().isNotEmpty) {
        final query = searchQuery.trim().toLowerCase();
        final matchesName = item.name.toLowerCase().contains(query);
        final matchesCategory = item.category.toLowerCase().contains(query);
        if (!matchesName && !matchesCategory) {
          return false;
        }
      }
      
      return true;
    }).toList();
  });
});

// Computed provider exclusively extracting items with critical inventory deficits for automated smart shopping lists
final lowStockItemsProvider = Provider<List<PantryItem>>((ref) {
  final pantryAsyncValue = ref.watch(pantryProvider);
  final items = pantryAsyncValue.value ?? [];
  return items.where((item) => item.isLowStock).toList();
});
