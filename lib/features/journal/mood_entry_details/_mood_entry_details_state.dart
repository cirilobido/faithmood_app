import '../../../core/core_exports.dart';

class MoodEntryDetailsState {
  final bool isLoading;
  final bool error;
  final MoodSession? moodSession;
  final bool isDeleting;
  final bool isEditing;
  final bool isUpdating;
  final String? editedNote;

  MoodEntryDetailsState({
    this.isLoading = false,
    this.error = false,
    this.moodSession,
    this.isDeleting = false,
    this.isEditing = false,
    this.isUpdating = false,
    this.editedNote,
  });

  MoodEntryDetailsState copyWith({
    bool? isLoading,
    bool? error,
    MoodSession? moodSession,
    bool? isDeleting,
    bool? isEditing,
    bool? isUpdating,
    String? editedNote,
  }) {
    return MoodEntryDetailsState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      moodSession: moodSession ?? this.moodSession,
      isDeleting: isDeleting ?? this.isDeleting,
      isEditing: isEditing ?? this.isEditing,
      isUpdating: isUpdating ?? this.isUpdating,
      editedNote: editedNote ?? this.editedNote,
    );
  }
}

