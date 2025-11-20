import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/core_exports.dart';
import '../../../core/providers/domain/use_cases/devotional_use_case.dart';
import '../../../dev_utils/dev_utils_exports.dart';
import '_devotional_log_details_state.dart';

final devotionalLogDetailsViewModelProvider =
    StateNotifierProvider.autoDispose.family<DevotionalLogDetailsViewModel, DevotionalLogDetailsState, int>(
  (ref, id) {
    final viewModel = DevotionalLogDetailsViewModel(
      ref.read(devotionalUseCaseProvider),
      ref.read(authProvider),
      id,
    );
    ref.onDispose(() {
      viewModel._mounted = false;
    });
    return viewModel;
  },
);

class DevotionalLogDetailsViewModel extends StateNotifier<DevotionalLogDetailsState> {
  final DevotionalUseCase devotionalUseCase;
  final AuthProvider authProvider;
  final int id;
  bool _mounted = true;

  DevotionalLogDetailsViewModel(
    this.devotionalUseCase,
    this.authProvider,
    this.id,
  ) : super(DevotionalLogDetailsState()) {
    loadDevotionalLogDetail();
  }

  void updateState({
    bool? isLoading,
    bool? error,
    DevotionalLog? devotionalLog,
    bool? isDeleting,
    bool? isEditing,
    bool? isUpdating,
    String? editedNote,
  }) {
    if (!_mounted) return;
    state = state.copyWith(
      isLoading: isLoading,
      error: error,
      devotionalLog: devotionalLog,
      isDeleting: isDeleting,
      isEditing: isEditing,
      isUpdating: isUpdating,
      editedNote: editedNote,
    );
  }

  Future<void> loadDevotionalLogDetail() async {
    try {
      final userId = authProvider.user?.id;
      final userLang = authProvider.user?.lang?.name ?? 'en';

      if (userId == null) {
        updateState(isLoading: false, error: true);
        return;
      }

      updateState(isLoading: true, error: false);
      final result = await devotionalUseCase.getDevotionalLogDetail(
        userId,
        id,
        userLang,
      );

      if (!_mounted) return;
      switch (result) {
        case Success(value: final log):
          {
            updateState(
              isLoading: false,
              devotionalLog: log,
              editedNote: log?.note,
            );
          }
        case Failure(exception: final exception):
          {
            devLogger('Error loading devotional log detail: $exception');
            updateState(isLoading: false, error: true);
          }
      }
    } catch (e) {
      devLogger('Error loading devotional log detail: $e');
      if (!_mounted) return;
      updateState(isLoading: false, error: true);
    }
  }

  Future<bool> deleteDevotionalLog() async {
    try {
      final userId = authProvider.user?.id;
      if (userId == null) {
        devLogger('Error: User ID is null');
        return false;
      }

      updateState(isDeleting: true);
      final result = await devotionalUseCase.deleteDevotionalLog(userId, id);

      if (!_mounted) return false;
      switch (result) {
        case Success(value: final success):
          {
            updateState(isDeleting: false);
            return success;
          }
        case Failure(exception: final exception):
          {
            devLogger('Error deleting devotional log: $exception');
            updateState(isDeleting: false);
            return false;
          }
      }
    } catch (e) {
      devLogger('Error deleting devotional log: $e');
      if (!_mounted) return false;
      updateState(isDeleting: false);
      return false;
    }
  }

  void startEditing() {
    updateState(isEditing: true, editedNote: state.devotionalLog?.note);
  }

  void cancelEditing() {
    updateState(isEditing: false, editedNote: state.devotionalLog?.note);
  }

  void updateEditedNote(String note) {
    updateState(editedNote: note);
  }

  Future<bool> updateDevotionalLog() async {
    try {
      final userId = authProvider.user?.id;
      if (userId == null) {
        devLogger('Error: User ID is null');
        return false;
      }

      updateState(isUpdating: true);
      final request = DevotionalLogUpdateRequest(
        note: state.editedNote?.trim().isEmpty == true ? null : state.editedNote?.trim(),
      );

      final result = await devotionalUseCase.updateDevotionalLog(userId, id, request);

      if (!_mounted) return false;
      switch (result) {
        case Success(value: final updatedLog):
          {
            if (updatedLog != null) {
              updateState(
                isUpdating: false,
                isEditing: false,
                devotionalLog: updatedLog,
                editedNote: null,
              );
              return true;
            }
            final currentLog = state.devotionalLog;
            if (currentLog != null) {
              final updatedNote = request.note;
              final newDevotionalLog = DevotionalLog(
                id: currentLog.id,
                userId: currentLog.userId,
                devotional: currentLog.devotional,
                isFavorite: currentLog.isFavorite,
                isCompleted: currentLog.isCompleted,
                note: updatedNote,
                completedAt: currentLog.completedAt,
                createdAt: currentLog.createdAt,
                updatedAt: currentLog.updatedAt,
              );
              updateState(
                isUpdating: false,
                isEditing: false,
                devotionalLog: newDevotionalLog,
                editedNote: null,
              );
              return true;
            }
            updateState(isUpdating: false);
            return false;
          }
        case Failure(exception: final exception):
          {
            devLogger('Error updating devotional log: $exception');
            updateState(isUpdating: false);
            return false;
          }
      }
    } catch (e) {
      devLogger('Error updating devotional log: $e');
      if (!_mounted) return false;
      updateState(isUpdating: false);
      return false;
    }
  }
}

