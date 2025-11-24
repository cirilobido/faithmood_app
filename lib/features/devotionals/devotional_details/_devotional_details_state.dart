import '../../../core/core_exports.dart';

class DevotionalDetailsState {
  bool isLoading;
  bool error;
  Devotional? devotional;
  String reflectionText;
  bool isSaving;
  bool isSaved;
  bool hasUnsavedChanges;
  bool isFavorite;
  bool isPlaying;
  bool isPaused;
  bool isStopped;
  int currentPosition;
  int totalLength;
  double progress;
  String? selectedVoiceId;
  List<Map<String, String>> availableVoices;

  DevotionalDetailsState({
    this.isLoading = false,
    this.error = false,
    this.devotional,
    this.reflectionText = '',
    this.isSaving = false,
    this.isSaved = false,
    this.hasUnsavedChanges = false,
    this.isFavorite = false,
    this.isPlaying = false,
    this.isPaused = false,
    this.isStopped = true,
    this.currentPosition = 0,
    this.totalLength = 0,
    this.progress = 0.0,
    this.selectedVoiceId,
    this.availableVoices = const [],
  });

  DevotionalDetailsState copyWith({
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
    return DevotionalDetailsState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      devotional: devotional ?? this.devotional,
      reflectionText: reflectionText ?? this.reflectionText,
      isSaving: isSaving ?? this.isSaving,
      isSaved: isSaved ?? this.isSaved,
      hasUnsavedChanges: hasUnsavedChanges ?? this.hasUnsavedChanges,
      isFavorite: isFavorite ?? this.isFavorite,
      isPlaying: isPlaying ?? this.isPlaying,
      isPaused: isPaused ?? this.isPaused,
      isStopped: isStopped ?? this.isStopped,
      currentPosition: currentPosition ?? this.currentPosition,
      totalLength: totalLength ?? this.totalLength,
      progress: progress ?? this.progress,
      selectedVoiceId: selectedVoiceId ?? this.selectedVoiceId,
      availableVoices: availableVoices ?? this.availableVoices,
    );
  }
}

