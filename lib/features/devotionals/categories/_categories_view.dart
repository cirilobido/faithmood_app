import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/core_exports.dart';
import '../../../generated/l10n.dart';
import '../../../routes/app_routes_names.dart';
import '../../../widgets/widgets_exports.dart';
import '_categories_view_model.dart';
import '_categories_state.dart';

class CategoriesView extends ConsumerWidget {
  const CategoriesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.read(categoriesViewModelProvider.notifier);
    final state = ref.watch(categoriesViewModelProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.paddingMedium,
                vertical: AppSizes.paddingMedium,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section
                  SectionHeader(
                    title: S.of(context).devotionals,
                    subtitle: S.of(context).findAPlanThatFitsYourJourney,
                    titleStyle: theme.textTheme.headlineMedium,
                  ),
                  const SizedBox(height: AppSizes.spacingSmall),

                  // Search Bar
                  _buildSearchBar(context, theme, vm, state),
                  const SizedBox(height: AppSizes.spacingMedium),

                  // Tags Filter Section
                  TagsFilterSection(
                    tags: state.tags,
                    isLoading: state.isLoadingTags,
                    onTagTap: (tag) {
                      context.push(
                        Routes.categoryDevotionals,
                        extra: {'tag': tag},
                      );
                    },
                    onViewMore: () {
                      TagsModal.show(
                        context: context,
                        tags: state.tags,
                        onTagSelected: (tag) {
                          context.push(
                            Routes.categoryDevotionals,
                            extra: {'tag': tag},
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),

            // Scrollable Categories Section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.paddingMedium,
                ),
                child: _buildCategoriesSection(context, theme, state, vm),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildSearchBar(
    BuildContext context,
    ThemeData theme,
    CategoriesViewModel vm,
    CategoriesState state,
  ) {
    final lang = S.of(context);
    return InputField(
      hintText: lang.search,
      textInputAction: TextInputAction.next,
      initialValue: state.searchQuery,
      onChanged: (value) => vm.updateSearchQuery(value),
    );
  }


  Widget _buildCategoriesSection(
    BuildContext context,
    ThemeData theme,
    CategoriesState state,
    CategoriesViewModel vm,
  ) {
    final lang = S.of(context);
    if (state.isLoading) {
      return const Center(
        child: LoadingIndicator(
          padding: EdgeInsets.all(AppSizes.paddingMedium),
        ),
      );
    }

    if (state.error) {
      return ErrorState(
        message: lang.unableToLoadCategories,
        imagePath: AppIcons.sadPetImage,
      );
    }

    // Get filtered categories based on search query
    final filteredCategories = vm.getFilteredCategories();

    if (filteredCategories.isEmpty) {
      return EmptyState(
        message: state.searchQuery.trim().isEmpty
            ? lang.noCategoriesAvailable
            : '${lang.noCategoriesAvailable} "${state.searchQuery}"',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.only(bottom: AppSizes.paddingMedium),
      itemCount: filteredCategories.length,
      separatorBuilder: (context, index) =>
          const SizedBox(height: AppSizes.spacingMedium),
      itemBuilder: (context, index) {
        final category = filteredCategories[index];
        return CategoryCard(
          title: category.title,
          description: category.description,
          coverImage: category.coverImage,
          iconEmoji: category.iconEmoji,
          isPremium: category.isPremium ?? false,
          onTap: () {
            context.push(
              Routes.categoryDevotionals,
              extra: {'category': category},
            );
          },
        );
      },
    );
  }

}
