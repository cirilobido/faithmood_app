import '../../core/core_exports.dart';

class DevotionalsState {
  bool isLoading;
  bool error;
  List<DevotionalTag> tags;
  String? selectedTag;
  String searchQuery;
  List<DevotionalCategory> categories;
  bool isLoadingTags;
  bool errorTags;

  DevotionalsState({
    this.isLoading = false,
    this.error = false,
    this.tags = const [],
    this.selectedTag,
    this.searchQuery = '',
    this.categories = const [],
    this.isLoadingTags = false,
    this.errorTags = false,
  });

  DevotionalsState copyWith({
    bool? isLoading,
    bool? error,
    List<DevotionalTag>? tags,
    String? selectedTag,
    String? searchQuery,
    List<DevotionalCategory>? categories,
    bool? isLoadingTags,
    bool? errorTags,
  }) {
    return DevotionalsState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      tags: tags ?? this.tags,
      selectedTag: selectedTag,
      searchQuery: searchQuery ?? this.searchQuery,
      categories: categories ?? this.categories,
      isLoadingTags: isLoadingTags ?? this.isLoadingTags,
      errorTags: errorTags ?? this.errorTags,
    );
  }
}

