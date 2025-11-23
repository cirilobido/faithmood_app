import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:faithmood_app/core/providers/domain/use_cases/local_storage_use_case.dart';

final appThemeProvider = ChangeNotifierProvider<AppThemeProvider>((ref) {
  return AppThemeProvider(ref.read(localStorageUseCaseProvider));
});

class AppThemeProvider extends ChangeNotifier {
  final LocalStorageUseCase _useCase;

  AppThemeProvider(this._useCase) {
    _loadData();
  }

  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  bool get isDarkTheme => _themeMode == ThemeMode.dark;

  Future<void> _loadData() async {
    final storedMode = await _useCase.getThemeMode();
    if (storedMode != null) {
      _themeMode = _themeModeFromString(storedMode);
    } else {
      _themeMode = ThemeMode.system;
    }
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    _useCase.setThemeMode(_themeModeToString(mode));
    notifyListeners();
  }

  ThemeMode _themeModeFromString(String mode) {
    switch (mode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      default:
        return ThemeMode.system;
    }
  }

  String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }
}
