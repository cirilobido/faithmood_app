import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:faithmood_app/core/providers/domain/use_cases/local_storage_use_case.dart';

final hapticFeedbackProvider = ChangeNotifierProvider<HapticFeedbackProvider>((ref) {
  return HapticFeedbackProvider(ref.read(localStorageUseCaseProvider));
});

class HapticFeedbackProvider extends ChangeNotifier {
  final LocalStorageUseCase _useCase;

  HapticFeedbackProvider(this._useCase) {
    _loadData();
  }

  bool _isEnabled = true;

  bool get isEnabled => _isEnabled;

  Future<void> _loadData() async {
    _isEnabled = await _useCase.getHapticFeedbackEnabled();
    notifyListeners();
  }

  Future<void> setEnabled(bool enabled) async {
    _isEnabled = enabled;
    await _useCase.setHapticFeedbackEnabled(enabled);
    notifyListeners();
  }
}

