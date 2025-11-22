import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/core_exports.dart';
import '../../../core/providers/domain/use_cases/local_storage_use_case.dart';
import '../../../dev_utils/dev_utils_exports.dart';
import '_reminder_state.dart';

final reminderViewModelProvider =
    AutoDisposeStateNotifierProvider<ReminderViewModel, ReminderState>((ref) {
  return ReminderViewModel(
    ref.read(firebaseAnalyticProvider),
    ref.read(localStorageUseCaseProvider),
  );
});

class ReminderViewModel extends StateNotifier<ReminderState> {
  final FirebaseAnalyticProvider firebaseAnalyticProvider;
  final LocalStorageUseCase localStorageUseCase;

  ReminderViewModel(
    this.firebaseAnalyticProvider,
    this.localStorageUseCase,
  ) : super(ReminderState());

  Future<void> loadData() async {
    updateState(isLoading: true, error: false);
    try {
      final time = await localStorageUseCase.getReminderTime();
      updateState(time: time, isLoading: false);
      firebaseAnalyticProvider.logEvent(
        name: 'load_reminder_data_successfully',
        parameters: {'screen': 'reminder_screen'},
      );
    } catch (e) {
      updateState(isLoading: false, error: true);
      devLogger(e.toString());
      firebaseAnalyticProvider.logEvent(
        name: 'load_reminder_data_failed',
        parameters: {
          'screen': 'reminder_screen',
          'error': e.toString(),
        },
      );
    }
  }

  void updateState({
    String? time,
    bool? isLoading,
    bool? error,
  }) {
    state = state.copyWith(
      time: time,
      isLoading: isLoading,
      error: error,
    );
  }

  Future<void> updateTime(TimeOfDay time) async {
    try {
      final formattedTime = DateHelper.formatTimeOfDay(time);
      await localStorageUseCase.setReminderTime(formattedTime);
      updateState(time: formattedTime);
      firebaseAnalyticProvider.logEvent(
        name: 'update_reminder_time_successfully',
        parameters: {
          'screen': 'reminder_screen',
          'time': formattedTime,
        },
      );
    } catch (e) {
      devLogger(e.toString());
      firebaseAnalyticProvider.logEvent(
        name: 'update_reminder_time_failed',
        parameters: {
          'screen': 'reminder_screen',
          'error': e.toString(),
        },
      );
      rethrow;
    }
  }

  Future<void> deleteReminderTime() async {
    try {
      await localStorageUseCase.deleteReminderTime();
      state = ReminderState(
        time: null,
        isLoading: false,
        error: false,
      );
      firebaseAnalyticProvider.logEvent(
        name: 'delete_reminder_time_successfully',
        parameters: {'screen': 'reminder_screen'},
      );
    } catch (e) {
      devLogger(e.toString());
      firebaseAnalyticProvider.logEvent(
        name: 'delete_reminder_time_failed',
        parameters: {
          'screen': 'reminder_screen',
          'error': e.toString(),
        },
      );
      rethrow;
    }
  }
}

