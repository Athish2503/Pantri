import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../shared/models/pantry_item.dart';

// ARCHITECTURE DECISION: Dedicated ShoppingListNotifier manages items needed for shopping.
// Separates pantry inventory state from actual grocery trips. Supports automatic insertions
// from pantry changes while enforcing zero duplicate entries.

class ShoppingListNotifier extends Notifier<List<PantryItem>> {
  static const String _prefsKey = 'shopping_list_cache_v2';

  @override
  List<PantryItem> build() {
    // Initiate asynchronous local data load
    _loadFromPrefs();
    return [];
  }

  Future<void> _loadFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_prefsKey);
      if (jsonString != null && jsonString.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(jsonString);
        state = decoded
            .map((map) => PantryItem.fromMap(
                  map as Map<String, dynamic>,
                  map['id'] as String? ?? DateTime.now().millisecondsSinceEpoch.toString(),
                ))
            .toList();
      }
    } catch (e) {
      // Gracefully continue with empty list if load fails
    }
  }

  Future<void> _saveToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encoded = state.map((item) => item.toMap()).toList();
      await prefs.setString(_prefsKey, jsonEncode(encoded));
    } catch (e) {
      // Gracefully continue if persistence encounters disk limits
    }
  }

  // Add item automatically or manually ensuring no duplicate entries occur
  void addItem(PantryItem item) {
    // Check duplication by unique ID or matching case-insensitive name
    final exists = state.any((existing) =>
        existing.id == item.id ||
        existing.name.trim().toLowerCase() == item.name.trim().toLowerCase());
        
    if (!exists) {
      // Append safely to current list state
      state = [...state, item];
      _saveToPrefs();
    }
  }

  // Remove item once purchased or discarded
  void removeItem(String id) {
    state = state.where((item) => item.id != id).toList();
    _saveToPrefs();
  }

  // Clear all items easily
  void clearList() {
    state = [];
    _saveToPrefs();
  }
}

// Global accessible shopping list provider injection hook
final shoppingListProvider = NotifierProvider<ShoppingListNotifier, List<PantryItem>>(
  ShoppingListNotifier.new,
);
