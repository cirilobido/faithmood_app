// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:faithmood_app/core/providers/domain/use_cases/local_storage_use_case.dart';

final appLanguageProvider = ChangeNotifierProvider<AppLanguageProvider>((ref) {
  return AppLanguageProvider(ref.read(localStorageUseCaseProvider));
});

class AppLanguageProvider extends ChangeNotifier {
  final LocalStorageUseCase _useCase;

  AppLanguageProvider(this._useCase) {
    _loadData();
  }

  void _loadData() {
    _loadAppLanguage();
  }

  // Supported Languages
  final locales = const <String, Locale>{
    "Español": Locale('es', 'ES'), // Español, ES
  };

  Locale _currentLocale = const Locale("es", "ES");

  Locale get currentLocale => _currentLocale;
  bool isRTL = false;

  void _loadAppLanguage() async {
    final lang = await _useCase.getAppLanguage();
    _currentLocale = locales.values.firstWhere(
      (element) => element.languageCode == lang,
      orElse: () => Locale("es", "ES"),
    );
    notifyListeners();
  }

  void changeLocale(Locale? value) async {
    if (value == null) return;
    await _useCase.setAppLanguage(value.languageCode);
    _currentLocale = value;
    notifyListeners();
  }
}
