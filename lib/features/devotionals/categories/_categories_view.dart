import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
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
                  _buildHeader(context, theme),
                  const SizedBox(height: AppSizes.spacingSmall),

                  // Search Bar
                  _buildSearchBar(context, theme, vm, state),
                  const SizedBox(height: AppSizes.spacingMedium),

                  // Tags Filter Section
                  _buildTagsFilter(context, theme, vm, state),
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

  Widget _buildHeader(BuildContext context, ThemeData theme) {
    final lang = S.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(lang.devotionals, style: theme.textTheme.headlineMedium),
        const SizedBox(height: AppSizes.spacingXSmall),
        Text(
          lang.findAPlanThatFitsYourJourney,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.textTheme.labelSmall?.color,
          ),
        ),
      ],
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

  Widget _buildTagsFilter(
    BuildContext context,
    ThemeData theme,
    CategoriesViewModel vm,
    CategoriesState state,
  ) {
    if (state.isLoadingTags) {
      return const Center(
        child: LoadingIndicator(
          padding: EdgeInsets.all(AppSizes.paddingMedium),
        ),
      );
    }

    // Show max 6 tags
    const maxVisibleTags = 6;
    final visibleTags = state.tags.take(maxVisibleTags).toList();
    final hasMoreTags = state.tags.length > maxVisibleTags;

    return SizedBox(
      height: AppSizes.tagChipHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: visibleTags.length + (hasMoreTags ? 1 : 0),
        itemBuilder: (context, index) {
          // If this is the last item and we have more tags, show "View More" button
          if (hasMoreTags && index == visibleTags.length) {
            return Container(
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () =>
                    _showTagsModal(context, theme, vm, state, state.tags),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingMedium,
                    vertical: AppSizes.paddingXSmall,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                    border: Border.all(
                      color: theme.colorScheme.primary.withValues(alpha: 0.3),
                      width: AppSizes.borderWithSmall,
                    ),
                  ),
                  child: Text(
                    S.of(context).viewMore,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            );
          }
          // Otherwise, show the tag chip
          final tag = visibleTags[index];
          return Container(
            margin: const EdgeInsets.only(right: AppSizes.spacingSmall),
            child: DevotionalTagChip(tag: tag),
          );
        },
      ),
    );
  }

  void _showTagsModal(
    BuildContext context,
    ThemeData theme,
    CategoriesViewModel vm,
    CategoriesState state,
    List<DevotionalTag> allTags,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext modalContext) {
        return Dialog(
          backgroundColor: theme.colorScheme.onSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusNormal),
          ),
          child: Container(
            padding: const EdgeInsets.all(AppSizes.paddingMedium),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.9,
              maxHeight: MediaQuery.of(context).size.height * 0.7,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        S.of(context).selectTag,
                        style: theme.textTheme.titleSmall,
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.of(modalContext).pop(),
                      child: SvgPicture.asset(
                        AppIcons.closeIcon,
                        width: AppSizes.iconSizeMedium,
                        colorFilter: ColorFilter.mode(
                          theme.iconTheme.color!,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.spacingMedium),

                // Tags Grid
                Flexible(
                  child: SingleChildScrollView(
                    child: Wrap(
                      spacing: AppSizes.spacingSmall,
                      runSpacing: AppSizes.spacingSmall,
                      alignment: WrapAlignment.center,
                      runAlignment: WrapAlignment.center,
                      children: allTags.map((tag) {
                        return DevotionalTagChip(
                          tag: tag,
                          onTap: () {
                            Navigator.of(modalContext).pop();
                            if (context.mounted) {
                              context.push(
                                Routes.categoryDevotionals,
                                extra: {'tag': tag},
                              );
                            }
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.spacingMedium),
              ],
            ),
          ),
        );
      },
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
        return _buildCategoryCard(context, theme, filteredCategories[index]);
      },
    );
  }

  Widget _buildCategoryCard(
    BuildContext context,
    ThemeData theme,
    DevotionalCategory category,
  ) {
    final lang = S.of(context);
    final isPremium = category.isPremium ?? false;
    final coverImage = category.coverImage;
    final subtitle = category.description ?? '';
    final ctaText = isPremium ? lang.unlockNow : lang.explore;

    return InkWell(
      onTap: isPremium
          ? null
          : () {
              context.push(
                Routes.categoryDevotionals,
                extra: {'category': category},
              );
            },
      borderRadius: BorderRadius.circular(AppSizes.radiusNormal),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.radiusNormal),
        child: Stack(
          children: [
            // Fondo dinámico
            if (coverImage != null && coverImage.isNotEmpty)
              Positioned.fill(
                child: CachedNetworkImage(
                  imageUrl: coverImage,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: theme.colorScheme.secondary.withValues(alpha: 0.4),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: theme.colorScheme.secondary.withValues(alpha: 0.4),
                  ),
                ),
              ),

            // Blur
            Positioned.fill(
              child: Container(
                margin: const EdgeInsets.all(AppSizes.paddingMedium),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                ),
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                  child: Container(),
                ),
              ),
            ),

            // Contenido
            Container(
              padding: const EdgeInsets.all(AppSizes.paddingLarge),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Textos + botón
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Título
                        Text(
                          category.title ?? '',
                          style: theme.textTheme.titleLarge,
                        ),
                        const SizedBox(height: AppSizes.spacingXSmall),

                        /// Descripción
                        Text(
                          subtitle,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.textTheme.labelSmall?.color,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(height: AppSizes.spacingMedium),

                        /// Botón
                        CustomButton(
                          title: ctaText,
                          type: ButtonType.neutral,
                          isShortText: true,
                          icon: isPremium ? AppIcons.lockIcon : null,
                          onTap: () {
                            if (!isPremium) {
                              context.push(
                                Routes.categoryDevotionals,
                                extra: {'category': category},
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),

                  // Emoji (opcional)
                  if (category.iconEmoji != null &&
                      category.iconEmoji!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(
                        left: AppSizes.spacingSmall,
                      ),
                      child: Text(
                        category.iconEmoji!,
                        style: theme.textTheme.displaySmall,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
