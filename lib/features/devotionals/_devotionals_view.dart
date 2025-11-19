import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../core/core_exports.dart';
import '../../generated/l10n.dart';
import '../../widgets/widgets_exports.dart';
import '_devotionals_view_model.dart';
import '_devotionals_state.dart';

class DevotionalsView extends ConsumerWidget {
  const DevotionalsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.read(devotionalsViewModelProvider.notifier);
    final state = ref.watch(devotionalsViewModelProvider);
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
    DevotionalsViewModel vm,
    DevotionalsState state,
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
    DevotionalsViewModel vm,
    DevotionalsState state,
  ) {
    if (state.isLoadingTags) {
      return Center(
        child: SizedBox(
          width: AppSizes.iconSizeMedium,
          height: AppSizes.iconSizeMedium,
          child: CircularProgressIndicator(strokeWidth: 2),
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
              margin: const EdgeInsets.only(left: AppSizes.spacingSmall),
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
          return _buildTagChip(context, theme, tag);
        },
      ),
    );
  }

  Widget _buildTagChip(
    BuildContext context,
    ThemeData theme,
    DevotionalTag tag, {
    bool closeModalOnTap = false,
  }) {
    // Parse color if available
    Color? tagColor;
    if (tag.color != null && tag.color!.isNotEmpty) {
      try {
        tagColor = Color(int.parse(tag.color!.replaceFirst('#', '0xFF')));
      } catch (_) {
        tagColor = null;
      }
    }

    return Container(
      margin: const EdgeInsets.only(right: AppSizes.spacingSmall),
      child: GestureDetector(
        onTap: () {
          // TODO: Navigate to devotionals filtered by this tag
          // Example: context.push(Routes.devotionalsByTag, extra: tag.key);
          if (closeModalOnTap && context.mounted) {
            Navigator.of(context).pop();
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.paddingSmall,
            vertical: AppSizes.paddingXXSmall,
          ),
          decoration: BoxDecoration(
            color:
                tagColor?.withValues(alpha: 0.1) ??
                theme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppSizes.radiusFull),
            border: Border.all(
              color:
                  tagColor?.withValues(alpha: 0.3) ??
                  theme.colorScheme.primary.withValues(alpha: 0.3),
              width: AppSizes.borderWithSmall,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (tag.icon != null) ...[
                Text(tag.icon!, style: theme.textTheme.bodyMedium),
                const SizedBox(width: AppSizes.spacingXSmall),
              ],
              Text(
                tag.name ?? '',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: tagColor ?? theme.colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTagsModal(
    BuildContext context,
    ThemeData theme,
    DevotionalsViewModel vm,
    DevotionalsState state,
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
                    IconButton(
                      icon: SvgPicture.asset(
                        AppIcons.closeIcon,
                        width: AppSizes.iconSizeMedium,
                        colorFilter: ColorFilter.mode(
                          theme.iconTheme.color!,
                          BlendMode.srcIn,
                        ),
                      ),
                      onPressed: () => Navigator.of(modalContext).pop(),
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
                        return _buildTagChip(
                          modalContext,
                          theme,
                          tag,
                          closeModalOnTap: true,
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
    DevotionalsState state,
    DevotionalsViewModel vm,
  ) {
    final lang = S.of(context);
    if (state.isLoading) {
      return Center(
        child: SizedBox(
          width: AppSizes.iconSizeMedium,
          height: AppSizes.iconSizeMedium,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    if (state.error) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingLarge),
          child: Column(
            children: [
              Icon(Icons.error_outline, color: theme.colorScheme.error),
              const SizedBox(height: AppSizes.spacingSmall),
              Text(
                lang.unableToLoadCategories,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.textTheme.labelSmall?.color,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Get filtered categories based on search query
    final filteredCategories = vm.getFilteredCategories();

    if (filteredCategories.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingLarge),
          child: Text(
            state.searchQuery.trim().isEmpty
                ? lang.noCategoriesAvailable
                : '${lang.noCategoriesAvailable} "${state.searchQuery}"',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.labelSmall?.color,
            ),
          ),
        ),
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

    return ClipRRect(
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
                        onTap: () {},
                      ),
                    ],
                  ),
                ),

                // Emoji (opcional)
                if (category.iconEmoji != null &&
                    category.iconEmoji!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(left: AppSizes.spacingSmall),
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
    );
  }
}
