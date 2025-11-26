import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/core_exports.dart';
import '../../../generated/l10n.dart';
import '../../../routes/app_routes_names.dart';
import '../../../widgets/widgets_exports.dart';
import '../../journal/widgets/_journal_filter_chip.dart';
import '_categories_view_model.dart';
import '_categories_state.dart';

class CategoriesView extends ConsumerStatefulWidget {
  const CategoriesView({super.key});

  @override
  ConsumerState<CategoriesView> createState() => _CategoriesViewState();
}

class _CategoriesViewState extends ConsumerState<CategoriesView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final vm = ref.read(categoriesViewModelProvider.notifier);
    final state = ref.read(categoriesViewModelProvider);

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
    final vm = ref.read(categoriesViewModelProvider.notifier);
    final state = ref.watch(categoriesViewModelProvider);
    final theme = Theme.of(context);
    final lang = S.of(context);

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
                  _buildHeader(context, theme, vm, state, lang),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeOutCubic,
                    alignment: Alignment.topCenter,
                    child: state.isSearchVisible
                        ? Column(
                            key: const ValueKey('searchVisible'),
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: AppSizes.spacingSmall),
                              _buildSearchBar(context, theme, vm, state, lang),
                            ],
                          )
                        : const SizedBox.shrink(key: ValueKey('hidden')),
                  ),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeOutCubic,
                    alignment: Alignment.topCenter,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: AppSizes.spacingMedium),
                        _buildFilterChips(context, theme, vm, state, lang),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _buildDevotionalsSection(context, theme, state, vm, lang),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    ThemeData theme,
    CategoriesViewModel vm,
    CategoriesState state,
    S lang,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                lang.devotionals,
                style: theme.textTheme.headlineMedium,
              ),
              const SizedBox(height: AppSizes.spacingXSmall),
              Text(
                lang.findAPlanThatFitsYourJourney,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.textTheme.labelSmall?.color,
                ),
              ),
            ],
          ),
        ),
        InkWell(
          onTap: () => vm.toggleSearchVisibility(),
          splashColor: Colors.transparent,
          overlayColor: const WidgetStatePropertyAll(Colors.transparent),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return ScaleTransition(
                scale: animation,
                child: FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              );
            },
            child: SvgPicture.asset(
              state.isSearchVisible ? AppIcons.closeIcon : AppIcons.searchIcon,
              key: ValueKey(state.isSearchVisible),
              width: AppSizes.iconSizeLarge,
              colorFilter: ColorFilter.mode(
                theme.iconTheme.color!,
                BlendMode.srcIn,
              ),
            ),
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
    S lang,
  ) {
    // Input field height - matching TextFormField default height
    const inputHeight = 56.0; // Standard Material Design input height
    
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        // Wave animation - expanding from center (appears first)
        TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 500),
          tween: Tween<double>(begin: 0.0, end: 1.0),
          curve: Curves.easeOutCubic,
          builder: (context, waveValue, child) {
            final secondaryColor = theme.colorScheme.secondary;
            final screenWidth = MediaQuery.of(context).size.width;
            final maxWidth = screenWidth - (AppSizes.paddingMedium * 2);
            
            return IgnorePointer(
              child: Center(
                child: Container(
                  height: inputHeight,
                  width: maxWidth * waveValue,
                  decoration: BoxDecoration(
                    color: secondaryColor.withValues(
                      alpha: (1 - waveValue.clamp(0.0, 1.0)),
                    ),
                    borderRadius: BorderRadius.circular(AppSizes.radiusNormal),
                  ),
                ),
              ),
            );
          },
        ),
        // Search field (appears after wave starts)
        TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 400),
          tween: Tween<double>(begin: 0.0, end: 1.0),
          curve: Curves.easeOutCubic,
          builder: (context, fieldValue, child) {
            return Opacity(
              opacity: fieldValue,
              child: Transform.scale(
                scale: 0.9 + (0.1 * fieldValue),
                child: child!,
              ),
            );
          },
          child: Container(
            key: const ValueKey('searchBar'),
            child: InputField(
              hintText: lang.search,
              textInputAction: TextInputAction.search,
              initialValue: state.searchQuery,
              onChanged: (value) => vm.updateSearchQuery(value),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChips(
    BuildContext context,
    ThemeData theme,
    CategoriesViewModel vm,
    CategoriesState state,
    S lang,
  ) {
    final hasCategoryFilter = state.selectedCategory != null;
    final hasTagsFilter = state.selectedTags.isNotEmpty;
    final categoryValue = state.selectedCategory?.title;
    final tagsValue = state.selectedTags.length > 0
        ? '${lang.tags}: ${state.selectedTags.length}'
        : null;

    return SizedBox(
      height: AppSizes.filterTagChipHeight,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          JournalFilterChip(
            label: lang.category,
            value: categoryValue,
            isSelected: hasCategoryFilter,
            onTap: () {
              _showCategoryFilterModal(context, theme, vm, state, lang);
            },
          ),
          const SizedBox(width: AppSizes.spacingSmall),
          JournalFilterChip(
            label: lang.tags,
            value: tagsValue,
            isSelected: hasTagsFilter,
            onTap: () {
              _showTagsFilterModal(context, theme, vm, state, lang);
            },
          ),
          if (hasCategoryFilter || hasTagsFilter) ...[
            const SizedBox(width: AppSizes.spacingSmall),
            JournalFilterChip(
              label: lang.clearFilters,
              value: null,
              isClearFilter: true,
              onTap: () => vm.clearFilters(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDevotionalsSection(
    BuildContext context,
    ThemeData theme,
    CategoriesState state,
    CategoriesViewModel vm,
    S lang,
  ) {
    if (state.isLoading && state.devotionals.isEmpty) {
      return const Center(
        child: LoadingIndicator(
          padding: EdgeInsets.all(AppSizes.paddingMedium),
        ),
      );
    }

    if (state.error && state.devotionals.isEmpty) {
      return ErrorState(
        message: lang.unableToLoadDevotionals,
        imagePath: AppIcons.sadPetImage,
      );
    }

    final filteredDevotionals = vm.getFilteredDevotionals();

    if (filteredDevotionals.isEmpty && !state.isLoading) {
      return EmptyState(
        message: state.searchQuery.trim().isEmpty
            ? lang.noDevotionalsAvailable
            : '${lang.noDevotionalsAvailable} "${state.searchQuery}"',
      );
    }

    return RefreshIndicator(
      onRefresh: () => vm.refresh(),
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.paddingMedium,
            ),
            sliver: SliverList.separated(
              itemCount: filteredDevotionals.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: AppSizes.spacingMedium),
              itemBuilder: (context, index) {
                final devotional = filteredDevotionals[index];
                return DevotionalItemCard(
                  devotional: devotional,
                  onTap: () {
                    if (devotional.id != null) {
                      context.pushWithAd(
                        ref,
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
          SliverToBoxAdapter(
            child: SizedBox(height: AppSizes.spacingLarge),
          ),
        ],
      ),
    );
  }

  void _showCategoryFilterModal(
    BuildContext context,
    ThemeData theme,
    CategoriesViewModel vm,
    CategoriesState state,
    S lang,
  ) {
    showDialog(
      context: context,
      builder: (context) => _CategoryFilterModal(
        categories: state.categories,
        selectedCategory: state.selectedCategory,
        onCategorySelected: (category) {
          vm.selectCategory(category);
        },
        onClear: () {
          vm.clearFilters();
        },
      ),
    );
  }

  void _showTagsFilterModal(
    BuildContext context,
    ThemeData theme,
    CategoriesViewModel vm,
    CategoriesState state,
    S lang,
  ) {
    showDialog(
      context: context,
      builder: (context) => _TagsFilterModal(
        tags: state.tags,
        selectedTags: state.selectedTags,
        onTagsSelected: (tags) {
          vm.setSelectedTags(tags);
        },
        onClear: () {
          vm.clearFilters();
        },
      ),
    );
  }
}

class _CategoryFilterModal extends StatefulWidget {
  final List<DevotionalCategory> categories;
  final DevotionalCategory? selectedCategory;
  final Function(DevotionalCategory?) onCategorySelected;
  final VoidCallback onClear;

  const _CategoryFilterModal({
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
    required this.onClear,
  });

  @override
  State<_CategoryFilterModal> createState() => _CategoryFilterModalState();
}

class _CategoryFilterModalState extends State<_CategoryFilterModal> {
  late DevotionalCategory? _tempSelectedCategory;

  @override
  void initState() {
    super.initState();
    _tempSelectedCategory = widget.selectedCategory;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lang = S.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusNormal),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingSmall),
      child: Container(
        padding: const EdgeInsets.all(AppSizes.paddingLarge),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.9,
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    lang.category,
                    style: theme.textTheme.titleLarge,
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  splashColor: Colors.transparent,
                  overlayColor: const WidgetStatePropertyAll(Colors.transparent),
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
            const SizedBox(height: AppSizes.spacingLarge),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.categories.isEmpty)
                      Text(
                        lang.noDevotionalsAvailable,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.textTheme.labelSmall?.color,
                        ),
                      )
                    else
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: _buildCategoryChip(
                              context: context,
                              theme: theme,
                              label: lang.all,
                              isSelected: _tempSelectedCategory == null,
                              onTap: () {
                                setState(() {
                                  _tempSelectedCategory = null;
                                });
                              },
                            ),
                          ),
                          ...widget.categories.map((category) {
                            final isSelected = _tempSelectedCategory?.id == category.id;
                            return Padding(
                              padding: const EdgeInsets.only(top: AppSizes.spacingSmall),
                              child: Center(
                                child: _buildCategoryChip(
                                  context: context,
                                  theme: theme,
                                  label: category.title ?? '',
                                  icon: category.iconEmoji,
                                  isSelected: isSelected,
                                  onTap: () {
                                    setState(() {
                                      _tempSelectedCategory = isSelected ? null : category;
                                    });
                                  },
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSizes.spacingLarge),
            CustomButton(
              title: lang.applyFilters,
              type: ButtonType.neutral,
              isShortText: true,
              onTap: () {
                widget.onCategorySelected(_tempSelectedCategory);
                Navigator.of(context).pop();
              },
            ),
            const SizedBox(height: AppSizes.spacingSmall),
            CustomButton(
              title: lang.clearFilters,
              type: ButtonType.neutral,
              style: CustomStyle.outlined,
              isShortText: true,
              onTap: () {
                widget.onClear();
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip({
    required BuildContext context,
    required ThemeData theme,
    required String label,
    String? icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingMedium,
          vertical: AppSizes.paddingSmall,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withValues(alpha: 0.1)
              : theme.colorScheme.onSurface,
          borderRadius: BorderRadius.circular(AppSizes.radiusFull),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outline,
            width: AppSizes.borderWithSmall,
          ),
        ),
        child: Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: AppSizes.spacingXSmall,
          children: [
            Text(
              '${icon ?? ''}$label',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isSelected
                    ? theme.colorScheme.onPrimary
                    : theme.textTheme.bodyMedium?.color,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TagsFilterModal extends StatefulWidget {
  final List<Tag> tags;
  final List<Tag> selectedTags;
  final Function(List<Tag>) onTagsSelected;
  final VoidCallback onClear;

  const _TagsFilterModal({
    required this.tags,
    required this.selectedTags,
    required this.onTagsSelected,
    required this.onClear,
  });

  @override
  State<_TagsFilterModal> createState() => _TagsFilterModalState();
}

class _TagsFilterModalState extends State<_TagsFilterModal> {
  late List<Tag> _tempSelectedTags;

  @override
  void initState() {
    super.initState();
    _tempSelectedTags = List<Tag>.from(widget.selectedTags);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lang = S.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusNormal),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingSmall),
      child: Container(
        padding: const EdgeInsets.all(AppSizes.paddingLarge),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.9,
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    lang.tags,
                    style: theme.textTheme.titleLarge,
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  splashColor: Colors.transparent,
                  overlayColor: const WidgetStatePropertyAll(Colors.transparent),
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
            const SizedBox(height: AppSizes.spacingLarge),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (widget.tags.isEmpty)
                      Text(
                        lang.noTagsAvailable,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.textTheme.labelSmall?.color,
                        ),
                      )
                      else
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: AppSizes.spacingSmall,
                        runSpacing: AppSizes.spacingSmall,
                        children: widget.tags.map((tag) {
                          final isSelected = _tempSelectedTags.any((t) => t.id == tag.id);
                          return _buildTagChip(
                            context: context,
                            theme: theme,
                            label: tag.name ?? '',
                            icon: tag.icon,
                            isSelected: isSelected,
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  _tempSelectedTags.removeWhere((t) => t.id == tag.id);
                                } else {
                                  _tempSelectedTags.add(tag);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSizes.spacingLarge),
            CustomButton(
              title: lang.applyFilters,
              type: ButtonType.neutral,
              isShortText: true,
              onTap: () {
                widget.onTagsSelected(_tempSelectedTags);
                Navigator.of(context).pop();
              },
            ),
            const SizedBox(height: AppSizes.spacingSmall),
            CustomButton(
              title: lang.clearFilters,
              type: ButtonType.neutral,
              style: CustomStyle.outlined,
              isShortText: true,
              onTap: () {
                setState(() {
                  _tempSelectedTags.clear();
                });
                widget.onClear();
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTagChip({
    required BuildContext context,
    required ThemeData theme,
    required String label,
    String? icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingMedium,
          vertical: AppSizes.paddingSmall,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withValues(alpha: 0.1)
              : theme.colorScheme.onSurface,
          borderRadius: BorderRadius.circular(AppSizes.radiusFull),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outline,
            width: AppSizes.borderWithSmall,
          ),
        ),
        child: Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: AppSizes.spacingXSmall,
          children: [
            if (icon != null && icon.isNotEmpty)
              Text(icon, style: theme.textTheme.bodyMedium),
            Text(
              label,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isSelected
                    ? theme.colorScheme.onPrimary
                    : theme.textTheme.bodyMedium?.color,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
