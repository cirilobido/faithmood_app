import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/core_exports.dart';
import '../../../core/providers/domain/use_cases/category_use_case.dart';
import '../../../core/providers/domain/use_cases/tag_use_case.dart';
import '../../../core/providers/domain/use_cases/devotional_use_case.dart';
import '../../../dev_utils/dev_utils_exports.dart';
import '_categories_state.dart' show CategoriesState, clearCategory;

final categoriesViewModelProvider =
    StateNotifierProvider<CategoriesViewModel, CategoriesState>((ref) {
  return CategoriesViewModel(
    ref.read(categoryUseCaseProvider),
    ref.read(tagUseCaseProvider),
    ref.read(devotionalUseCaseProvider),
    ref.read(authProvider),
  );
});

class CategoriesViewModel extends StateNotifier<CategoriesState> {
  final CategoryUseCase categoryUseCase;
  final TagUseCase tagUseCase;
  final DevotionalUseCase devotionalUseCase;
  final AuthProvider authProvider;
  static const int limit = 15;

  CategoriesViewModel(
    this.categoryUseCase,
    this.tagUseCase,
    this.devotionalUseCase,
    this.authProvider,
  ) : super(CategoriesState()) {
    _loadCategories();
    _loadTags();
    _loadDevotionals();
  }

  void updateState({
    bool? isLoading,
    bool? isLoadingTags,
    bool? isLoadingMore,
    bool? error,
    List<DevotionalCategory>? categories,
    List<Tag>? tags,
    List<Devotional>? devotionals,
    String? searchQuery,
    List<Tag>? selectedTags,
    DevotionalCategory? selectedCategory,
    Object? selectedCategoryToClear,
    bool? isSearchVisible,
    int? page,
    int? totalPages,
    bool? hasMore,
  }) {
    state = state.copyWith(
      isLoading: isLoading,
      isLoadingTags: isLoadingTags,
      isLoadingMore: isLoadingMore,
      error: error,
      categories: categories,
      tags: tags,
      devotionals: devotionals,
      searchQuery: searchQuery,
      selectedTags: selectedTags,
      selectedCategory: selectedCategoryToClear ?? selectedCategory,
      isSearchVisible: isSearchVisible,
      page: page,
      totalPages: totalPages,
      hasMore: hasMore,
    );
  }

  Future<void> _loadCategories() async {
    try {
      updateState(isLoading: true, error: false);
      final userLang = authProvider.user?.lang?.name ?? Lang.en.name;
      final result = await categoryUseCase.getCategories(userLang);

      switch (result) {
        case Success(value: final categories):
          {
            updateState(
              isLoading: false,
              categories: categories,
            );
          }
        case Failure(exception: final exception):
          {
            devLogger('Error loading categories: $exception');
            updateState(isLoading: false, error: true);
          }
      }
    } catch (e) {
      devLogger('Error loading categories: $e');
      updateState(isLoading: false, error: true);
    }
  }

  Future<void> _loadTags() async {
    try {
      updateState(isLoadingTags: true);
      final userLang = authProvider.user?.lang?.name ?? Lang.en.name;
      final result = await tagUseCase.getTags(userLang);

      switch (result) {
        case Success(value: final tags):
          {
            updateState(isLoadingTags: false, tags: tags);
          }
        case Failure(exception: final exception):
          {
            devLogger('Error loading tags: $exception');
            updateState(isLoadingTags: false);
          }
      }
    } catch (e) {
      devLogger('Error loading tags: $e');
      updateState(isLoadingTags: false);
    }
  }

