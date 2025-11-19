import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/core_exports.dart';
import '../../../core/providers/domain/use_cases/devotional_use_case.dart';
import '../../../dev_utils/dev_utils_exports.dart';
import '_category_devotionals_state.dart';

final categoryDevotionalsViewModelProvider = StateNotifierProvider.autoDispose.family<
    CategoryDevotionalsViewModel, CategoryDevotionalsState,
    ({DevotionalCategory? category, DevotionalTag? tag})>((ref, params) {
  return CategoryDevotionalsViewModel(
    ref.read(devotionalUseCaseProvider),
    ref.read(authProvider),
    params.category,
    params.tag,
  );
});

class CategoryDevotionalsViewModel extends StateNotifier<CategoryDevotionalsState> {
  final DevotionalUseCase devotionalUseCase;
  final AuthProvider authProvider;
  final DevotionalCategory? category;
  final DevotionalTag? tag;

  CategoryDevotionalsViewModel(
    this.devotionalUseCase,
    this.authProvider,
    this.category,
    this.tag,
  ) : super(CategoryDevotionalsState(
          category: category,
          tag: tag,
        )) {
    _loadDevotionals();
  }

  void updateState({
    bool? isLoading,
    bool? isLoadingMore,
    bool? error,
    List<Devotional>? devotionals,
    int? page,
    int? totalPages,
    bool? hasMore,
  }) {
    state = state.copyWith(
      isLoading: isLoading,
      isLoadingMore: isLoadingMore,
      error: error,
      devotionals: devotionals,
      page: page,
      totalPages: totalPages,
      hasMore: hasMore,
    );
  }

  Future<void> _loadDevotionals() async {
    try {
      updateState(isLoading: true, error: false);
      final userLang = authProvider.user?.lang?.name ?? 'en';
      Result<DevotionalsResponse, Exception> result;

      if (category != null) {
        result = await devotionalUseCase.getDevotionalsByCategory(
          category!.id!,
          userLang,
          page: state.page,
          limit: state.limit,
        );
      } else if (tag != null) {
        result = await devotionalUseCase.getDevotionalsByTag(
          tag!.id!,
          userLang,
          page: state.page,
          limit: state.limit,
        );
      } else {
        updateState(isLoading: false, error: true);
        return;
      }

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
            devLogger('Error loading category_devotionals: $exception');
            updateState(isLoading: false, error: true);
          }
      }
    } catch (e) {
      devLogger('Error loading category_devotionals: $e');
      updateState(isLoading: false, error: true);
    }
  }

  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoadingMore || state.isLoading) return;

    try {
      updateState(isLoadingMore: true);
      final userLang = authProvider.user?.lang?.name ?? 'en';
      final nextPage = state.page + 1;
      Result<DevotionalsResponse, Exception> result;

      if (category != null) {
        result = await devotionalUseCase.getDevotionalsByCategory(
          category!.id!,
          userLang,
          page: nextPage,
          limit: state.limit,
        );
      } else if (tag != null) {
        result = await devotionalUseCase.getDevotionalsByTag(
          tag!.id!,
          userLang,
          page: nextPage,
          limit: state.limit,
        );
      } else {
        updateState(isLoadingMore: false);
        return;
      }

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
            devLogger('Error loading more category_devotionals: $exception');
            updateState(isLoadingMore: false);
          }
      }
    } catch (e) {
      devLogger('Error loading more category_devotionals: $e');
      updateState(isLoadingMore: false);
    }
  }
}

