import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/core_exports.dart';
import '../../../core/providers/domain/use_cases/devotional_use_case.dart';
import '../../../dev_utils/dev_utils_exports.dart';
import '_devotional_details_state.dart';

final devotionalDetailsViewModelProvider = StateNotifierProvider.autoDispose.family<
    DevotionalDetailsViewModel, DevotionalDetailsState, int>((ref, devotionalId) {
  return DevotionalDetailsViewModel(
    ref.read(devotionalUseCaseProvider),
    ref.read(authProvider),
    devotionalId,
  );
});

class DevotionalDetailsViewModel extends StateNotifier<DevotionalDetailsState> {
  final DevotionalUseCase devotionalUseCase;
  final AuthProvider authProvider;
  final int devotionalId;

  DevotionalDetailsViewModel(
    this.devotionalUseCase,
    this.authProvider,
    this.devotionalId,
  ) : super(DevotionalDetailsState()) {
    _loadDevotional();
  }

  void updateState({
    bool? isLoading,
    bool? error,
    Devotional? devotional,
    String? reflectionText,
    bool? isSaving,
    bool? isSaved,
    bool? hasUnsavedChanges,
    bool? isFavorite,
  }) {
    state = state.copyWith(
      isLoading: isLoading,
      error: error,
      devotional: devotional,
      reflectionText: reflectionText,
      isSaving: isSaving,
      isSaved: isSaved,
      hasUnsavedChanges: hasUnsavedChanges,
      isFavorite: isFavorite,
    );
  }

  Future<void> _loadDevotional() async {
    try {
      updateState(isLoading: true, error: false);
      final userLang = authProvider.user?.lang?.name ?? 'en';
      final result = await devotionalUseCase.getDevotionalById(devotionalId, userLang);

      switch (result) {
        case Success(value: final devotional):
          {
            updateState(
              isLoading: false,
              devotional: devotional,
            );
          }
        case Failure(exception: final exception):
          {
            devLogger('Error loading devotional: $exception');
            updateState(isLoading: false, error: true);
          }
      }
    } catch (e) {
      devLogger('Error loading devotional: $e');
      updateState(isLoading: false, error: true);
    }
  }

  void updateReflectionText(String text) {
    final hasChanges = text != (state.devotional?.reflection ?? '');
    updateState(
      reflectionText: text,
      hasUnsavedChanges: hasChanges,
      isSaved: false,
    );
  }

  Future<bool> saveReflection({String? note}) async {
    try {
      updateState(isSaving: true);
      final userId = authProvider.user?.id;
      if (userId == null) {
        updateState(isSaving: false);
        return false;
      }

      final noteText = note ?? state.reflectionText;
      final request = DevotionalLogRequest(
        devotionalId: devotionalId,
        isFavorite: state.isFavorite,
        isCompleted: true,
        note: noteText.isNotEmpty ? noteText : null,
      );

      final result = await devotionalUseCase.saveDevotionalLog(userId, request);

      switch (result) {
        case Success(value: final success):
          {
            updateState(
              isSaving: false,
              isSaved: success,
              hasUnsavedChanges: false,
            );
            return success;
          }
        case Failure(exception: final exception):
          {
            devLogger('Error saving reflection: $exception');
            updateState(isSaving: false);
            return false;
          }
      }
    } catch (e) {
      devLogger('Error saving reflection: $e');
      updateState(isSaving: false);
      return false;
    }
  }

  Future<bool> saveNoteWithoutReflection() async {
    try {
      updateState(isSaving: true);
      final userId = authProvider.user?.id;
      if (userId == null) {
        updateState(isSaving: false);
        return false;
      }

      final request = DevotionalLogRequest(
        devotionalId: devotionalId,
        isFavorite: state.isFavorite,
        isCompleted: true,
        note: null,
      );

      final result = await devotionalUseCase.saveDevotionalLog(userId, request);

      switch (result) {
        case Success(value: final success):
          {
            updateState(
              isSaving: false,
              isSaved: success,
              hasUnsavedChanges: false,
            );
            return success;
          }
        case Failure(exception: final exception):
          {
            devLogger('Error saving note without reflection: $exception');
            updateState(isSaving: false);
            return false;
          }
      }
    } catch (e) {
      devLogger('Error saving note without reflection: $e');
      updateState(isSaving: false);
      return false;
    }
  }

  void toggleFavorite() {
    updateState(isFavorite: !state.isFavorite);
  }
}

