import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/core_exports.dart';
import '../../core/providers/domain/use_cases/category_use_case.dart';
import '../../core/providers/domain/use_cases/tag_use_case.dart';
import '../../dev_utils/dev_utils_exports.dart';
import '_devotionals_state.dart';

final devotionalsViewModelProvider =
    StateNotifierProvider<DevotionalsViewModel, DevotionalsState>((ref) {
      return DevotionalsViewModel(
        ref.read(categoryUseCaseProvider),
        ref.read(tagUseCaseProvider),
        ref.read(authProvider),
      );
    });

class DevotionalsViewModel extends StateNotifier<DevotionalsState> {
  final CategoryUseCase categoryUseCase;
  final TagUseCase tagUseCase;
  final AuthProvider authProvider;

  DevotionalsViewModel(this.categoryUseCase, this.tagUseCase, this.authProvider)
    : super(DevotionalsState()) {
    _initializeData();
  }

  void _initializeData() {
    _loadCategories();
    _loadTags();
  }

  Future<void> _loadCategories() async {
    try {
      updateState(isLoading: true, error: false);
      final userLang = authProvider.user?.lang?.name ?? 'en';
      final result = await categoryUseCase.getCategories(userLang);

      switch (result) {
        case Success(value: final categories):
          {
            // Filter only active categories and sort by order
            final activeCategories =
                categories.where((cat) => cat.isActive == true).toList()
                  ..sort((a, b) => (a.order ?? 0).compareTo(b.order ?? 0));

            devLogger('Loaded ${activeCategories.length} categories');
            updateState(isLoading: false, categories: activeCategories);
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

  void updateState({
    bool? isLoading,
    bool? error,
    List<DevotionalCategory>? categories,
    List<DevotionalTag>? tags,
    String? selectedTag,
    String? searchQuery,
    bool? isLoadingTags,
    bool? errorTags,
  }) {
    state = state.copyWith(
      isLoading: isLoading,
      error: error,
      categories: categories,
      tags: tags,
      selectedTag: selectedTag,
      searchQuery: searchQuery,
      isLoadingTags: isLoadingTags,
      errorTags: errorTags,
    );
  }

  void updateSearchQuery(String query) {
    updateState(searchQuery: query);
  }

  void selectTag(String? tag) {
    updateState(selectedTag: tag);
  }

  void clearSearch() {
    updateState(searchQuery: '');
  }

  /// Get filtered categories based on search query
  /// Filters by title or description (case-insensitive)
  List<DevotionalCategory> getFilteredCategories() {
    final query = state.searchQuery.trim().toLowerCase();
    if (query.isEmpty) {
      return state.categories;
    }

    return state.categories.where((category) {
      final title = (category.title ?? '').toLowerCase();
      final description = (category.description ?? '').toLowerCase();
      return title.contains(query) || description.contains(query);
    }).toList();
  }

  Future<void> _loadTags() async {
    try {
      updateState(isLoadingTags: true, errorTags: false);
      final userLang = authProvider.user?.lang?.name ?? 'en';
      final result = await tagUseCase.getTags(userLang);

      switch (result) {
        case Success(value: final tags):
          {
            // Filter only active tags
            final activeTags = tags
                .where((tag) => tag.isActive == true)
                .toList();

            updateState(isLoadingTags: false, tags: activeTags);
          }
        case Failure(exception: final exception):
          {
            devLogger('Error loading tags: $exception');
            updateState(isLoadingTags: false, errorTags: true);
          }
      }
    } catch (e) {
      devLogger('Error loading tags: $e');
      updateState(isLoadingTags: false, errorTags: true);
    }
  }
}
