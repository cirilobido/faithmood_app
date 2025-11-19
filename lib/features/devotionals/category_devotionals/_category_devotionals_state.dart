import '../../../core/core_exports.dart';

class CategoryDevotionalsState {
  bool isLoading;
  bool isLoadingMore;
  bool error;
  DevotionalCategory? category;
  DevotionalTag? tag;
  List<Devotional> devotionals;
  int page;
  int limit;
  int? totalPages;
  bool hasMore;

  CategoryDevotionalsState({
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error = false,
    this.category,
    this.tag,
    this.devotionals = const [],
    this.page = 1,
    this.limit = 10,
    this.totalPages,
    this.hasMore = true,
  });

  CategoryDevotionalsState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    bool? error,
    DevotionalCategory? category,
    DevotionalTag? tag,
    List<Devotional>? devotionals,
    int? page,
    int? limit,
    int? totalPages,
    bool? hasMore,
  }) {
    return CategoryDevotionalsState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error ?? this.error,
      category: category ?? this.category,
      tag: tag ?? this.tag,
      devotionals: devotionals ?? this.devotionals,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      totalPages: totalPages ?? this.totalPages,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

