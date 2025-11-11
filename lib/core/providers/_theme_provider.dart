// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appThemeProvider = ChangeNotifierProvider<AppThemeProvider>((ref) {
  return AppThemeProvider();
});

class AppThemeProvider extends ChangeNotifier {

  AppThemeProvider();

  final ThemeMode _themeMode = ThemeMode.dark;

  ThemeMode get themeMode => _themeMode;

  bool get isDarkTheme => _themeMode == ThemeMode.dark;
}
