import '../../../core/core_exports.dart';

class CategoriesState {
  bool isLoading;
  bool isLoadingTags;
  bool error;
  List<DevotionalCategory> categories;
  List<Tag> tags;
  String searchQuery;

  CategoriesState({
    this.isLoading = false,
    this.isLoadingTags = false,
    this.error = false,
    this.categories = const [],
    this.tags = const [],
    this.searchQuery = '',
  });

  CategoriesState copyWith({
    bool? isLoading,
    bool? isLoadingTags,
    bool? error,
    List<DevotionalCategory>? categories,
    List<Tag>? tags,
    String? searchQuery,
  }) {
    return CategoriesState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingTags: isLoadingTags ?? this.isLoadingTags,
      error: error ?? this.error,
      categories: categories ?? this.categories,
      tags: tags ?? this.tags,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

