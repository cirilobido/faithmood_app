import 'package:flutter/material.dart';

import '../../core/core_exports.dart';
import '../../generated/l10n.dart';
import '../widgets_exports.dart';

class TagsFilterSection extends StatelessWidget {
  final List<Tag> tags;
  final bool isLoading;
  final int maxVisibleTags;
  final ValueChanged<Tag>? onTagTap;
  final VoidCallback? onViewMore;

  const TagsFilterSection({
    super.key,
    required this.tags,
    this.isLoading = false,
    this.maxVisibleTags = 6,
    this.onTagTap,
    this.onViewMore,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lang = S.of(context);

    if (isLoading) {
      return const Center(
        child: LoadingIndicator(
          padding: EdgeInsets.all(AppSizes.paddingMedium),
        ),
      );
    }

    final visibleTags = tags.take(maxVisibleTags).toList();
    final hasMoreTags = tags.length > maxVisibleTags;

    return SizedBox(
      height: AppSizes.tagChipHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: visibleTags.length + (hasMoreTags ? 1 : 0),
        itemBuilder: (context, index) {
          if (hasMoreTags && index == visibleTags.length) {
            return Container(
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: onViewMore,
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
                    lang.viewMore,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            );
          }

          final tag = visibleTags[index];
          return Container(
            margin: const EdgeInsets.only(right: AppSizes.spacingSmall),
            child: DevotionalTagChip(
              tag: tag,
              onTap: onTagTap != null ? () => onTagTap!(tag) : null,
            ),
          );
        },
      ),
    );
  }
}

