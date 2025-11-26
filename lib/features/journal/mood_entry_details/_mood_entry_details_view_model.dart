import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/core_exports.dart';
import '../../../core/providers/domain/use_cases/mood_use_case.dart';
import '../../../dev_utils/dev_utils_exports.dart';
import '../../../generated/l10n.dart';
import '_mood_entry_details_state.dart';

final moodEntryDetailsViewModelProvider =
    StateNotifierProvider.autoDispose.family<MoodEntryDetailsViewModel, MoodEntryDetailsState, ({MoodSession? initialSession, Future<({MoodSession? partialSession, String? sessionId})>? saveFuture, String sessionId})>(
  (ref, params) {
    final viewModel = MoodEntryDetailsViewModel(
      ref,
      ref.read(moodUseCaseProvider),
      ref.read(authProvider),
      ref.read(ttsServiceProvider),
      ref.read(firebaseAnalyticProvider),
      params.sessionId,
      params.initialSession,
      params.saveFuture,
    );
    ref.onDispose(() {
      viewModel._mounted = false;
      viewModel.dispose();
    });
    return viewModel;
  },
);

class MoodEntryDetailsViewModel extends StateNotifier<MoodEntryDetailsState> {
  final Ref ref;
  final MoodUseCase moodUseCase;
  final AuthProvider authProvider;
  final TtsService ttsService;
  final FirebaseAnalyticProvider firebaseAnalyticProvider;
  String _sessionId;
  String get sessionId => _sessionId;
  final MoodSession? initialSession;
  final Future<({MoodSession? partialSession, String? sessionId})>? saveFuture;
  bool _mounted = true;
  int _pollAttempts = 0;
  static const int _maxPollAttempts = 20;
  static const Duration _pollInterval = Duration(seconds: 3);

  MoodEntryDetailsViewModel(
    this.ref,
    this.moodUseCase,
    this.authProvider,
    this.ttsService,
    this.firebaseAnalyticProvider,
    String sessionId,
    this.initialSession,
    this.saveFuture,
  ) : _sessionId = sessionId,
        super(MoodEntryDetailsState()) {
    if (initialSession != null) {
      final session = initialSession;
      final emotionalReflection = session?.emotional?.aiReflection;
      final spiritualReflection = session?.spiritual?.aiReflection;
      final hasReflection = (emotionalReflection != null && emotionalReflection.isNotEmpty) || 
                           (spiritualReflection != null && spiritualReflection.isNotEmpty);
      final hasVerse = session?.emotional?.aiVerse != null;
      
      updateState(
        moodSession: session,
        isLoadingVerse: !hasVerse,
        isLoadingLearning: !hasReflection,
      );
      
      if (saveFuture != null) {
        _handleSaveFuture();
      } else if (!_sessionId.startsWith('temp_')) {
        _startPollingForVerseAndLearning();
      }
    } else {
      loadMoodSessionDetail();
    }
    _syncTtsState();
  }

