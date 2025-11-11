import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/core_exports.dart';
import '../../dev_utils/dev_utils_exports.dart';
import '_sign_up_state.dart';

final signUpViewModelProvider =
    AutoDisposeStateNotifierProvider<SignUpViewModel, SignUpState>((ref) {
      return SignUpViewModel(
        ref.read(firebaseAnalyticProvider),
        ref.read(authProvider),
        ref.read(settingsProvider),
      );
    });

class SignUpViewModel extends StateNotifier<SignUpState> {
  final FirebaseAnalyticProvider firebaseAnalyticProvider;
  final AuthProvider authProvider;
  final SettingsProvider settingsProvider;

  SignUpViewModel(
    this.firebaseAnalyticProvider,
    this.authProvider,
    this.settingsProvider,
  ) : super(SignUpState());

  bool _isFirstTimeOpen = false;

  void updateState({bool? isLoading, bool? error}) {
    state = state.copyWith(isLoading: isLoading, error: error);
  }

  Future<bool> registerUser(AuthRequest params) async {
    try {
      updateState(isLoading: true, error: false);
      await authProvider.registerUser(params);
      final result = authProvider.user;
      if (result != null) {
        await _getIsFirstTimeOpen();
        await _setIsFirstTimeOpenFalse();
        updateState(isLoading: false);
        firebaseAnalyticProvider.logEvent(
          name: 'user_registrarion_successfully',
          parameters: {'screen': 'welcome_screen'},
        );
        return true;
      }
      updateState(isLoading: false);
      return false;
    } catch (e) {
      updateState(isLoading: false, error: true);
      firebaseAnalyticProvider.logEvent(
        name: 'user_registrarion_failed',
        parameters: {'screen': 'welcome_screen', 'error': e.toString()},
      );
      devLogger(e.toString());
      return false;
    }
  }

  Future<void> _getIsFirstTimeOpen() async {
    try {
      final isFirstTimeOpen = await settingsProvider.getIsFirstTimeOpen();
      _isFirstTimeOpen = isFirstTimeOpen;
    } catch (e) {
      firebaseAnalyticProvider.logEvent(
        name: 'is_first_time_open_failed',
        parameters: {'screen': 'welcome_screen', 'error': e.toString()},
      );
      devLogger(e.toString());
    }
  }

  Future<void> _setIsFirstTimeOpenFalse() async {
    try {
      if (!_isFirstTimeOpen) return;
      await settingsProvider.setIsFirstTimeOpen(false);
      firebaseAnalyticProvider.logEvent(
        name: 'is_first_time_open_successfully',
        parameters: {'screen': 'welcome_screen'},
      );
      _isFirstTimeOpen = false;
    } catch (e) {
      devLogger(e.toString());
      firebaseAnalyticProvider.logEvent(
        name: 'is_first_time_open_failed',
        parameters: {'screen': 'welcome_screen', 'error': e.toString()},
      );
    }
  }
}
