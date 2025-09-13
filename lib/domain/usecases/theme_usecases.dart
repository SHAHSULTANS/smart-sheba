import 'package:flutter/material.dart';
import '../repositories/theme_repository.dart';

class ThemeUsecases {
  final ThemeRepository _themeRepository;

  ThemeUsecases({required ThemeRepository themeRepository})
      : _themeRepository = themeRepository;

  Future<ThemeMode> getThemeMode() async {
    return await _themeRepository.getThemeMode();
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    return await _themeRepository.setThemeMode(themeMode);
  }
}
