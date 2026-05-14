import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../pantry/presentation/widgets/status_chip.dart';
import '../domain/shopping_list_provider.dart';

class ShoppingScreen extends ConsumerWidget {
  const ShoppingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shoppingItems = ref.watch(shoppingListProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping List'),
        actions: [
          if (shoppingItems.isNotEmpty)
            IconButton(
              icon: const Icon(LucideIcons.trash2, color: Colors.redAccent, size: 20),
              tooltip: 'Clear List',
              onPressed: () => _showClearDialog(context, ref),
            ),
        ],
      ),
      body: shoppingItems.isEmpty
          ? EmptyStateWidget(
              title: 'Nothing to buy',
              message: 'Your shopping list is empty. Low stock items will appear here automatically.',
              icon: LucideIcons.shoppingBag,
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Info Banner
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryEmerald.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(LucideIcons.sparkles, color: AppTheme.primaryEmerald, size: 18),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Items sync automatically from your pantry stock levels.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.primaryDark,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn().slideY(begin: -0.1, end: 0),

                // List
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    itemCount: shoppingItems.length,
                    itemBuilder: (context, index) {
                      final item = shoppingItems[index];
                      final neededQty = item.quantity <= 0 
                          ? item.lowStockThreshold * 2 
                          : (item.lowStockThreshold * 1.5 - item.quantity);
                      final displayNeeded = neededQty > 0 ? neededQty : item.lowStockThreshold;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              // Purchase Toggle
                              InkWell(
                                onTap: () {
                                  ref.read(shoppingListProvider.notifier).removeItem(item.id);
                                  _showPurchasedSnack(context, item.name);
                                },
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryEmerald.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: AppTheme.primaryEmerald.withOpacity(0.2)),
                                  ),
                                  child: const Icon(LucideIcons.check, color: AppTheme.primaryEmerald),
                                ),
                              ),
                              const SizedBox(width: 16),
                              
                              // Info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Text(
                                          item.category,
                                          style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withOpacity(0.5)),
                                        ),
                                        const SizedBox(width: 8),
                                        StatusChip(status: item.stockStatus),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              
                              // Quantity
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'BUY',
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: AppTheme.primaryEmerald,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                  Text(
                                    '${displayNeeded.toStringAsFixed(0)} ${item.unit}',
                                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ).animate().fadeIn(delay: (index * 50).ms).moveX(begin: 10, end: 0);
                    },
                  ),
                ),
              ],
            ),
    );
  }

  void _showClearDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear List?'),
        content: const Text('This will remove all items from your shopping list.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              ref.read(shoppingListProvider.notifier).clearList();
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  void _showPurchasedSnack(BuildContext context, String name) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Purchased $name'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
