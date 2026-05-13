import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';

// ARCHITECTURE DECISION: Centralized control view. Prepares easy hooks for multilingual support,
// notification options, and future Firebase Authentication sign-out flows.

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        children: [
          // Section: Language / Multilingual Setup
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'Language & Localization',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('App Language', style: TextStyle(fontSize: 18)),
            subtitle: Text(_selectedLanguage),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => _showLanguageSelection(context),
          ),
          const Divider(),

          // Section: Notifications
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'Alerts',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
            ),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.notifications_active),
            title: const Text('Low Stock Alerts', style: TextStyle(fontSize: 18)),
            subtitle: const Text('Notify when pantry items reach critical thresholds'),
            value: _notificationsEnabled,
            activeColor: AppTheme.primaryColor,
            onChanged: (val) {
              setState(() {
                _notificationsEnabled = val;
              });
            },
          ),
          const Divider(),

          // Section: Account / Firebase Auth placeholder
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'Account',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.security),
            title: const Text('Firebase Authentication', style: TextStyle(fontSize: 18)),
            subtitle: const Text('Ready for production account configuration'),
            trailing: const Icon(Icons.check_circle, color: AppTheme.primaryColor),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Firebase Auth ready configuration setup.')),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showLanguageSelection(BuildContext context) {
    final languages = ['English', 'Español', 'Français', 'Deutsch', 'हिन्दी'];
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: 16),
          itemCount: languages.length,
          itemBuilder: (context, index) {
            final lang = languages[index];
            return ListTile(
              title: Text(
                lang,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: lang == _selectedLanguage ? FontWeight.bold : FontWeight.normal,
                  color: lang == _selectedLanguage ? AppTheme.primaryColor : Colors.black87,
                ),
              ),
              trailing: lang == _selectedLanguage ? const Icon(Icons.check, color: AppTheme.primaryColor) : null,
              onTap: () {
                setState(() {
                  _selectedLanguage = lang;
                });
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }
}
