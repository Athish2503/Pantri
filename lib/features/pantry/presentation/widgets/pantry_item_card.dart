import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/date_formatters.dart';
import '../../../../shared/models/pantry_item.dart';
import 'status_chip.dart';

class PantryItemCard extends StatelessWidget {
  final PantryItem item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final ValueChanged<StockStatus> onStatusChanged;

  const PantryItemCard({
    super.key,
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
    required this.onEdit,
    required this.onDelete,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLow = item.isLowStock;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onEdit,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Row: Status and Actions
              Row(
                children: [
                  StatusChip(
                    status: item.stockStatus,
                    onStatusChanged: onStatusChanged,
                  ),
                  const SizedBox(width: 8),
                  if (item.isRecurring)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryEmerald.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(LucideIcons.repeat, size: 10, color: AppTheme.primaryEmerald),
                          const SizedBox(width: 4),
                          Text(
                            'RECURRING',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: AppTheme.primaryEmerald,
                              fontWeight: FontWeight.bold,
                              fontSize: 9,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(LucideIcons.moreVertical, size: 18),
                    onPressed: () => _showMoreActions(context),
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Middle Section: Name and Meta
              Text(
                item.name,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${item.category} • Updated ${AppDateFormatters.formatLastUpdated(item.updatedAt)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Bottom Row: Quantity and Controls
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: item.quantity.toStringAsFixed(item.quantity.truncateToDouble() == item.quantity ? 0 : 1),
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w900,
                                color: isLow ? AppTheme.accentAmber : AppTheme.primaryEmerald,
                              ),
                            ),
                            TextSpan(
                              text: ' ${item.unit}',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(0.4),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'Alert threshold: ${item.lowStockThreshold} ${item.unit}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.4),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: theme.colorScheme.outline.withOpacity(0.1)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildControlBtn(
                          icon: LucideIcons.minus,
                          onPressed: item.quantity > 0 ? onDecrement : null,
                        ),
                        Container(
                          width: 1,
                          height: 24,
                          color: theme.colorScheme.outline.withOpacity(0.1),
                        ),
                        _buildControlBtn(
                          icon: LucideIcons.plus,
                          onPressed: onIncrement,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControlBtn({required IconData icon, required VoidCallback? onPressed}) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Icon(
          icon,
          size: 18,
          color: onPressed == null ? Colors.grey.withOpacity(0.3) : AppTheme.primaryEmerald,
        ),
      ),
    );
  }

  void _showMoreActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          ListTile(
            leading: const Icon(LucideIcons.edit3, size: 20),
            title: const Text('Edit Item'),
            onTap: () {
              Navigator.pop(context);
              onEdit();
            },
          ),
          ListTile(
            leading: const Icon(LucideIcons.trash2, size: 20, color: Colors.redAccent),
            title: const Text('Delete Item', style: TextStyle(color: Colors.redAccent)),
            onTap: () {
              Navigator.pop(context);
              onDelete();
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
