import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';

// ARCHITECTURE DECISION: Decoupled UI component for category selection.
// Designed with accessible touch padding and distinct contrast for elder-friendly use.

class CategoryCard extends StatelessWidget {
  final String category;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
          child: Container(
            constraints: const BoxConstraints(
              minHeight: AppConstants.minTouchTarget,
              minWidth: 80,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.paddingMedium,
              vertical: AppConstants.paddingSmall,
            ),
            decoration: BoxDecoration(
              color: isSelected ? AppTheme.primaryColor : AppTheme.surfaceColor,
              borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
              border: Border.all(
                color: isSelected ? AppTheme.primaryColor : AppTheme.secondaryColor.withOpacity(0.5),
                width: 1.5,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              category,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? Colors.white : Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
