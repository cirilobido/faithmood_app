import '../../../core/core_exports.dart';

class MoodEntryDetailsState {
  final bool isLoading;
  final bool error;
  final MoodSession? moodSession;
  final bool isDeleting;
  final bool isEditing;
  final bool isUpdating;
  final String? editedNote;
  final bool isPlaying;
  final bool isPaused;
  final bool isStopped;
  final int currentPosition;
  final int totalLength;
  final double progress;
  final bool isLoadingVerse;
  final bool isLoadingLearning;
  final bool saveError;

  MoodEntryDetailsState({
    this.isLoading = false,
    this.error = false,
    this.moodSession,
    this.isDeleting = false,
    this.isEditing = false,
    this.isUpdating = false,
    this.editedNote,
    this.isPlaying = false,
    this.isPaused = false,
    this.isStopped = true,
    this.currentPosition = 0,
    this.totalLength = 0,
    this.progress = 0.0,
    this.isLoadingVerse = false,
    this.isLoadingLearning = false,
    this.saveError = false,
  });

  MoodEntryDetailsState copyWith({
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
    return MoodEntryDetailsState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      moodSession: moodSession ?? this.moodSession,
      isDeleting: isDeleting ?? this.isDeleting,
      isEditing: isEditing ?? this.isEditing,
      isUpdating: isUpdating ?? this.isUpdating,
      editedNote: editedNote ?? this.editedNote,
      isPlaying: isPlaying ?? this.isPlaying,
      isPaused: isPaused ?? this.isPaused,
      isStopped: isStopped ?? this.isStopped,
      currentPosition: currentPosition ?? this.currentPosition,
      totalLength: totalLength ?? this.totalLength,
      progress: progress ?? this.progress,
      isLoadingVerse: isLoadingVerse ?? this.isLoadingVerse,
      isLoadingLearning: isLoadingLearning ?? this.isLoadingLearning,
      saveError: saveError ?? this.saveError,
    );
  }
}

