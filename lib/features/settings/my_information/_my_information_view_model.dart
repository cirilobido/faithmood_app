import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/core_exports.dart';
import '../../../dev_utils/dev_utils_exports.dart';
import '_my_information_state.dart';

final myInformationViewModelProvider =
    AutoDisposeStateNotifierProvider<MyInformationViewModel,
        MyInformationState>((ref) {
  return MyInformationViewModel(
    ref.read(firebaseAnalyticProvider),
    ref.read(authProvider),
    ref.read(settingsProvider),
  );
});

class MyInformationViewModel extends StateNotifier<MyInformationState> {
  final FirebaseAnalyticProvider firebaseAnalyticProvider;
  final AuthProvider authProvider;
  final SettingsProvider settingsProvider;

  MyInformationViewModel(
    this.firebaseAnalyticProvider,
    this.authProvider,
    this.settingsProvider,
  ) : super(MyInformationState());

  Settings? get settings => settingsProvider.settings;

  void updateState({
    User? user,
    bool? isPremium,
    bool? isLoading,
    bool? error,
  }) {
    state = state.copyWith(
      user: user,
      isPremium: isPremium,
      isLoading: isLoading,
      error: error,
    );
  }

  Future<void> loadData({bool refresh = false}) async {
    updateState(isLoading: true, error: false);
    try {
      await _getUserLimitations();
      updateState(isLoading: false);
    } catch (e) {
      updateState(isLoading: false, error: true);
      devLogger(e.toString());
      firebaseAnalyticProvider.logEvent(
        name: 'load_data_failed',
        parameters: {
          'screen': 'my_information_screen',
          'error': e.toString(),
        },
      );
    }
  }

  Future<void> _getUserLimitations() async {
    try {
      final settings = settingsProvider.settings;
      if (settings != null) {
        final user = authProvider.user;
        final isPremium = user?.planType != PlanName.FREE;
        updateState(user: user, isPremium: isPremium);
        firebaseAnalyticProvider.logEvent(
          name: 'get_user_limitations_successfully',
          parameters: {'screen': 'my_information_screen'},
        );
        return;
      }
      firebaseAnalyticProvider.logEvent(
        name: 'get_user_limitations_failed',
        parameters: {'screen': 'my_information_screen'},
      );
      throw Exception('Error getting user limitations!');
    } catch (e) {
      devLogger(e.toString());
      firebaseAnalyticProvider.logEvent(
        name: 'get_user_limitations_failed',
        parameters: {
          'screen': 'my_information_screen',
          'error': e.toString(),
        },
      );
      rethrow;
    }
  }

  Future<bool> updateUserData(User params) async {
    try {
      updateState(isLoading: true, error: false);
      await authProvider.updateUserData(params);
      final user = authProvider.user;
      updateState(user: user, isLoading: false);
      return true;
    } catch (e) {
      devLogger(e.toString());
      updateState(isLoading: false, error: true);
      firebaseAnalyticProvider.logEvent(
        name: 'update_user_data_failed',
        parameters: {'screen': 'my_information_screen'},
      );
      return false;
    }
  }

  Future<bool> deleteAccount() async {
    try {
      await authProvider.deleteUser(authProvider.user!.id!);
      return true;
    } catch (e) {
      devLogger(e.toString());
      firebaseAnalyticProvider.logEvent(
        name: 'delete_user_failed',
        parameters: {'screen': 'my_information_screen'},
      );
      return false;
    }
  }
}

