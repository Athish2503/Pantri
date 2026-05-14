import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/app_theme.dart';

class BottomNavigationScaffold extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const BottomNavigationScaffold({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        backgroundColor: theme.colorScheme.surface,
        indicatorColor: AppTheme.primaryEmerald.withOpacity(0.1),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        elevation: 0,
        destinations: const [
          NavigationDestination(
            icon: Icon(LucideIcons.home, size: 22),
            selectedIcon: Icon(LucideIcons.home, color: AppTheme.primaryEmerald, size: 22),
            label: 'Pantry',
          ),
          NavigationDestination(
            icon: Icon(LucideIcons.shoppingCart, size: 22),
            selectedIcon: Icon(LucideIcons.shoppingCart, color: AppTheme.primaryEmerald, size: 22),
            label: 'Shopping',
          ),
          NavigationDestination(
            icon: Icon(LucideIcons.users, size: 22),
            selectedIcon: Icon(LucideIcons.users, color: AppTheme.primaryEmerald, size: 22),
            label: 'Family',
          ),
          NavigationDestination(
            icon: Icon(LucideIcons.settings, size: 22),
            selectedIcon: Icon(LucideIcons.settings, color: AppTheme.primaryEmerald, size: 22),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
