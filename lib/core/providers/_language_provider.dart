// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selah_app/core/providers/domain/use_cases/local_storage_use_case.dart';
import 'package:selah_app/core/core_exports.dart';

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

  Locale _currentLocale = const Locale("en");

  Locale get currentLocale => _currentLocale;
  bool isRTL = false;

  static Locale langToLocale(Lang lang) {
    switch (lang) {
      case Lang.en:
        return const Locale('en');
      case Lang.es:
        return const Locale('es');
      case Lang.pt:
        return const Locale('pt');
    }
  }

  static Lang? localeToLang(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return Lang.en;
      case 'es':
        return Lang.es;
      case 'pt':
        return Lang.pt;
      default:
        return null;
    }
  }

  void _loadAppLanguage() async {
    final langCode = await _useCase.getAppLanguage();
    _currentLocale = _getLocaleFromLanguageCode(langCode ?? 'en');
    notifyListeners();
  }

  Locale _getLocaleFromLanguageCode(String langCode) {
    switch (langCode) {
      case 'en':
        return const Locale('en');
      case 'es':
        return const Locale('es');
      case 'pt':
        return const Locale('pt');
      default:
        return const Locale('en');
    }
  }

  void changeLocale(Locale? value) async {
    if (value == null) return;
    await _useCase.setAppLanguage(value.languageCode);
    _currentLocale = value;
    notifyListeners();
  }
}
