import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/core_exports.dart';
import '../../../core/providers/domain/use_cases/category_use_case.dart';
import '../../../core/providers/domain/use_cases/tag_use_case.dart';
import '../../../dev_utils/dev_utils_exports.dart';
import '_categories_state.dart';

final categoriesViewModelProvider =
    StateNotifierProvider<CategoriesViewModel, CategoriesState>((ref) {
  return CategoriesViewModel(
    ref.read(categoryUseCaseProvider),
    ref.read(tagUseCaseProvider),
    ref.read(authProvider),
  );
});

class CategoriesViewModel extends StateNotifier<CategoriesState> {
  final CategoryUseCase categoryUseCase;
  final TagUseCase tagUseCase;
  final AuthProvider authProvider;

  CategoriesViewModel(
    this.categoryUseCase,
    this.tagUseCase,
    this.authProvider,
  ) : super(CategoriesState()) {
    _loadCategories();
    _loadTags();
  }

  void updateState({
    bool? isLoading,
    bool? isLoadingTags,
    bool? error,
    List<DevotionalCategory>? categories,
    List<DevotionalTag>? tags,
    String? searchQuery,
  }) {
    state = state.copyWith(
      isLoading: isLoading,
      isLoadingTags: isLoadingTags,
      error: error,
      categories: categories,
      tags: tags,
      searchQuery: searchQuery,
    );
  }

  Future<void> _loadCategories() async {
    try {
      updateState(isLoading: true, error: false);
      final userLang = authProvider.user?.lang?.name ?? 'en';
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
      final userLang = authProvider.user?.lang?.name ?? 'en';
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

  void updateSearchQuery(String query) {
    updateState(searchQuery: query);
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

