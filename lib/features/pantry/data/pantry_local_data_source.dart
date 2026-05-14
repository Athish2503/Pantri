import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../shared/models/pantry_item.dart';
import 'dummy_pantry_items.dart';

// ARCHITECTURE DECISION: Local data source abstracts the low-level storage details.
// Uses SharedPreferences temporarily for beginner-friendly, reliable state persistence.
// Falls back gracefully to pre-populated mock data if storage is uninitialized or fails.

class PantryLocalDataSource {
  static const String _storageKey = 'pantri_items_cache_v2';

  Future<List<PantryItem>> getPantryItems() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_storageKey);
      
      if (jsonString == null || jsonString.isEmpty) {
        // Return starter mock items if nothing is saved yet
        return starterPantryItems;
      }
      
      final List<dynamic> decodedList = jsonDecode(jsonString);
      return decodedList
          .map((map) => PantryItem.fromMap(
                map as Map<String, dynamic>,
                map['id'] as String? ?? DateTime.now().millisecondsSinceEpoch.toString(),
              ))
          .toList();
    } catch (e) {
      // Fallback gracefully to starter items if local reading fails
      return starterPantryItems;
    }
  }

  Future<void> savePantryItems(List<PantryItem> items) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encodedList = items.map((item) => item.toMap()).toList();
      await prefs.setString(_storageKey, jsonEncode(encodedList));
    } catch (e) {
      // Silently ignore or log persistence errors for simple client setups
    }
  }
}
