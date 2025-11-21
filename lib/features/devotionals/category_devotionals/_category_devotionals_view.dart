import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/core_exports.dart';
import '../../../generated/l10n.dart';
import '../../../routes/app_routes_names.dart';
import '../../../widgets/widgets_exports.dart';
import '_category_devotionals_view_model.dart';
import '_category_devotionals_state.dart';

class CategoryDevotionalsView extends ConsumerStatefulWidget {
  final DevotionalCategory? category;
  final Tag? tag;

  const CategoryDevotionalsView({super.key, this.category, this.tag});

  @override
  ConsumerState<CategoryDevotionalsView> createState() =>
      _CategoryDevotionalsViewState();
}

class _CategoryDevotionalsViewState
    extends ConsumerState<CategoryDevotionalsView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final params = (category: widget.category, tag: widget.tag);
    final vm = ref.read(categoryDevotionalsViewModelProvider(params).notifier);
    final state = ref.read(categoryDevotionalsViewModelProvider(params));

    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !state.isLoadingMore &&
        !state.isLoading &&
        state.hasMore) {
      vm.loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final params = (category: widget.category, tag: widget.tag);
    final vm = ref.read(categoryDevotionalsViewModelProvider(params).notifier);
    final state = ref.watch(categoryDevotionalsViewModelProvider(params));
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
              child: PageHeader(
                title: widget.category?.title ?? widget.tag?.name ?? '',
              ),
            ),
            Expanded(child: _buildScrollableContent(context, theme, state, vm)),
          ],
        ),
      ),
    );
  }

  Widget _buildScrollableContent(
    BuildContext context,
    ThemeData theme,
    CategoryDevotionalsState state,
    CategoryDevotionalsViewModel vm,
  ) {
    final lang = S.of(context);
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.paddingMedium,
            ),
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CategoryTagImage(
                  imageUrl: widget.category?.coverImage,
                  emoji: widget.tag?.icon,
                  colorHex: widget.tag?.color,
                ),
                if ((widget.category != null &&
                        widget.category!.coverImage != null &&
                        widget.category!.coverImage!.isNotEmpty) ||
                    (widget.tag != null &&
                        widget.tag!.icon != null &&
                        widget.tag!.icon!.isNotEmpty))
                  const SizedBox(height: AppSizes.spacingMedium),
                _buildTitleAndDescription(context, theme, state),
                if (state.isLoading && state.devotionals.isEmpty) ...[
                  const SizedBox(height: AppSizes.spacingMedium),
                  const Center(
                    child: LoadingIndicator(
                      padding: EdgeInsets.all(AppSizes.paddingMedium),
                    ),
                  ),
                ],
                if (state.error && state.devotionals.isEmpty) ...[
                  const SizedBox(height: AppSizes.spacingMedium),
                  ErrorState(
                    message: lang.unableToLoadDevotionals,
                    imagePath: AppIcons.sadPetImage,
                  ),
                ],
                if (state.devotionals.isEmpty &&
                    !state.isLoading &&
                    !state.error) ...[
                  const SizedBox(height: AppSizes.spacingMedium),
                  EmptyState(message: lang.noDevotionalsAvailable),
                ],
                if (state.devotionals.isNotEmpty)
                  const SizedBox(height: AppSizes.spacingMedium),
              ],
            ),
          ),
        ),
        if (state.devotionals.isNotEmpty)
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.paddingMedium,
            ),
            sliver: SliverList.separated(
              itemCount: state.devotionals.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: AppSizes.spacingMedium),
              itemBuilder: (context, index) {
                final devotional = state.devotionals[index];
                return DevotionalItemCard(
                  devotional: devotional,
                  fallbackIcon: widget.tag?.icon ?? widget.category?.iconEmoji,
                  onTap: () {
                    if (devotional.id != null) {
                      context.push(
                        Routes.devotionalDetails,
                        extra: {'devotionalId': devotional.id},
                      );
                    }
                  },
                );
              },
            ),
          ),
        if (state.isLoadingMore)
          const SliverToBoxAdapter(
            child: LoadingIndicator(
              padding: EdgeInsets.all(AppSizes.paddingMedium),
            ),
          ),
      ],
    );
  }


  Widget _buildTitleAndDescription(
    BuildContext context,
    ThemeData theme,
    CategoryDevotionalsState state,
  ) {
    final description = widget.category?.description ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (description.isNotEmpty) ...[
          const SizedBox(height: AppSizes.spacingXSmall),
          Text(
            description,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.textTheme.labelSmall?.color,
            ),
          ),
        ],
      ],
    );
  }

}