  Future<void> _loadDevotionals() async {
    try {
      updateState(isLoading: true, error: false, page: 1);
      final userLang = authProvider.user?.lang?.name ?? Lang.en.name;
      final tagsParam = state.selectedTags
          .where((tag) => tag.key != null && tag.key!.isNotEmpty)
          .map((tag) => tag.key!)
          .join(',');
      final result = await devotionalUseCase.getAllDevotionals(
        userLang,
        page: 1,
        limit: limit,
        categoryId: state.selectedCategory?.id,
        tags: tagsParam.isEmpty ? null : tagsParam,
      );

      switch (result) {
        case Success(value: final response):
          {
            final devotionalsList = response.results ?? [];
            final currentPage = response.page ?? 1;
            final totalPages = response.totalPages ?? 1;
            final hasMore = currentPage < totalPages;
            updateState(
              isLoading: false,
              devotionals: devotionalsList,
              page: currentPage,
              totalPages: totalPages,
              hasMore: hasMore,
            );
          }
        case Failure(exception: final exception):
          {
            devLogger('Error loading devotionals: $exception');
            updateState(isLoading: false, error: true);
          }
      }
    } catch (e) {
      devLogger('Error loading devotionals: $e');
      updateState(isLoading: false, error: true);
    }
  }

  Future<void> refresh() async {
    await _loadDevotionals();
  }

  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoadingMore || state.isLoading) return;

    try {
      updateState(isLoadingMore: true);
      final userLang = authProvider.user?.lang?.name ?? Lang.en.name;
      final nextPage = state.page + 1;
      final tagsParam = state.selectedTags
          .where((tag) => tag.key != null && tag.key!.isNotEmpty)
          .map((tag) => tag.key!)
          .join(',');
      final result = await devotionalUseCase.getAllDevotionals(
        userLang,
        page: nextPage,
        limit: limit,
        categoryId: state.selectedCategory?.id,
        tags: tagsParam.isEmpty ? null : tagsParam,
      );

      switch (result) {
        case Success(value: final response):
          {
            final newDevotionals = response.results ?? [];
            final currentPage = response.page ?? nextPage;
            final totalPages = response.totalPages ?? 1;
            final hasMore = currentPage < totalPages;
            updateState(
              isLoadingMore: false,
              devotionals: [...state.devotionals, ...newDevotionals],
              page: currentPage,
              totalPages: totalPages,
              hasMore: hasMore,
            );
          }
        case Failure(exception: final exception):
          {
            devLogger('Error loading more devotionals: $exception');
            updateState(isLoadingMore: false);
          }
      }
    } catch (e) {
      devLogger('Error loading more devotionals: $e');
      updateState(isLoadingMore: false);
    }
  }

  void updateSearchQuery(String query) {
    updateState(searchQuery: query);
  }

  void toggleSearchVisibility() {
    updateState(
      isSearchVisible: !state.isSearchVisible,
      searchQuery: state.isSearchVisible ? '' : state.searchQuery,
    );
  }

  void selectTag(Tag tag) {
    final currentTags = List<Tag>.from(state.selectedTags);
    if (currentTags.any((t) => t.id == tag.id)) {
      currentTags.removeWhere((t) => t.id == tag.id);
    } else {
      currentTags.add(tag);
    }
    updateState(selectedTags: currentTags);
    _loadDevotionals();
  }

  void setSelectedTags(List<Tag> tags) {
    updateState(selectedTags: tags);
    _loadDevotionals();
  }

  void selectCategory(DevotionalCategory? category) {
    if (category != null) {
      updateState(selectedCategory: category);
    } else {
      updateState(selectedCategoryToClear: clearCategory);
    }
    _loadDevotionals();
  }

  void clearFilters() {
    updateState(selectedTags: const [], selectedCategoryToClear: clearCategory);
    _loadDevotionals();
  }

  List<Devotional> getFilteredDevotionals() {
    if (state.searchQuery.trim().isEmpty) {
      return state.devotionals;
    }

    final query = state.searchQuery.toLowerCase().trim();
    return state.devotionals.where((devotional) {
      final title = devotional.title?.toLowerCase() ?? '';
      final content = devotional.content?.toLowerCase() ?? '';
      return title.contains(query) || content.contains(query);
    }).toList();
  }

  List<DevotionalCategory> getFilteredCategories() {
    if (state.searchQuery.trim().isEmpty) {
      return state.categories;
    }

    final query = state.searchQuery.toLowerCase().trim();
    return state.categories.where((category) {
      final title = category.title?.toLowerCase() ?? '';
      final description = category.description?.toLowerCase() ?? '';
      return title.contains(query) || description.contains(query);
    }).toList();
  }
}

