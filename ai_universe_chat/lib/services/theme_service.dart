import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppTheme { light, dark, eye }

class ThemeService with ChangeNotifier {
  static const String _themeKey = 'theme_mode';
  AppTheme _currentTheme = AppTheme.dark;

  AppTheme get currentTheme => _currentTheme;

  ThemeMode get themeMode {
    switch (_currentTheme) {
      case AppTheme.light:
        return ThemeMode.light;
      case AppTheme.dark:
      case AppTheme.eye: // Eye mode will use the dark theme as a base
        return ThemeMode.dark;
    }
  }

  ThemeData get themeData {
    switch (_currentTheme) {
      case AppTheme.light:
        return lightTheme;
      case AppTheme.dark:
        return darkTheme;
      case AppTheme.eye:
        return eyeTheme;
    }
  }


  ThemeService() {
    _loadTheme();
  }

  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(_themeKey) ?? 1; // Default to dark
    _currentTheme = AppTheme.values[themeIndex];
    notifyListeners();
  }

  void setTheme(AppTheme theme) async {
    _currentTheme = theme;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, _currentTheme.index);
    notifyListeners();
  }

  void toggleTheme() {
    setTheme(currentTheme == AppTheme.dark ? AppTheme.light : AppTheme.dark);
  }

  static final ThemeData lightTheme = ThemeData.light().copyWith(
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    cardColor: Colors.grey[200],
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black),
      bodyMedium: TextStyle(color: Colors.black87),
    ),
  );

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: const Color(0xFF121212),
    cardColor: const Color(0xFF1E1E1E),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
    ),
  );

  static final ThemeData eyeTheme = ThemeData.dark().copyWith(
    primaryColor: Colors.amber,
    scaffoldBackgroundColor: const Color(0xFF2E2B24), // Dark Sepia
    cardColor: const Color(0xFF4A443A),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Color(0xFFFFF5E1)), // Light Ivory
      bodyMedium: TextStyle(color: Color(0xFFD4C8AD)),
    ),
    colorScheme: const ColorScheme.dark().copyWith(
      primary: Colors.amber,
      secondary: Colors.amberAccent,
    ),
  );
}
