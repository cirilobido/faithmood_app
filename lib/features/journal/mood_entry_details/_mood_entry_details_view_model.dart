import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/core_exports.dart';
import '../../../core/providers/domain/use_cases/mood_use_case.dart';
import '../../../dev_utils/dev_utils_exports.dart';
import '_mood_entry_details_state.dart';

final moodEntryDetailsViewModelProvider =
    StateNotifierProvider.autoDispose.family<MoodEntryDetailsViewModel, MoodEntryDetailsState, String>(
  (ref, sessionId) {
    return MoodEntryDetailsViewModel(
      ref.read(moodUseCaseProvider),
      ref.read(authProvider),
      sessionId,
    );
  },
);

class MoodEntryDetailsViewModel extends StateNotifier<MoodEntryDetailsState> {
  final MoodUseCase moodUseCase;
  final AuthProvider authProvider;
  final String sessionId;
  bool _mounted = true;

  MoodEntryDetailsViewModel(
    this.moodUseCase,
    this.authProvider,
    this.sessionId,
  ) : super(MoodEntryDetailsState()) {
    loadMoodSessionDetail();
  }

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }

  void updateState({
    bool? isLoading,
    bool? error,
    MoodSession? moodSession,
    bool? isDeleting,
    bool? isEditing,
    bool? isUpdating,
    String? editedNote,
  }) {
    if (!_mounted) return;
    state = state.copyWith(
      isLoading: isLoading,
      error: error,
      moodSession: moodSession,
      isDeleting: isDeleting,
      isEditing: isEditing,
      isUpdating: isUpdating,
      editedNote: editedNote,
    );
  }

  Future<void> loadMoodSessionDetail() async {
    try {
      final userId = authProvider.user?.id;
      final userLang = authProvider.user?.lang?.name ?? 'en';
      
      if (userId == null) {
        updateState(isLoading: false, error: true);
        return;
      }

      updateState(isLoading: true, error: false);
      final result = await moodUseCase.getMoodSessionDetail(
        userId,
        sessionId,
        userLang,
      );

      switch (result) {
        case Success(value: final session):
          {
            if (!_mounted) return;
            updateState(
              isLoading: false,
              moodSession: session,
            );
          }
        case Failure(exception: final exception):
          {
            devLogger('Error loading mood session detail: $exception');
            if (!_mounted) return;
            updateState(isLoading: false, error: true);
          }
      }
    } catch (e) {
      devLogger('Error loading mood session detail: $e');
      if (!_mounted) return;
      updateState(isLoading: false, error: true);
    }
  }

  Future<bool> deleteMoodSession() async {
    try {
      final userId = authProvider.user?.id;
      if (userId == null) {
        devLogger('Error: User ID is null');
        return false;
      }

      updateState(isDeleting: true);
      final result = await moodUseCase.deleteMoodSession(userId, sessionId);

      switch (result) {
        case Success(value: final success):
          {
            if (!_mounted) return false;
            updateState(isDeleting: false);
            return success;
          }
        case Failure(exception: final exception):
          {
            devLogger('Error deleting mood session: $exception');
            if (!_mounted) return false;
            updateState(isDeleting: false);
            return false;
          }
      }
    } catch (e) {
      devLogger('Error deleting mood session: $e');
      if (!_mounted) return false;
      updateState(isDeleting: false);
      return false;
    }
  }

  void startEditing() {
    final currentNote = state.moodSession?.note ?? '';
    updateState(isEditing: true, editedNote: currentNote);
  }

  void cancelEditing() {
    updateState(isEditing: false, editedNote: null);
  }

  void updateEditedNote(String note) {
    updateState(editedNote: note);
  }

  Future<bool> updateMoodSession() async {
    try {
      final userId = authProvider.user?.id;
      if (userId == null) {
        devLogger('Error: User ID is null');
        return false;
      }

      final emotionalMoodId = state.moodSession?.emotional?.moodId;
      if (emotionalMoodId == null) {
        devLogger('Error: Emotional mood ID is null');
        return false;
      }

      updateState(isUpdating: true);
      final request = MoodSessionRequest(
        note: state.editedNote?.trim().isEmpty == true ? null : state.editedNote?.trim(),
        emotionalMoodId: emotionalMoodId,
      );

      final result = await moodUseCase.updateMoodSession(userId, sessionId, request);

      switch (result) {
        case Success(value: final updatedSession):
          {
            if (!_mounted) return false;
            final currentSession = state.moodSession;
            if (currentSession != null && updatedSession != null) {
              final updatedNote = request.note;
              final updatedMoodSession = MoodSession(
                sessionId: currentSession.sessionId,
                date: currentSession.date,
                note: updatedNote,
                emotional: currentSession.emotional,
                spiritual: currentSession.spiritual,
                aiVerse: currentSession.aiVerse,
              );
              updateState(
                isUpdating: false,
                isEditing: false,
                moodSession: updatedMoodSession,
                editedNote: null,
              );
            } else {
              updateState(
                isUpdating: false,
                isEditing: false,
                moodSession: updatedSession,
                editedNote: null,
              );
            }
            return true;
          }
        case Failure(exception: final exception):
          {
            devLogger('Error updating mood session: $exception');
            if (!_mounted) return false;
            updateState(isUpdating: false);
            return false;
          }
      }
    } catch (e) {
      devLogger('Error updating mood session: $e');
      if (!_mounted) return false;
      updateState(isUpdating: false);
      return false;
    }
  }
}

