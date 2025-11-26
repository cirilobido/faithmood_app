import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/core_exports.dart';
import '../../../core/providers/domain/use_cases/devotional_use_case.dart';
import '../../../dev_utils/dev_utils_exports.dart';
import '../../../features/profile/_profile_view_model.dart';
import '_devotional_log_details_state.dart';

final devotionalLogDetailsViewModelProvider =
    StateNotifierProvider.autoDispose.family<DevotionalLogDetailsViewModel, DevotionalLogDetailsState, int>(
  (ref, id) {
    final viewModel = DevotionalLogDetailsViewModel(
      ref.read(devotionalUseCaseProvider),
      ref.read(authProvider),
      ref.read(ttsServiceProvider),
      id,
      ref,
    );
    ref.onDispose(() {
      viewModel._mounted = false;
      viewModel.dispose();
    });
    return viewModel;
  },
);

class DevotionalLogDetailsViewModel extends StateNotifier<DevotionalLogDetailsState> {
  final DevotionalUseCase devotionalUseCase;
  final AuthProvider authProvider;
  final TtsService ttsService;
  final int id;
  final Ref ref;
  bool _mounted = true;

  DevotionalLogDetailsViewModel(
    this.devotionalUseCase,
    this.authProvider,
    this.ttsService,
    this.id,
    this.ref,
  ) : super(DevotionalLogDetailsState()) {
    loadDevotionalLogDetail();
    _syncTtsState();
  }

  void updateState({
    bool? isLoading,
    bool? error,
    DevotionalLog? devotionalLog,
    bool? isDeleting,
    bool? isEditing,
    bool? isUpdating,
    String? editedNote,
    bool? isPlaying,
    bool? isPaused,
    bool? isStopped,
    int? currentPosition,
    int? totalLength,
    double? progress,
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
      isPlaying: isPlaying,
      isPaused: isPaused,
      isStopped: isStopped,
      currentPosition: currentPosition,
      totalLength: totalLength,
      progress: progress,
    );
  }

  Future<void> loadDevotionalLogDetail() async {
    try {
      final userId = authProvider.user?.id;
      final userLang = authProvider.user?.lang?.name ?? Lang.en.name;

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
              ref.read(profileViewModelProvider.notifier).invalidateStats();
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
              ref.read(profileViewModelProvider.notifier).invalidateStats();
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

  void _syncTtsState() {
    ttsService.onStateChanged = () {
      if (!_mounted) return;
      updateState(
        isPlaying: ttsService.isPlaying,
        isPaused: ttsService.isPaused,
        isStopped: !ttsService.isPlaying && !ttsService.isPaused,
        currentPosition: ttsService.currentPosition,
        totalLength: ttsService.totalLength,
        progress: ttsService.progress,
      );
    };

    ttsService.onProgressChanged = (progress) {
      if (!_mounted) return;
      updateState(
        currentPosition: ttsService.currentPosition,
        totalLength: ttsService.totalLength,
        progress: progress,
      );
    };
  }

  String _formatDevotionalLogText(DevotionalLog log, String userLang) {
    final buffer = StringBuffer();
    final devotional = log.devotional;
    if (devotional == null) return '';

    if (devotional.verses != null && devotional.verses!.isNotEmpty) {
      for (final verseRelationship in devotional.verses!) {
        final verse = verseRelationship.verse;
        if (verse == null) continue;

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

    if (devotional.title != null && devotional.title!.isNotEmpty) {
      buffer.writeln(devotional.title!);
      buffer.writeln();
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
    final log = state.devotionalLog;
    if (log == null) return;

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

      final userLang = authProvider.user?.lang?.name ?? Lang.en.name;
      final languageSet = await ttsService.setLanguage(userLang);
      
      if (!languageSet) {
        devLogger('Failed to set TTS language');
      }

      final text = _formatDevotionalLogText(log, userLang);
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

