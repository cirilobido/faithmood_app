import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/core_exports.dart';
import '../../dev_utils/dev_utils_exports.dart';
import '_welcome_state.dart';

final welcomeViewModelProvider =
    AutoDisposeStateNotifierProvider<WelcomeViewModel, WelcomeState>((ref) {
      return WelcomeViewModel(
        ref.read(firebaseAnalyticProvider),
        ref.read(authProvider),
        ref.read(settingsProvider),
      );
    });

class WelcomeViewModel extends StateNotifier<WelcomeState> {
  final FirebaseAnalyticProvider firebaseAnalyticProvider;
  final AuthProvider authProvider;
  final SettingsProvider settingsProvider;

  WelcomeViewModel(
    this.firebaseAnalyticProvider,
    this.authProvider,
    this.settingsProvider,
  ) : super(WelcomeState());

  bool get isFirstTimeOpen => settingsProvider.isFirstTimeOpen;

  void updateState({bool? isLoading, bool? error}) {
    state = state.copyWith(isLoading: isLoading, error: error);
  }

  Future<void> getIsFirstTimeOpen() async {
    try {
      await settingsProvider.getIsFirstTimeOpen();
    } catch (e) {
      firebaseAnalyticProvider.logEvent(
        name: 'is_first_time_open_failed',
        parameters: {'screen': 'welcome_screen', 'error': e.toString()},
      );
      devLogger(e.toString());
    }
  }

  Future<void> setIsFirstTimeOpenFalse() async {
    try {
      updateState(isLoading: true, error: false);
      await settingsProvider.setIsFirstTimeOpen(false);
      firebaseAnalyticProvider.logEvent(
        name: 'is_first_time_open_false',
        parameters: {'screen': 'welcome_screen'},
      );
      updateState(isLoading: false);
    } catch (e) {
      updateState(isLoading: false, error: true);
      devLogger(e.toString());
      firebaseAnalyticProvider.logEvent(
        name: 'is_first_time_open_false_failed',
        parameters: {'screen': 'welcome_screen', 'error': e.toString()},
      );
    }
  }

  Future<void> skipTapEvent() async {
    try {
      firebaseAnalyticProvider.logEvent(
        name: 'on_skip_tap_successfully',
        parameters: {'screen': 'welcome_screen'},
      );
    } catch (e) {
      devLogger(e.toString());
      firebaseAnalyticProvider.logEvent(
        name: 'on_skip_tap_failed',
        parameters: {'screen': 'welcome_screen', 'error': e.toString()},
      );
    }
  }
}