  Future<void> _handleSaveFuture() async {
    try {
      final result = await saveFuture;
      
      if (result != null && result.sessionId != null && result.partialSession != null && _mounted) {
        final realSessionId = result.sessionId!;
        _sessionId = realSessionId;
        
        final userId = authProvider.user?.id;
        final userLang = authProvider.user?.lang?.name ?? Lang.en.name;
        
        if (userId != null) {
          final detailResult = await moodUseCase.getMoodSessionDetail(
            userId,
            realSessionId,
            userLang,
          );
          
          switch (detailResult) {
            case Success(value: final session):
              {
                if (!_mounted) return;
                
                final emotionalVerse = session?.emotional?.aiVerse;
                final emotionalReflection = session?.emotional?.aiReflection;
                final spiritualReflection = session?.spiritual?.aiReflection;
                
                final hasVerse = emotionalVerse != null;
                final hasReflection = (emotionalReflection != null && emotionalReflection.isNotEmpty) || 
                                     (spiritualReflection != null && spiritualReflection.isNotEmpty);
                
                updateState(
                  moodSession: session,
                  saveError: false,
                  isLoadingVerse: !hasVerse,
                  isLoadingLearning: !hasReflection,
                );
                
                firebaseAnalyticProvider.logEvent(
                  name: 'mood_session_created',
                  parameters: {
                    'session_id': realSessionId,
                    'screen': 'mood_entry_details_screen',
                    'emotional_mood_id': session?.emotional?.moodId?.toString() ?? '',
                    'spiritual_mood_id': session?.spiritual?.moodId?.toString() ?? '',
                    'has_verse': hasVerse ? 'true' : 'false',
                    'has_reflection': hasReflection ? 'true' : 'false',
                    'has_note': (session?.note != null && session!.note!.isNotEmpty) ? 'true' : 'false',
                  },
                );
                
                if (!hasVerse || !hasReflection) {
                  _pollAttempts = 0;
                  _startPollingForVerseAndLearning();
                }
              }
            case Failure(exception: final exception):
              {
                devLogger('Error fetching mood session detail: $exception');
                if (!_mounted) return;
                final partialSession = result.partialSession!;
                updateState(
                  moodSession: partialSession,
                  saveError: false,
                  isLoadingVerse: true,
                  isLoadingLearning: true,
                );
                _pollAttempts = 0;
                _startPollingForVerseAndLearning();
              }
          }
        } else {
          if (!_mounted) return;
          final partialSession = result.partialSession!;
          updateState(
            moodSession: partialSession,
            saveError: false,
            isLoadingVerse: true,
            isLoadingLearning: true,
          );
          _pollAttempts = 0;
          _startPollingForVerseAndLearning();
        }
      } else if (_mounted) {
        updateState(saveError: true);
      }
    } catch (e) {
      devLogger('Error handling save future: $e');
      if (_mounted) {
        updateState(saveError: true);
      }
    }
  }

