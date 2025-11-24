import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/core_exports.dart';
import '../../../core/providers/domain/use_cases/devotional_use_case.dart';
import '../../../dev_utils/dev_utils_exports.dart';
import '../../../features/profile/_profile_view_model.dart';
import '_devotional_details_state.dart';

final devotionalDetailsViewModelProvider = StateNotifierProvider.autoDispose.family<
    DevotionalDetailsViewModel, DevotionalDetailsState, int>((ref, devotionalId) {
  return DevotionalDetailsViewModel(
    ref,
    ref.read(devotionalUseCaseProvider),
    ref.read(authProvider),
    ref.read(ttsServiceProvider),
    devotionalId,
  );
});

class DevotionalDetailsViewModel extends StateNotifier<DevotionalDetailsState> {
  final Ref ref;
  final DevotionalUseCase devotionalUseCase;
  final AuthProvider authProvider;
  final TtsService ttsService;
  final int devotionalId;

  DevotionalDetailsViewModel(
    this.ref,
    this.devotionalUseCase,
    this.authProvider,
    this.ttsService,
    this.devotionalId,
  ) : super(DevotionalDetailsState()) {
    _loadDevotional();
    ttsService.onStateChanged = _syncTtsState;
    ttsService.onProgressChanged = _onProgressChanged;
  }

  void _syncTtsState() {
    updateState(
      isPlaying: ttsService.isPlaying,
      isPaused: ttsService.isPaused,
      isStopped: !ttsService.isPlaying && !ttsService.isPaused,
      currentPosition: ttsService.currentPosition,
      totalLength: ttsService.totalLength,
      progress: ttsService.progress,
    );
  }

  void _onProgressChanged(double progress) {
    updateState(
      progress: progress,
      currentPosition: ttsService.currentPosition,
      totalLength: ttsService.totalLength,
    );
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
    bool? isPlaying,
    bool? isPaused,
    bool? isStopped,
    int? currentPosition,
    int? totalLength,
    double? progress,
    String? selectedVoiceId,
    List<Map<String, String>>? availableVoices,
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
      isPlaying: isPlaying,
      isPaused: isPaused,
      isStopped: isStopped,
      currentPosition: currentPosition,
      totalLength: totalLength,
      progress: progress,
      selectedVoiceId: selectedVoiceId,
      availableVoices: availableVoices,
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
            if (success) {
              ref.read(profileViewModelProvider.notifier).invalidateStats();
            }
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
            if (success) {
              ref.read(profileViewModelProvider.notifier).invalidateStats();
            }
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

  String _formatDevotionalText(Devotional devotional, String userLang) {
    final buffer = StringBuffer();

    if (devotional.title != null && devotional.title!.isNotEmpty) {
      buffer.writeln(devotional.title!);
      buffer.writeln();
    }

    if (devotional.verses != null && devotional.verses!.isNotEmpty) {
      for (final verse in devotional.verses!) {
        final verseRef = verse.getFormattedRef();
        if (verseRef.isNotEmpty) {
          buffer.writeln(verseRef);
        }

        VerseTranslation? translation;
        if (verse.translations != null && verse.translations!.isNotEmpty) {
          translation = verse.translations!.firstWhere(
            (t) => t.lang == userLang,
            orElse: () => verse.translations!.first,
          );
        }

        final verseText = translation?.text ?? verse.text ?? '';
        if (verseText.isNotEmpty) {
          buffer.writeln(verseText);
        }
        buffer.writeln();
      }
    }

    if (devotional.content != null && devotional.content!.isNotEmpty) {
      buffer.writeln(devotional.content!);
      buffer.writeln();
    }

    if (devotional.reflection != null && devotional.reflection!.isNotEmpty) {
      buffer.writeln(devotional.reflection!);
    }

    return buffer.toString().trim();
  }

  Future<void> playTTS() async {
    final devotional = state.devotional;
    if (devotional == null) return;

    try {
      if (state.isPaused) {
        final success = await ttsService.resume();
        if (success) {
          updateState(
            isPlaying: true,
            isPaused: false,
            isStopped: false,
          );
        }
        return;
      }

      final userLang = authProvider.user?.lang?.name ?? 'en';
      final languageSet = await ttsService.setLanguage(userLang);
      
      if (!languageSet) {
        devLogger('Failed to set TTS language');
      }


      final text = _formatDevotionalText(devotional, userLang);
      if (text.isEmpty) {
        devLogger('No text to speak');
        return;
      }

      final success = await ttsService.speak(text);
      if (success) {
        updateState(
          isPlaying: true,
          isPaused: false,
          isStopped: false,
          totalLength: ttsService.totalLength,
          currentPosition: 0,
          progress: 0.0,
        );
      } else {
        updateState(
          isPlaying: false,
          isPaused: false,
          isStopped: true,
        );
      }
    } catch (e) {
      devLogger('Error playing TTS: $e');
      updateState(
        isPlaying: false,
        isPaused: false,
        isStopped: true,
      );
    }
  }

  Future<void> pauseTTS() async {
    try {
      final success = await ttsService.pause();
      if (success) {
        updateState(
          isPlaying: false,
          isPaused: true,
          isStopped: false,
        );
      }
    } catch (e) {
      devLogger('Error pausing TTS: $e');
    }
  }

  Future<void> stopTTS() async {
    try {
      final success = await ttsService.stop();
      if (success) {
        updateState(
          isPlaying: false,
          isPaused: false,
          isStopped: true,
          currentPosition: 0,
          progress: 0.0,
        );
      }
    } catch (e) {
      devLogger('Error stopping TTS: $e');
      updateState(
        isPlaying: false,
        isPaused: false,
        isStopped: true,
        currentPosition: 0,
        progress: 0.0,
      );
    }
  }

  Future<void> seekToPosition(double progress) async {
    try {
      if (state.totalLength == 0) return;

      final position = (progress * state.totalLength).round();
      final wasPlaying = state.isPlaying || state.isPaused;
      
      updateState(
        isPlaying: true,
        isPaused: false,
        isStopped: false,
        currentPosition: position,
        progress: progress,
      );

      final success = await ttsService.seekToPosition(position);
      if (!success && wasPlaying) {
        updateState(
          isPlaying: false,
          isPaused: true,
          isStopped: false,
        );
      }
    } catch (e) {
      devLogger('Error seeking TTS: $e');
      final wasPlaying = state.isPlaying || state.isPaused;
      if (wasPlaying) {
        updateState(
          isPlaying: false,
          isPaused: true,
          isStopped: false,
        );
      }
    }
  }


  @override
  void dispose() {
    ttsService.onStateChanged = null;
    ttsService.onProgressChanged = null;
    ttsService.stop();
    super.dispose();
  }
}

