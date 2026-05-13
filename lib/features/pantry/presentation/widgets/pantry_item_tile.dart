import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/date_formatters.dart';
import '../../../../shared/models/pantry_item.dart';

// ARCHITECTURE DECISION: Dedicated item tile focused on visual clarity.
// Displays persistent low stock indicators and accessible quick-actions (+/-)
// for modifying quantities without requiring full drill-down screens.

class PantryItemTile extends StatelessWidget {
  final PantryItem item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onDelete;

  const PantryItemTile({
    super.key,
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    // Clear background coloring/accenting to alert elder users of low stock status
    final isLow = item.isLowStock;

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingMedium,
        vertical: AppConstants.paddingSmall,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        side: BorderSide(
          color: isLow ? AppTheme.accentColor : Colors.transparent,
          width: 2.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Item name and optional low stock chip/indicator
            Row(
              children: [
                Expanded(
                  child: Text(
                    item.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                if (isLow)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.accentColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.accentColor),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.warning_amber_rounded, color: AppTheme.accentColor, size: 18),
                        SizedBox(width: 4),
                        Text(
                          'Low Stock',
                          style: TextStyle(
                            color: Color(0xFFB78103),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                // Quick delete option
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.black45),
                  onPressed: onDelete,
                  tooltip: 'Delete item',
                ),
              ],
            ),
            const SizedBox(height: 4),
            // Subtitle Row: Category and Last Updated Time
            Text(
              '${item.category} • ${AppDateFormatters.formatLastUpdated(item.updatedAt)}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.black54,
                  ),
            ),
            const SizedBox(height: 12),
            // Bottom Row: Current Quantity and Quick Adjust controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Display quantity clearly with large formatting
                Text(
                  '${item.quantity.toStringAsFixed(item.quantity.truncateToDouble() == item.quantity ? 0 : 1)} ${item.unit}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
                // Quick decrement/increment counter controls
                Row(
                  children: [
                    _buildAdjustButton(
                      context,
                      icon: Icons.remove,
                      onPressed: item.quantity > 0 ? onDecrement : null,
                      tooltip: 'Decrease quantity',
                    ),
                    const SizedBox(width: 12),
                    _buildAdjustButton(
                      context,
                      icon: Icons.add,
                      onPressed: onIncrement,
                      tooltip: 'Increase quantity',
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget to ensure minimum touch target size for accessible controls
  Widget _buildAdjustButton(
    BuildContext context, {
    required IconData icon,
    required VoidCallback? onPressed,
    required String tooltip,
  }) {
    return Material(
      color: onPressed == null ? Colors.grey.shade200 : AppTheme.secondaryColor.withOpacity(0.3),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: AppConstants.minTouchTarget,
          height: AppConstants.minTouchTarget,
          alignment: Alignment.center,
          child: Icon(
            icon,
            color: onPressed == null ? Colors.black26 : AppTheme.primaryColor,
          ),
        ),
      ),
    );
  }
}
