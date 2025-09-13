// lib/data/datasources/theme_local_datasource.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ThemeLocalDataSource {
  Future<ThemeMode> getThemeMode();
  Future<void> setThemeMode(ThemeMode themeMode);
}

class ThemeLocalDataSourceImpl implements ThemeLocalDataSource {
  final SharedPreferences sharedPreferences;

  ThemeLocalDataSourceImpl({required this.sharedPreferences});

  static const String _themeKey = 'THEME_MODE';

  @override
  Future<ThemeMode> getThemeMode() async {
    final themeString = sharedPreferences.getString(_themeKey);
    switch (themeString) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  @override
  Future<void> setThemeMode(ThemeMode themeMode) async {
    String themeString;
    switch (themeMode) {
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
    await sharedPreferences.setString(_themeKey, themeString);
  }
}
