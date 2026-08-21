import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppThemeMode {
  system,
  light,
  dark,
}

class ThemeProvider extends ChangeNotifier {
  static const _keyThemeMode = 'grozzby_theme_mode';
  static const _keyHighContrast = 'grozzby_high_contrast';
  static const _keyDynamicFontSize = 'grozzby_dynamic_font_size';

  AppThemeMode _themeMode = AppThemeMode.light;
  bool _highContrast = false;
  bool _dynamicFontSize = true;

  AppThemeMode get appThemeMode => _themeMode;
  bool get highContrast => _highContrast;
  bool get dynamicFontSize => _dynamicFontSize;

  ThemeMode get themeMode {
    switch (_themeMode) {
      case AppThemeMode.system:
        return ThemeMode.system;
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
    }
  }

  bool isDarkMode(BuildContext context) {
    if (_themeMode == AppThemeMode.dark) return true;
    if (_themeMode == AppThemeMode.light) return false;
    return MediaQuery.platformBrightnessOf(context) == Brightness.dark;
  }

  Future<void> init(SharedPreferences prefs) async {
    final savedMode = prefs.getString(_keyThemeMode);
    if (savedMode != null) {
      if (savedMode == 'dark') {
        _themeMode = AppThemeMode.dark;
      } else if (savedMode == 'system') {
        _themeMode = AppThemeMode.system;
      } else {
        _themeMode = AppThemeMode.light;
      }
    }
    _highContrast = prefs.getBool(_keyHighContrast) ?? false;
    _dynamicFontSize = prefs.getBool(_keyDynamicFontSize) ?? true;
    notifyListeners();
  }

  Future<void> setThemeMode(AppThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    String modeString = 'light';
    if (mode == AppThemeMode.dark) modeString = 'dark';
    if (mode == AppThemeMode.system) modeString = 'system';
    await prefs.setString(_keyThemeMode, modeString);
  }

  Future<void> setHighContrast(bool enabled) async {
    if (_highContrast == enabled) return;
    _highContrast = enabled;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyHighContrast, enabled);
  }

  Future<void> setDynamicFontSize(bool enabled) async {
    if (_dynamicFontSize == enabled) return;
    _dynamicFontSize = enabled;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyDynamicFontSize, enabled);
  }
}
