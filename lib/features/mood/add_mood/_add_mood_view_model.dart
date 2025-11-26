import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/core_exports.dart';
import '../../../core/providers/domain/use_cases/mood_use_case.dart';
import '../../../dev_utils/dev_utils_exports.dart';
import '../../../features/profile/_profile_view_model.dart';
import '_add_mood_state.dart';

final hasAddedMoodProvider = FutureProvider<bool>((ref) async {
  final secureStorage = ref.read(secureStorageServiceProvider);
  final hasAddedMood = await secureStorage.getValue(key: Constant.hasAddedMoodKey);
  return hasAddedMood == 'true';
});

final addMoodViewModelProvider =
    StateNotifierProvider.autoDispose<AddMoodViewModel, AddMoodState>((ref) {
  return AddMoodViewModel(
    ref,
    ref.read(moodUseCaseProvider),
    ref.read(authProvider),
    ref.read(secureStorageServiceProvider),
    ref.read(firebaseAnalyticProvider),
  );
});

class AddMoodViewModel extends StateNotifier<AddMoodState> {
  final Ref ref;
  final MoodUseCase moodUseCase;
  final AuthProvider authProvider;
  final SecureStorage secureStorage;
  final FirebaseAnalyticProvider firebaseAnalyticProvider;

  AddMoodViewModel(
    this.ref,
    this.moodUseCase,
    this.authProvider,
    this.secureStorage,
    this.firebaseAnalyticProvider,
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

  Mood? _preSelectedMood;

  void setPreSelectedMood(Mood? mood) {
    _preSelectedMood = mood;
    if (state.moods.isNotEmpty && mood != null) {
      _applyPreSelectedMood();
    }
  }

  void _applyPreSelectedMood() {
    if (_preSelectedMood != null && state.moods.isNotEmpty) {
      try {
        Mood? matchingMood;
        if (_preSelectedMood!.id != null) {
          matchingMood = state.moods.firstWhere(
            (m) => m.id == _preSelectedMood!.id,
            orElse: () => Mood(),
          );
        }
        if (matchingMood?.id == null && _preSelectedMood!.key != null) {
          try {
            matchingMood = state.moods.firstWhere(
              (m) => m.key == _preSelectedMood!.key,
            );
          } catch (e) {
            devLogger('Mood with key ${_preSelectedMood!.key} not found');
          }
        }
        if (matchingMood?.id != null) {
          updateState(selectedEmotionalMood: matchingMood);
        }
      } catch (e) {
        devLogger('Error applying pre-selected mood: $e');
      }
    }
  }

  Future<void> _loadMoods() async {
    try {
      updateState(isLoading: true, error: false);
      final userLang = authProvider.user?.lang?.name ?? Lang.en.name;
      final result = await moodUseCase.getMoods(userLang);

      switch (result) {
        case Success(value: final moods):
          {
            updateState(isLoading: false, moods: moods);
            if (_preSelectedMood != null) {
              _applyPreSelectedMood();
            }
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

  MoodSession? createPartialSession() {
    try {
      final emotionalMoodId = state.selectedEmotionalMood?.id;
      final spiritualMoodId = state.selectedSpiritualMood?.id;

      if (emotionalMoodId == null || spiritualMoodId == null) {
        devLogger('Error: Mood IDs are missing');
        return null;
      }

      final temporarySessionId = 'temp_${DateTime.now().millisecondsSinceEpoch}';
      
      return MoodSession(
        sessionId: temporarySessionId,
        date: DateTime.now(),
        note: state.note.trim().isEmpty ? null : state.note.trim(),
        emotional: MoodSessionDetails(
          moodId: emotionalMoodId,
          mood: state.selectedEmotionalMood,
          sessionId: temporarySessionId,
          aiReflection: null,
          aiVerse: null,
        ),
        spiritual: MoodSessionDetails(
          moodId: spiritualMoodId,
          mood: state.selectedSpiritualMood,
          sessionId: temporarySessionId,
          aiReflection: null,
          aiVerse: null,
        ),
        aiVerse: null,
      );
    } catch (e) {
      devLogger('Error creating partial session: $e');
      return null;
    }
  }

  Future<({MoodSession? partialSession, String? sessionId})> saveMood() async {
    try {
      // Capture all state values immediately to avoid accessing disposed state
      final userId = authProvider.user?.id;
      if (userId == null) {
        devLogger('Error: User ID is null');
        return (partialSession: null, sessionId: null);
      }

      final emotionalMoodId = state.selectedEmotionalMood?.id;
      final spiritualMoodId = state.selectedSpiritualMood?.id;
      final emotionalMood = state.selectedEmotionalMood;
      final spiritualMood = state.selectedSpiritualMood;
      final note = state.note.trim().isEmpty ? null : state.note.trim();
      final userLang = authProvider.user?.lang?.name ?? Lang.en.name;

      if (emotionalMoodId == null || spiritualMoodId == null) {
        devLogger('Error: Mood IDs are missing');
        return (partialSession: null, sessionId: null);
      }
      
      final request = MoodSessionRequest(
        userId: userId,
        emotionalMoodId: emotionalMoodId,
        spiritualMoodId: spiritualMoodId,
        note: note,
        emotionLevel: null,
        lang: userLang,
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
            ref.read(profileViewModelProvider.notifier).invalidateStats();
            
            final sessionId = response?.sessionId;
            if (sessionId == null) {
              return (partialSession: null, sessionId: null);
            }

            final partialSession = MoodSession(
              sessionId: sessionId,
              date: DateTime.now(),
              note: note,
              emotional: MoodSessionDetails(
                moodId: emotionalMoodId,
                mood: emotionalMood,
                sessionId: sessionId,
                aiReflection: null,
                aiVerse: null,
              ),
              spiritual: MoodSessionDetails(
                moodId: spiritualMoodId,
                mood: spiritualMood,
                sessionId: sessionId,
                aiReflection: null,
                aiVerse: null,
              ),
              aiVerse: null,
            );

            return (partialSession: partialSession, sessionId: sessionId);
          }
        case Failure(exception: final exception):
          {
            devLogger('Error saving mood: $exception');
            return (partialSession: null, sessionId: null);
          }
      }
    } catch (e) {
      devLogger('Error saving mood: $e');
      return (sessionId: null, partialSession: null);
    }
  }
}

