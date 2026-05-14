import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../domain/pantry_provider.dart';
import 'add_edit_pantry_item_screen.dart';
import 'widgets/category_card.dart';
import 'widgets/category_header.dart';
import 'widgets/pantry_item_card.dart';

class PantryScreen extends ConsumerWidget {
  const PantryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredItemsAsync = ref.watch(filteredPantryProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final stockFilter = ref.watch(stockFilterProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Pantry'),
        actions: [
          // Low stock alert summary
          Consumer(
            builder: (context, ref, child) {
              final lowStockItems = ref.watch(lowStockItemsProvider);
              if (lowStockItems.isEmpty) return const SizedBox.shrink();
              
              return Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.accentAmber.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(LucideIcons.alertTriangle, size: 14, color: AppTheme.accentAmber),
                    const SizedBox(width: 4),
                    Text(
                      '${lowStockItems.length}',
                      style: const TextStyle(color: AppTheme.accentAmber, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ],
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(LucideIcons.user, size: 22),
            onPressed: () => context.push('/profile'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Search & Filter Header
          Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              children: [
                // Modern Search Field
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search pantry...',
                    prefixIcon: const Icon(LucideIcons.search, size: 20),
                    suffixIcon: Consumer(
                      builder: (context, ref, child) {
                        final query = ref.watch(searchQueryProvider);
                        if (query.isEmpty) return const SizedBox.shrink();
                        return IconButton(
                          icon: const Icon(LucideIcons.x, size: 16),
                          onPressed: () => ref.read(searchQueryProvider.notifier).state = '',
                        );
                      },
                    ),
                  ),
                  onChanged: (val) => ref.read(searchQueryProvider.notifier).state = val,
                ).animate().fadeIn(delay: 100.ms).moveY(begin: -10, end: 0),
                
                const SizedBox(height: 16),
                
                // Horizontal Status Filters
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: ['All', 'Low stock', 'Finished'].map((status) {
                      final isSelected = stockFilter == status;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(status),
                          selected: isSelected,
                          onSelected: (_) => ref.read(stockFilterProvider.notifier).state = status,
                          selectedColor: AppTheme.primaryEmerald.withOpacity(0.1),
                          labelStyle: TextStyle(
                            color: isSelected ? AppTheme.primaryEmerald : theme.colorScheme.onSurface.withOpacity(0.6),
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          side: BorderSide(
                            color: isSelected ? AppTheme.primaryEmerald : theme.colorScheme.outline.withOpacity(0.1),
                          ),
                          showCheckmark: false,
                        ),
                      );
                    }).toList(),
                  ),
                ).animate().fadeIn(delay: 200.ms),
              ],
            ),
          ),

          // Categories horizontal list
          SizedBox(
            height: 44,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: AppConstants.categories.length,
              itemBuilder: (context, index) {
                final cat = AppConstants.categories[index];
                return CategoryCard(
                  category: cat,
                  isSelected: selectedCategory == cat,
                  onTap: () => ref.read(selectedCategoryProvider.notifier).state = cat,
                );
              },
            ),
          ).animate().fadeIn(delay: 300.ms),
          
          const SizedBox(height: 16),

          // Items List
          Expanded(
            child: filteredItemsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
              data: (items) {
                if (items.isEmpty) {
                  return EmptyStateWidget(
                    title: 'Empty Pantry',
                    message: 'Time to stock up! Add items to get started.',
                    icon: LucideIcons.packageOpen,
                    onAction: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddEditPantryItemScreen())),
                    actionLabel: 'Add Item',
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return PantryItemCard(
                      key: ValueKey(item.id),
                      item: item,
                      onIncrement: () => ref.read(pantryProvider.notifier).incrementQuantity(item.id),
                      onDecrement: () => ref.read(pantryProvider.notifier).decrementQuantity(item.id),
                      onEdit: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => AddEditPantryItemScreen(existingItem: item)),
                        );
                      },
                      onDelete: () => ref.read(pantryProvider.notifier).removeItem(item.id),
                      onStatusChanged: (newStatus) => ref.read(pantryProvider.notifier).markItemStatus(item.id, newStatus),
                    ).animate().fadeIn(delay: (index * 50).ms).moveY(begin: 20, end: 0);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddEditPantryItemScreen())),
        child: const Icon(LucideIcons.plus),
      ).animate().scale(delay: 500.ms, curve: Curves.easeOutBack),
    );
  }
}
