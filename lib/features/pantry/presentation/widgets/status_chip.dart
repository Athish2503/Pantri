import 'package:flutter/material.dart';
import '../../../../shared/models/pantry_item.dart';

// ARCHITECTURE DECISION: Reusable StatusChip widget rendering colorful stock state indicators.
// Includes accessible PopupMenu support enabling users to instantaneously switch states as defined in Goal 5.

class StatusChip extends StatelessWidget {
  final StockStatus status;
  final ValueChanged<StockStatus>? onStatusChanged;

  const StatusChip({
    super.key,
    required this.status,
    this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;
    String label;
    IconData icon;

    switch (status) {
      case StockStatus.enough:
        bgColor = Colors.green.shade50;
        textColor = Colors.green.shade800;
        label = 'Enough';
        icon = Icons.check_circle_outline;
        break;
      case StockStatus.low:
        bgColor = Colors.orange.shade50;
        textColor = Colors.orange.shade900;
        label = 'Low Stock';
        icon = Icons.warning_amber_rounded;
        break;
      case StockStatus.finished:
        bgColor = Colors.red.shade50;
        textColor = Colors.red.shade900;
        label = 'Finished';
        icon = Icons.error_outline;
        break;
    }

    final chipWidget = AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: textColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: textColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          if (onStatusChanged != null) ...[
            const SizedBox(width: 4),
            Icon(Icons.arrow_drop_down, size: 16, color: textColor.withOpacity(0.7)),
          ],
        ],
      ),
    );

    // If read-only mode, output standalone visualization
    if (onStatusChanged == null) {
      return chipWidget;
    }

    // Embed PopupMenu configuration allowing precise overrides matching requirements
    return PopupMenuButton<StockStatus>(
      initialValue: status,
      tooltip: 'Change stock status',
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      onSelected: onStatusChanged,
      position: PopupMenuPosition.under,
      itemBuilder: (context) => [
        PopupMenuItem(
          value: StockStatus.enough,
          child: Row(
            children: [
              Icon(Icons.check_circle_outline, color: Colors.green.shade700),
              const SizedBox(width: 12),
              const Text('Mark as Enough', style: TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        PopupMenuItem(
          value: StockStatus.low,
          child: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.orange.shade700),
              const SizedBox(width: 12),
              const Text('Mark as Low', style: TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        PopupMenuItem(
          value: StockStatus.finished,
          child: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.red.shade700),
              const SizedBox(width: 12),
              const Text('Mark as Finished', style: TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
      child: chipWidget,
    );
  }
}
