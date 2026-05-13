import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../pantry/domain/pantry_provider.dart';

// ARCHITECTURE DECISION: Shopping screen dynamically listens to low stock state
// to automatically generate the shopping list. Prevents redundant user manual inputs.

class ShoppingScreen extends ConsumerWidget {
  const ShoppingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Automatically retrieve low stock items for grocery preparation
    final lowStockItems = ref.watch(lowStockItemsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Shopping List'),
      ),
      body: lowStockItems.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(AppConstants.paddingLarge),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle_outline, size: 64, color: AppTheme.secondaryColor),
                    SizedBox(height: 16),
                    Text(
                      'All Pantry items are well stocked!',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Items running low on stock will automatically populate here.',
                      style: TextStyle(fontSize: 15, color: Colors.black54),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          : Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppConstants.paddingMedium),
                  color: AppTheme.surfaceColor,
                  child: Row(
                    children: [
                      const Icon(Icons.auto_awesome, color: AppTheme.primaryColor),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Automatically generated from low stock items',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: lowStockItems.length,
                    itemBuilder: (context, index) {
                      final item = lowStockItems[index];
                      return ListTile(
                        leading: const Icon(Icons.shopping_cart_checkout, color: AppTheme.primaryColor),
                        title: Text(
                          item.name,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text('Category: ${item.category}'),
                        trailing: Text(
                          'Needed: ${(item.lowStockThreshold * 2 - item.quantity).toStringAsFixed(1)} ${item.unit}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.accentColor,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
