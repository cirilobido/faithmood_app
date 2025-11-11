// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:faithmood_app/core/providers/domain/use_cases/local_storage_use_case.dart';

import '../../dev_utils/_logger.dart';
import '../core_exports.dart';
import 'domain/use_cases/settings_use_case.dart';

final settingsProvider = ChangeNotifierProvider<SettingsProvider>((ref) {
  return SettingsProvider(
    ref.read(settingsUseCaseProvider),
    ref.read(localStorageUseCaseProvider),
  );
});

class SettingsProvider extends ChangeNotifier {
  final SettingsUseCase _useCase;
  final LocalStorageUseCase _localStorageUseCase;

  SettingsProvider(this._useCase, this._localStorageUseCase);

  Settings? _settings;

  Settings? get settings => _settings;

  bool get isBannerAdEnable => _settings?.showBannerAds ?? false;

  bool? _isFirstTimeOpen;

  bool get isFirstTimeOpen => _isFirstTimeOpen ?? false;

  Future<void> getSetting() async {
    try {
      final result = await _useCase.getSettings();
      switch (result) {
        case Success(value: final value):
          {
            if (value == null) {
              throw Exception('Error getting settings!');
            }
            _settings = value;
          }
        case Failure():
          {
            throw Exception('Error getting settings!');
          }
      }
    } catch (e) {
      devLogger(e.toString());
      rethrow;
    }
    notifyListeners();
  }

  Future<bool> getIsUserLoggedIn() async {
    return await _localStorageUseCase.getIsUserLoggedIn();
  }

  Future<bool> getIsFirstTimeOpen() async {
    _isFirstTimeOpen = await _localStorageUseCase.getIsFirstTimeOpen();
    return _isFirstTimeOpen!;
  }

  Future<void> setIsFirstTimeOpen(bool value) async {
    _isFirstTimeOpen = value;
    await _localStorageUseCase.setIsFirstTimeOpen(value);
  }
}
