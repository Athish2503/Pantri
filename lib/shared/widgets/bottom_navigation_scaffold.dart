import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';

// ARCHITECTURE DECISION: Reusable Scaffold handling root tab navigation via go_router's StatefulNavigationShell.
// Retains widget state across tabs so users don't lose scroll positions or unsaved entries.
// Elder-friendly UI goal: Always shows explicit text labels below distinct, easy-to-tap icons.

class BottomNavigationScaffold extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const BottomNavigationScaffold({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index,
            // Supporting quick return to root when re-tapping active tab
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        backgroundColor: AppTheme.surfaceColor,
        indicatorColor: AppTheme.secondaryColor.withOpacity(0.4),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.kitchen_outlined),
            selectedIcon: Icon(Icons.kitchen, color: AppTheme.primaryColor),
            label: 'Pantry',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_cart_outlined),
            selectedIcon: Icon(Icons.shopping_cart, color: AppTheme.primaryColor),
            label: 'Shopping',
          ),
          NavigationDestination(
            icon: Icon(Icons.family_restroom_outlined),
            selectedIcon: Icon(Icons.family_restroom, color: AppTheme.primaryColor),
            label: 'Family',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings, color: AppTheme.primaryColor),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
