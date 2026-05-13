import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/models/pantry_item.dart';
import '../domain/pantry_provider.dart';
import 'widgets/category_card.dart';
import 'widgets/pantry_item_tile.dart';

// ARCHITECTURE DECISION: Presentation layer delegates state queries and modifications
// purely to Riverpod providers. Keeps widget code declarative and simplified.

class PantryScreen extends ConsumerWidget {
  const PantryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredItems = ref.watch(filteredPantryProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Pantry'),
        actions: [
          // Clear visual summary badge showing count of low stock items
          Consumer(
            builder: (context, ref, child) {
              final lowStockCount = ref.watch(lowStockItemsProvider).length;
              if (lowStockCount == 0) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$lowStockCount Alert',
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Horizontal scrolling Category Filter Bar
          const SizedBox(height: AppConstants.paddingSmall),
          SizedBox(
            height: 54,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              itemCount: AppConstants.categories.length,
              itemBuilder: (context, index) {
                final cat = AppConstants.categories[index];
                return CategoryCard(
                  category: cat,
                  isSelected: selectedCategory == cat,
                  onTap: () {
                    ref.read(selectedCategoryProvider.notifier).state = cat;
                  },
                );
              },
            ),
          ),
          const SizedBox(height: AppConstants.paddingSmall),
          // Main Scrollable Pantry List View
          Expanded(
            child: filteredItems.isEmpty
                ? const Center(
                    child: Text(
                      'No items found in this category.',
                      style: TextStyle(fontSize: 18, color: Colors.black45),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      return PantryItemTile(
                        item: item,
                        onIncrement: () => ref.read(pantryProvider.notifier).incrementQuantity(item.id),
                        onDecrement: () => ref.read(pantryProvider.notifier).decrementQuantity(item.id),
                        onDelete: () => ref.read(pantryProvider.notifier).removeItem(item.id),
                      );
                    },
                  ),
          ),
        ],
      ),
      // Floating Add Item Button triggers a practical quick-add model dialog
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddItemDialog(context, ref),
        icon: const Icon(Icons.add),
        label: const Text(
          'Add Item',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // Practical dialog to add new pantry item with minimal friction
  void _showAddItemDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final quantityController = TextEditingController(text: '1.0');
    String selectedCat = AppConstants.categories[1]; // Grains & Pasta by default
    String selectedUnit = AppConstants.units[0]; // pcs by default

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Add New Pantry Item'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Item Name',
                    hintText: 'e.g., Bread, Flour',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedCat,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  items: AppConstants.categories
                      .where((c) => c != 'All')
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) selectedCat = val;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: quantityController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          labelText: 'Quantity',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 1,
                      child: DropdownButtonFormField<String>(
                        value: selectedUnit,
                        decoration: const InputDecoration(
                          labelText: 'Unit',
                          border: OutlineInputBorder(),
                        ),
                        items: AppConstants.units
                            .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) selectedUnit = val;
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text.trim();
                final qty = double.tryParse(quantityController.text.trim()) ?? 1.0;
                if (name.isNotEmpty) {
                  final newItem = PantryItem(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: name,
                    category: selectedCat,
                    quantity: qty,
                    unit: selectedUnit,
                    lowStockThreshold: 1.0,
                    updatedAt: DateTime.now(),
                  );
                  ref.read(pantryProvider.notifier).addItem(newItem);
                  Navigator.pop(dialogContext);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
