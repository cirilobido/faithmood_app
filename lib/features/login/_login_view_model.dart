import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/core_exports.dart';
import '../../dev_utils/dev_utils_exports.dart';
import '_login_state.dart';

final loginViewModelProvider =
    AutoDisposeStateNotifierProvider<LoginViewModel, LoginState>((ref) {
      return LoginViewModel(
        ref.read(firebaseAnalyticProvider),
        ref.read(authProvider),
        ref.read(settingsProvider),
      );
    });

class LoginViewModel extends StateNotifier<LoginState> {
  final FirebaseAnalyticProvider firebaseAnalyticProvider;
  final AuthProvider authProvider;
  final SettingsProvider settingsProvider;

  LoginViewModel(
    this.firebaseAnalyticProvider,
    this.authProvider,
    this.settingsProvider,
  ) : super(LoginState());

  bool _isFirstTimeOpen = false;

  void updateState({bool? isLoading, bool? error}) {
    state = state.copyWith(isLoading: isLoading, error: error);
  }

  Future<bool> loginUser(AuthRequest params) async {
    try {
      updateState(isLoading: true, error: false);
      await authProvider.loginUser(params);
      final result = authProvider.user;
      if (result != null) {
        await _getIsFirstTimeOpen();
        await _setIsFirstTimeOpenFalse();
        updateState(isLoading: false);
        firebaseAnalyticProvider.logEvent(
          name: 'user_login_successfully',
          parameters: {'screen': 'login_screen'},
        );
        return true;
      }
      updateState(isLoading: false);
      return false;
    } catch (e) {
      updateState(isLoading: false, error: true);
      firebaseAnalyticProvider.logEvent(
        name: 'user_login_failed',
        parameters: {'screen': 'login_screen', 'error': e.toString()},
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
        parameters: {'screen': 'login_screen', 'error': e.toString()},
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
        parameters: {'screen': 'login_screen'},
      );
    } catch (e) {
      devLogger(e.toString());
      firebaseAnalyticProvider.logEvent(
        name: 'is_first_time_open_failed',
        parameters: {'screen': 'login_screen', 'error': e.toString()},
      );
    }
  }

  Future<bool> sendOtp(AuthRequest params) async {
    try {
      updateState(isLoading: true, error: false);
      final result = await authProvider.sendOtp(params);
      firebaseAnalyticProvider.logEvent(
        name: 'otp_send_successfully',
        parameters: {'screen': 'login_screen'},
      );
      updateState(isLoading: false);
      return result;
    } catch (e) {
      updateState(isLoading: false, error: true);
      firebaseAnalyticProvider.logEvent(
        name: 'otp_send_failed',
        parameters: {'screen': 'login_screen', 'error': e.toString()},
      );
      devLogger(e.toString());
      return false;
    }
  }
}
