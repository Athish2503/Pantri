import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _selectedLanguage = 'English';
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile Section
          _buildSectionHeader(theme, 'Account'),
          Card(
            child: ListTile(
              leading: const Icon(LucideIcons.user, color: AppTheme.primaryEmerald),
              title: const Text('Profile Settings', style: TextStyle(fontWeight: FontWeight.w600)),
              subtitle: const Text('Manage your account and preferences'),
              trailing: const Icon(LucideIcons.chevronRight, size: 16),
              onTap: () => context.push('/profile'),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Language Section
          _buildSectionHeader(theme, 'Localization'),
          Card(
            child: ListTile(
              leading: const Icon(LucideIcons.languages, color: AppTheme.primaryEmerald),
              title: const Text('App Language', style: TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text(_selectedLanguage),
              trailing: const Icon(LucideIcons.chevronRight, size: 16),
              onTap: () => _showLanguageSelection(context),
            ),
          ),
          
          const SizedBox(height: 24),

          // Notifications Section
          _buildSectionHeader(theme, 'Alerts & Notifications'),
          Card(
            child: SwitchListTile(
              secondary: const Icon(LucideIcons.bell, color: AppTheme.primaryEmerald),
              title: const Text('Low Stock Alerts', style: TextStyle(fontWeight: FontWeight.w600)),
              subtitle: const Text('Notify when pantry items reach critical thresholds'),
              value: _notificationsEnabled,
              activeColor: AppTheme.primaryEmerald,
              onChanged: (val) => setState(() => _notificationsEnabled = val),
            ),
          ),
          
          const SizedBox(height: 24),

          // About Section
          _buildSectionHeader(theme, 'About'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(LucideIcons.info, color: AppTheme.primaryEmerald),
                  title: const Text('App Version', style: TextStyle(fontWeight: FontWeight.w600)),
                  trailing: Text('1.0.0', style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.5))),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(LucideIcons.helpCircle, color: AppTheme.primaryEmerald),
                  title: const Text('Help & Support', style: TextStyle(fontWeight: FontWeight.w600)),
                  trailing: const Icon(LucideIcons.externalLink, size: 14),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(ThemeData theme, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: theme.textTheme.labelLarge?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.1,
        ),
      ),
    );
  }

  void _showLanguageSelection(BuildContext context) {
    final languages = ['English', 'Español', 'Français', 'Deutsch', 'हिन्दी'];
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Select Language', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              ...languages.map((lang) => ListTile(
                title: Text(
                  lang,
                  style: TextStyle(
                    fontWeight: lang == _selectedLanguage ? FontWeight.bold : FontWeight.normal,
                    color: lang == _selectedLanguage ? AppTheme.primaryEmerald : null,
                  ),
                ),
                trailing: lang == _selectedLanguage ? const Icon(LucideIcons.check, color: AppTheme.primaryEmerald) : null,
                onTap: () {
                  setState(() => _selectedLanguage = lang);
                  Navigator.pop(context);
                },
              )),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }
}
