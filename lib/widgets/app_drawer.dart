import 'package:ai_universe_chat/pages/about_page.dart';
import 'package:ai_universe_chat/pages/placeholder_page.dart';
import 'package:ai_universe_chat/widgets/chat_history_search_delegate.dart';
import 'package:flutter/material.dart';
import 'package:ai_universe_chat/pages/settings_screen.dart';
import 'package:ai_universe_chat/services/theme_service.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

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
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
            child: Text(
              'app_title'.tr(),
              style: const TextStyle(
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.search),
            title: Text('search'.tr()),
            onTap: () {
              showSearch(
                context: context,
                delegate: ChatHistorySearchDelegate(),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.add),
            title: Text('new_tab'.tr()),
            onTap: () => _navigateTo(context, 'New Tab'),
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: Text('history'.tr()),
            onTap: () => _navigateTo(context, 'History'),
          ),
          SwitchListTile(
            title: Text('dark_mode'.tr()),
            value: themeService.currentTheme == AppTheme.dark,
            onChanged: (bool value) {
              themeService.setTheme(value ? AppTheme.dark : AppTheme.light);
            },
            secondary: const Icon(Icons.dark_mode),
          ),
          SwitchListTile(
            title: Text('eye_mode'.tr()),
            value: themeService.currentTheme == AppTheme.eye,
            onChanged: (bool value) {
              themeService.setTheme(value ? AppTheme.eye : AppTheme.dark);
            },
            secondary: const Icon(Icons.remove_red_eye),
          ),
          _buildLanguageDropdown(context),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text('about'.tr()),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AboutPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.security),
            title: Text('security'.tr()),
            onTap: () => _navigateTo(context, 'Security'),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text('settings'.tr()),
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

  Widget _buildLanguageDropdown(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.language),
      title: Text('language'.tr()),
      trailing: DropdownButton<Locale>(
        value: context.locale,
        underline: const SizedBox(),
        items: const [
          DropdownMenuItem(value: Locale('en'), child: Text('English')),
          DropdownMenuItem(value: Locale('hi'), child: Text('हिंदी')),
          DropdownMenuItem(value: Locale('ar'), child: Text('العربية')),
        ],
        onChanged: (Locale? newLocale) {
          if (newLocale != null) {
            context.setLocale(newLocale);
          }
        },
      ),
    );
  }
}
