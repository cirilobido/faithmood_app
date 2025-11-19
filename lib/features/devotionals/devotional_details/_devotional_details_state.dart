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

  DevotionalDetailsState({
    this.isLoading = false,
    this.error = false,
    this.devotional,
    this.reflectionText = '',
    this.isSaving = false,
    this.isSaved = false,
    this.hasUnsavedChanges = false,
    this.isFavorite = false,
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
    );
  }
}

