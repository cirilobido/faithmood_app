import '../../../core/core_exports.dart';

class ClearCategorySentinel {
  const ClearCategorySentinel();
}

const clearCategory = ClearCategorySentinel();

class CategoriesState {
  bool isLoading;
  bool isLoadingTags;
  bool isLoadingMore;
  bool error;
  List<DevotionalCategory> categories;
  List<Tag> tags;
  List<Devotional> devotionals;
  String searchQuery;
  List<Tag> selectedTags;
  DevotionalCategory? selectedCategory;
  bool isSearchVisible;
  int page;
  int? totalPages;
  bool hasMore;

  CategoriesState({
    this.isLoading = false,
    this.isLoadingTags = false,
    this.isLoadingMore = false,
    this.error = false,
    this.categories = const [],
    this.tags = const [],
    this.devotionals = const [],
    this.searchQuery = '',
    this.selectedTags = const [],
    this.selectedCategory,
    this.isSearchVisible = false,
    this.page = 1,
    this.totalPages,
    this.hasMore = true,
  });

  CategoriesState copyWith({
    bool? isLoading,
    bool? isLoadingTags,
    bool? isLoadingMore,
    bool? error,
    List<DevotionalCategory>? categories,
    List<Tag>? tags,
    List<Devotional>? devotionals,
    String? searchQuery,
    List<Tag>? selectedTags,
    Object? selectedCategory,
    bool? isSearchVisible,
    int? page,
    int? totalPages,
    bool? hasMore,
  }) {
    return CategoriesState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingTags: isLoadingTags ?? this.isLoadingTags,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error ?? this.error,
      categories: categories ?? this.categories,
      tags: tags ?? this.tags,
      devotionals: devotionals ?? this.devotionals,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedTags: selectedTags ?? this.selectedTags,
      selectedCategory: selectedCategory is DevotionalCategory
          ? selectedCategory
          : selectedCategory is ClearCategorySentinel
              ? null
              : this.selectedCategory,
      isSearchVisible: isSearchVisible ?? this.isSearchVisible,
      page: page ?? this.page,
      totalPages: totalPages ?? this.totalPages,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

