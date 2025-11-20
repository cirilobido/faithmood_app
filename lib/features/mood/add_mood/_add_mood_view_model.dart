import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/core_exports.dart';
import '../../../core/providers/domain/use_cases/mood_use_case.dart';
import '../../../dev_utils/dev_utils_exports.dart';
import '_add_mood_state.dart';

final hasAddedMoodProvider = FutureProvider<bool>((ref) async {
  final secureStorage = ref.read(secureStorageServiceProvider);
  final hasAddedMood = await secureStorage.getValue(key: Constant.hasAddedMoodKey);
  return hasAddedMood == 'true';
});

final addMoodViewModelProvider =
    StateNotifierProvider.autoDispose<AddMoodViewModel, AddMoodState>((ref) {
  return AddMoodViewModel(
    ref.read(moodUseCaseProvider),
    ref.read(authProvider),
    ref.read(secureStorageServiceProvider),
  );
});

class AddMoodViewModel extends StateNotifier<AddMoodState> {
  final MoodUseCase moodUseCase;
  final AuthProvider authProvider;
  final SecureStorage secureStorage;

  AddMoodViewModel(
    this.moodUseCase,
    this.authProvider,
    this.secureStorage,
  ) : super(AddMoodState()) {
    _loadMoods();
  }

  void updateState({
    bool? isLoading,
    bool? error,
    List<Mood>? moods,
    int? currentPage,
    Mood? selectedEmotionalMood,
    Mood? selectedSpiritualMood,
    String? note,
  }) {
    state = state.copyWith(
      isLoading: isLoading,
      error: error,
      moods: moods,
      currentPage: currentPage,
      selectedEmotionalMood: selectedEmotionalMood,
      selectedSpiritualMood: selectedSpiritualMood,
      note: note,
    );
  }

  Future<void> _loadMoods() async {
    try {
      updateState(isLoading: true, error: false);
      final userLang = authProvider.user?.lang?.name ?? 'en';
      final result = await moodUseCase.getMoods(userLang);

      switch (result) {
        case Success(value: final moods):
          {
            updateState(isLoading: false, moods: moods);
          }
        case Failure(exception: final exception):
          {
            devLogger('Error loading moods: $exception');
            updateState(isLoading: false, error: true);
          }
      }
    } catch (e) {
      devLogger('Error loading moods: $e');
      updateState(isLoading: false, error: true);
    }
  }

  void nextPage() {
    if (state.currentPage < 2) {
      updateState(currentPage: state.currentPage + 1);
    }
  }

  void previousPage() {
    if (state.currentPage > 0) {
      updateState(currentPage: state.currentPage - 1);
    }
  }

  void selectEmotionalMood(Mood mood) {
    updateState(selectedEmotionalMood: mood);
    if (state.currentPage == 0) {
      nextPage();
    }
  }

  void selectSpiritualMood(Mood mood) {
    updateState(selectedSpiritualMood: mood);
    if (state.currentPage == 1) {
      nextPage();
    }
  }

  bool canProceedToNextPage() {
    if (state.currentPage == 0) {
      return state.selectedEmotionalMood != null;
    } else if (state.currentPage == 1) {
      return state.selectedSpiritualMood != null;
    }
    return true;
  }

  void updateNote(String text) {
    updateState(note: text);
  }

  Future<bool> saveMood() async {
    try {
      final userId = authProvider.user?.id;
      if (userId == null) {
        devLogger('Error: User ID is null');
        return false;
      }

      final emotionalMoodId = state.selectedEmotionalMood?.id;
      final spiritualMoodId = state.selectedSpiritualMood?.id;

      if (emotionalMoodId == null || spiritualMoodId == null) {
        devLogger('Error: Mood IDs are missing');
        return false;
      }

      final request = MoodSessionRequest(
        userId: userId,
        emotionalMoodId: emotionalMoodId,
        spiritualMoodId: spiritualMoodId,
        note: state.note.trim().isEmpty ? null : state.note.trim(),
        emotionLevel: null,
      );

      final result = await moodUseCase.createMoodSession(userId, request);

      switch (result) {
        case Success(value: final response):
          {
            devLogger('Mood session created successfully: ${response?.sessionId}');
            await secureStorage.saveValue(
              key: Constant.hasAddedMoodKey,
              value: 'true',
            );
            return true;
          }
        case Failure(exception: final exception):
          {
            devLogger('Error saving mood: $exception');
            return false;
          }
      }
    } catch (e) {
      devLogger('Error saving mood: $e');
      return false;
    }
  }
}