  @override
  void dispose() {
    _mounted = false;
    ttsService.onStateChanged = null;
    ttsService.onProgressChanged = null;
    ttsService.stop();
    super.dispose();
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

  String _formatMoodEntryText(MoodSession session, String userLang) {
    final buffer = StringBuffer();

    if (session.emotional?.aiVerse != null) {
      final verse = session.emotional?.aiVerse;
      final verseRef = verse?.getFormattedRef();
      if (verseRef?.isNotEmpty == true) {
        buffer.writeln(verseRef);
      }

      VerseTranslation? translation;
      if (verse?.translations != null && verse?.translations?.isNotEmpty == true) {
        translation = verse?.translations?.firstWhere(
          (t) => t.lang == userLang,
          orElse: () => verse.translations?.first ?? VerseTranslation(),
        );
      }

      final verseText = translation?.text ?? verse?.text ?? '';
      if (verseText.isNotEmpty) {
        buffer.writeln(verseText);
      }
      buffer.writeln();
    }

    final emotionalMood = session.emotional?.mood;
    final spiritualMood = session.spiritual?.mood;

    String getMoodName(Mood? mood) {
      if (mood == null) return '';
      return mood.translations?.first.name ?? mood.name ?? '';
    }

    final emotionalMoodName = getMoodName(emotionalMood);
    final spiritualMoodName = getMoodName(spiritualMood);

    if (emotionalMoodName.isNotEmpty || spiritualMoodName.isNotEmpty) {
      if (emotionalMoodName.isNotEmpty) {
        buffer.writeln('Feeling: $emotionalMoodName');
      }
      if (spiritualMoodName.isNotEmpty) {
        buffer.writeln('Spirit: $spiritualMoodName');
      }
      buffer.writeln();
    }

    final aiReflection =
        session.emotional?.aiReflection ?? session.spiritual?.aiReflection;
    if (aiReflection != null && aiReflection.isNotEmpty) {
      buffer.writeln(aiReflection);
    }

    return buffer.toString().trim();
  }

  Future<void> playTTS() async {
    final session = state.moodSession;
    if (session == null) return;

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
      await ttsService.setLanguage(userLang);
      
      final text = _formatMoodEntryText(session, userLang);
      if (text.isEmpty) {
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

      
  String getMoodName(Mood? mood) {
    if (mood == null) return '';
    return mood.translations?.first.name ?? mood.name ?? '';
  }

  Future<void> shareMoodVerse({
    required S lang,
  }) async {
    final session = state.moodSession;
    if (session == null || session.emotional?.aiVerse == null) return;

    try {
      final userLang = authProvider.user?.lang?.name ?? Lang.en;
      final settings = ref.read(settingsProvider);
      final shareUrl = settings.settings?.shareUrl;
      final verse = session.emotional?.aiVerse;

      final emotionalMood = session.emotional?.mood;
      final moodName = getMoodName(emotionalMood);
      
      VerseTranslation? translation;
      if (verse?.translations != null && verse?.translations?.isNotEmpty == true) {
        translation = verse?.translations?.firstWhere(
          (t) => t.lang == userLang,
          orElse: () => verse.translations!.first,
        );
      }

      final verseText = translation?.text ?? verse?.text ?? '';
      final verseRef = translation?.ref ?? verse?.ref;
      
      if (verseText.isEmpty) {
        return;
      }

      final buffer = StringBuffer();
      if (moodName.isNotEmpty) {
        final feelText = lang.whenYouFeelLookAtThisVerse;
        buffer.writeln(feelText.replaceAll('###', moodName));
        buffer.writeln();
      }

      if (verseRef != null && verseRef.isNotEmpty) {
        buffer.writeln(verseRef);
      }
      buffer.writeln(verseText);

      buffer.writeln();
      buffer.writeln(session.emotional?.aiReflection ?? '');
      
      if (shareUrl != null && shareUrl.isNotEmpty) {
        buffer.writeln();
        final downloadText = lang.downloadFaithmoodApp;
        buffer.writeln(downloadText.replaceAll('###', shareUrl));
      }

      await SharePlus.instance.share(
        ShareParams(
          title: lang.appName,
          text: buffer.toString().trim(),
        ),
      );
    } catch (e) {
      devLogger('Error sharing mood verse: $e');
    }
  }

  void updateState({
    bool? isLoading,
    bool? error,
    MoodSession? moodSession,
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
    bool? isLoadingVerse,
    bool? isLoadingLearning,
    bool? saveError,
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
      isPlaying: isPlaying,
      isPaused: isPaused,
      isStopped: isStopped,
      currentPosition: currentPosition,
      totalLength: totalLength,
      progress: progress,
      isLoadingVerse: isLoadingVerse,
      isLoadingLearning: isLoadingLearning,
      saveError: saveError,
    );
  }

  Future<void> _startPollingForVerseAndLearning() async {
    if (!_mounted) {
      return;
    }
    
    final userId = authProvider.user?.id;
    if (userId == null) {
      updateState(isLoadingVerse: false, isLoadingLearning: false, error: true);
      return;
    }

    final userLang = authProvider.user?.lang?.name ?? Lang.en.name;
    
    while (_pollAttempts < _maxPollAttempts && _mounted) {
      await Future.delayed(_pollInterval);
      _pollAttempts++;
      
      if (!_mounted) return;
      
      try {
        if (_sessionId.startsWith('temp_')) {
          continue;
        }
        
        final result = await moodUseCase.getMoodSessionDetail(
          userId,
          _sessionId,
          userLang,
        );

        switch (result) {
          case Success(value: final session):
            {
              if (!_mounted) return;
              
              final emotionalVerse = session?.emotional?.aiVerse;
              final emotionalReflection = session?.emotional?.aiReflection;
              final spiritualReflection = session?.spiritual?.aiReflection;
              
              final hasVerse = emotionalVerse != null;
              final hasReflection = (emotionalReflection != null && emotionalReflection.isNotEmpty) || 
                                   (spiritualReflection != null && spiritualReflection.isNotEmpty);
              
              if (hasVerse && hasReflection) {
                updateState(
                  moodSession: session,
                  isLoadingVerse: false,
                  isLoadingLearning: false,
                );
                return;
              } else {
                final currentSession = state.moodSession;
                if (currentSession != null) {
                  final updatedSession = MoodSession(
                    sessionId: currentSession.sessionId,
                    date: currentSession.date,
                    note: currentSession.note,
                    emotional: session?.emotional ?? currentSession.emotional,
                    spiritual: session?.spiritual ?? currentSession.spiritual,
                    aiVerse: emotionalVerse ?? session?.aiVerse,
                  );
                  updateState(
                    moodSession: updatedSession,
                    isLoadingVerse: !hasVerse,
                    isLoadingLearning: !hasReflection,
                  );
                }
              }
            }
          case Failure(exception: final exception):
            {
              devLogger('Error polling mood session detail: $exception');
            }
        }
      } catch (e) {
        devLogger('Error polling mood session detail: $e');
      }
    }
    
    if (_mounted && (_pollAttempts >= _maxPollAttempts)) {
      updateState(
        isLoadingVerse: false,
        isLoadingLearning: false,
        error: true,
      );
    }
  }

  Future<void> loadMoodSessionDetail() async {
    try {
      final userId = authProvider.user?.id;
      final userLang = authProvider.user?.lang?.name ?? Lang.en.name;
      
      if (userId == null) {
        updateState(isLoading: false, error: true);
        return;
      }

      updateState(isLoading: true, error: false);
      final result = await moodUseCase.getMoodSessionDetail(
        userId,
        _sessionId,
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
      final result = await moodUseCase.deleteMoodSession(userId, _sessionId);

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

      final result = await moodUseCase.updateMoodSession(userId, _sessionId, request);

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
                aiVerse: currentSession.emotional?.aiVerse,
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

  Future<void> retrySave() async {
    final session = state.moodSession;
    if (session == null) return;

    try {
      final userId = authProvider.user?.id;
      if (userId == null) {
        updateState(saveError: true);
        return;
      }

      final emotionalMoodId = session.emotional?.moodId;
      final spiritualMoodId = session.spiritual?.moodId;

      if (emotionalMoodId == null || spiritualMoodId == null) {
        updateState(saveError: true);
        return;
      }

      final userLang = authProvider.user?.lang?.name ?? Lang.en.name;
      
      final request = MoodSessionRequest(
        userId: userId,
        emotionalMoodId: emotionalMoodId,
        spiritualMoodId: spiritualMoodId,
        note: session.note,
        emotionLevel: null,
        lang: userLang,
      );

      updateState(saveError: false);
      final result = await moodUseCase.createMoodSession(userId, request);

      switch (result) {
        case Success(value: final response):
          {
            if (!_mounted) return;
            final newSessionId = response?.sessionId;
            if (newSessionId != null) {
              _sessionId = newSessionId;
              final updatedSession = MoodSession(
                sessionId: newSessionId,
                date: session.date,
                note: session.note,
                emotional: session.emotional,
                spiritual: session.spiritual,
                aiVerse: null,
              );
              updateState(
                moodSession: updatedSession,
                saveError: false,
                isLoadingVerse: true,
                isLoadingLearning: true,
              );
              _pollAttempts = 0;
              _startPollingForVerseAndLearning();
            } else {
              updateState(saveError: true);
            }
          }
        case Failure(exception: final exception):
          {
            devLogger('Error retrying save: $exception');
            if (!_mounted) return;
            updateState(saveError: true);
          }
      }
    } catch (e) {
      devLogger('Error retrying save: $e');
      if (!_mounted) return;
      updateState(saveError: true);
    }
  }
}

