import '../../../core/core_exports.dart';

class DevotionalLogDetailsState {
  final bool isLoading;
  final bool error;
  final DevotionalLog? devotionalLog;
  final bool isDeleting;
  final bool isEditing;
  final bool isUpdating;
  final String? editedNote;

  DevotionalLogDetailsState({
    this.isLoading = false,
    this.error = false,
    this.devotionalLog,
    this.isDeleting = false,
    this.isEditing = false,
    this.isUpdating = false,
    this.editedNote,
  });

  DevotionalLogDetailsState copyWith({
    bool? isLoading,
    bool? error,
    DevotionalLog? devotionalLog,
    bool? isDeleting,
    bool? isEditing,
    bool? isUpdating,
    String? editedNote,
  }) {
    return DevotionalLogDetailsState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      devotionalLog: devotionalLog ?? this.devotionalLog,
      isDeleting: isDeleting ?? this.isDeleting,
      isEditing: isEditing ?? this.isEditing,
      isUpdating: isUpdating ?? this.isUpdating,
      editedNote: editedNote ?? this.editedNote,
    );
  }
}

