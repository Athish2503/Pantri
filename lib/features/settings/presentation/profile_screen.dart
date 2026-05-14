import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../auth/domain/auth_provider.dart';
import '../../../../core/theme/app_theme.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);
    final user = userAsync.value;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.logOut, color: Colors.redAccent),
            onPressed: () => _showLogoutDialog(context, ref),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Profile Header
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [AppTheme.primaryEmerald, AppTheme.primaryEmerald.withOpacity(0.6)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryEmerald.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        user?.email.substring(0, 1).toUpperCase() ?? 'U',
                        style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        shape: BoxShape.circle,
                        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.1)),
                      ),
                      child: const Icon(LucideIcons.camera, size: 18, color: AppTheme.primaryEmerald),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              user?.displayName ?? 'Pantri User',
              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ).animate().fadeIn(delay: 200.ms),
            Text(
              user?.email ?? 'user@example.com',
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6)),
            ).animate().fadeIn(delay: 300.ms),
            
            const SizedBox(height: 40),
            
            // Settings List
            _buildSection(theme, 'Account Settings'),
            _buildTile(theme, LucideIcons.user, 'Personal Information', 'Name, email, and phone'),
            _buildTile(theme, LucideIcons.shield, 'Security', 'Password and biometric'),
            
            const SizedBox(height: 24),
            _buildSection(theme, 'Preferences'),
            _buildTile(theme, LucideIcons.bell, 'Notifications', 'App alerts and stock updates'),
            _buildTile(theme, LucideIcons.palette, 'Appearance', 'Light, dark, and system theme'),
            
            const SizedBox(height: 40),
            
            ElevatedButton.icon(
              onPressed: () => _showLogoutDialog(context, ref),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent.withOpacity(0.1),
                foregroundColor: Colors.redAccent,
                elevation: 0,
                minimumSize: const Size(double.infinity, 56),
              ),
              icon: const Icon(LucideIcons.logOut, size: 20),
              label: const Text('Log Out'),
            ).animate().fadeIn(delay: 600.ms).moveY(begin: 10, end: 0),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(ThemeData theme, String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12, left: 4),
        child: Text(
          title.toUpperCase(),
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }

  Widget _buildTile(ThemeData theme, IconData icon, String title, String subtitle) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primaryEmerald.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 20, color: AppTheme.primaryEmerald),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withOpacity(0.5))),
        trailing: const Icon(LucideIcons.chevronRight, size: 16),
        onTap: () {},
      ),
    ).animate().fadeIn().moveX(begin: 10, end: 0);
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to sign out of your account?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context); // Close dialog
              await ref.read(authNotifierProvider.notifier).signOut();
              if (context.mounted) {
                // The router will handle navigation based on auth state
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }
}
