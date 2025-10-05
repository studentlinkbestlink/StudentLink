import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Theme provider that manages the app's theme state and persistence
class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'theme_mode';
  
  ThemeMode _themeMode = ThemeMode.light; // Default to light mode to prevent black screen
  
  ThemeMode get themeMode => _themeMode;
  
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  
  bool get isLightMode => _themeMode == ThemeMode.light;
  
  /// Initialize theme from shared preferences
  Future<void> initializeTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedTheme = prefs.getString(_themeKey);
      
      if (savedTheme != null) {
        switch (savedTheme) {
          case 'light':
            _themeMode = ThemeMode.light;
            break;
          case 'dark':
            _themeMode = ThemeMode.dark;
            break;
          case 'system':
            _themeMode = ThemeMode.system;
            break;
          default:
            _themeMode = ThemeMode.light;
        }
      } else {
        _themeMode = ThemeMode.light; // Default to light mode to prevent black screen
      }
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error initializing theme: $e');
      _themeMode = ThemeMode.light; // Default to light mode on error to prevent black screen
      notifyListeners();
    }
  }
  
  /// Toggle between light and dark mode
  Future<void> toggleTheme() async {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    await _saveTheme();
    notifyListeners();
  }
  
  /// Set specific theme mode
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _saveTheme();
    notifyListeners();
  }
  
  /// Set light mode
  Future<void> setLightMode() async {
    _themeMode = ThemeMode.light;
    await _saveTheme();
    notifyListeners();
  }
  
  /// Set dark mode
  Future<void> setDarkMode() async {
    _themeMode = ThemeMode.dark;
    await _saveTheme();
    notifyListeners();
  }
  
  /// Set system theme mode
  Future<void> setSystemMode() async {
    _themeMode = ThemeMode.system;
    await _saveTheme();
    notifyListeners();
  }
  
  /// Save theme preference to shared preferences
  Future<void> _saveTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String themeString;
      
      switch (_themeMode) {
        case ThemeMode.light:
          themeString = 'light';
          break;
        case ThemeMode.dark:
          themeString = 'dark';
          break;
        case ThemeMode.system:
          themeString = 'system';
          break;
      }
      
      await prefs.setString(_themeKey, themeString);
    } catch (e) {
      debugPrint('Error saving theme: $e');
    }
  }
  
  /// Get theme mode string for display
  String get themeModeString {
    switch (_themeMode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }
  
  /// Get theme mode description
  String get themeModeDescription {
    switch (_themeMode) {
      case ThemeMode.light:
        return 'Always use light theme';
      case ThemeMode.dark:
        return 'Always use dark theme';
      case ThemeMode.system:
        return 'Follow system setting';
    }
  }
}
