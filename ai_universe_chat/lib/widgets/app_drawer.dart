import 'package:ai_universe_chat/pages/placeholder_page.dart';
import 'package:flutter/material.dart';
import 'package:ai_universe_chat/pages/settings_screen.dart';
import 'package:ai_universe_chat/services/theme_service.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  void _navigateTo(BuildContext context, String title) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => PlaceholderPage(title: title)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);
    return Drawer(
      backgroundColor: Theme.of(context).cardColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFF121212),
            ),
            child: Text(
              'AI Universe',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.search),
            title: const Text('Search'),
            onTap: () => _navigateTo(context, 'Search'),
          ),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('New Tab'),
            onTap: () => _navigateTo(context, 'New Tab'),
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('History'),
            onTap: () => _navigateTo(context, 'History'),
          ),
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: themeService.themeMode == ThemeMode.dark,
            onChanged: (bool value) {
              themeService.toggleTheme();
            },
            secondary: const Icon(Icons.dark_mode),
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Language'),
            onTap: () => _navigateTo(context, 'Language'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About'),
            onTap: () => _navigateTo(context, 'About'),
          ),
          ListTile(
            leading: const Icon(Icons.security),
            title: const Text('Security'),
            onTap: () => _navigateTo(context, 'Security'),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
