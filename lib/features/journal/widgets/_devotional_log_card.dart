import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/core_exports.dart';

class DevotionalLogCard extends StatelessWidget {
  final DevotionalLog log;
  final VoidCallback? onTap;

  const DevotionalLogCard({super.key, required this.log, this.onTap});

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('MMM d, yyyy', 'en').format(date);
  }

  String _formatDateString(String? date) {
    if (date == null || date.isEmpty) return '';
    try {
      final parsedDate = DateTime.parse(date);
      return DateFormat('MMM d, yyyy', 'en').format(parsedDate);
    } catch (e) {
      return date;
    }
  }

  String _getNoteSnippet() {
    if (log.note == null || log.note!.isEmpty) {
      return '';
    }
    final note = log.note!;
    if (note.length > 100) {
      return '${note.substring(0, 100)}...';
    }
    return note;
  }

  String _getTagName(Tag? tag) {
    if (tag?.translations != null && tag!.translations!.isNotEmpty) {
      return tag.translations!.first.name ?? '';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final devotional = log.devotional;
    final tags = devotional?.tags ?? [];
    final hasTags = tags.isNotEmpty;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.radiusNormal),
      child: Container(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        decoration: BoxDecoration(
          color: theme.colorScheme.onSurface,
          borderRadius: BorderRadius.circular(AppSizes.radiusNormal),
          border: Border.all(
            color: theme.colorScheme.outline,
            width: AppSizes.borderWithSmall,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: AppSizes.iconSizeXXLarge,
              height: AppSizes.iconSizeXXLarge,
              decoration: BoxDecoration(
                color: theme.colorScheme.secondary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppSizes.radiusFull),
              ),
              alignment: Alignment.center,
              child: Text(
                devotional?.iconEmoji ?? '📖',
                style: theme.textTheme.headlineMedium,
              ),
            ),
            const SizedBox(width: AppSizes.spacingSmall),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    devotional?.title ?? '',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    _formatDate(log.createdAt) != ''
                        ? _formatDate(log.createdAt)
                        : _formatDateString(devotional?.date),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: theme.textTheme.titleSmall?.fontWeight,
                      color: theme.textTheme.labelSmall?.color,
                    ),
                  ),
                  if (_getNoteSnippet().isNotEmpty) ...[
                    const SizedBox(height: AppSizes.spacingXSmall),
                    Text(
                      _getNoteSnippet(),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.textTheme.labelSmall?.color,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  if (hasTags) ...[
                    const SizedBox(height: AppSizes.spacingXSmall),
                    Wrap(
                      spacing: AppSizes.spacingXSmall,
                      runSpacing: AppSizes.spacingXSmall,
                      children: tags.take(3).map((tagRelationship) {
                        final tag = tagRelationship.tag;
                        if (tag == null) return const SizedBox.shrink();
                        final tagName = _getTagName(tag);
                        if (tagName.isEmpty) return const SizedBox.shrink();
                        return Container(
                          padding: const EdgeInsets.all(AppSizes.paddingXSmall),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.secondary.withValues(
                              alpha: 0.2,
                            ),
                            borderRadius: BorderRadius.circular(
                              AppSizes.radiusFull,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.spacingXSmall,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (tag.icon != null && tag.icon!.isNotEmpty) ...[
                                  Text(
                                    tag.icon!,
                                    style: theme.textTheme.labelMedium?.copyWith(
                                      color: theme.textTheme.labelSmall?.color,
                                    ),
                                  ),
                                  const SizedBox(width: AppSizes.spacingXXSmall),
                                ],
                                Text(
                                  tagName,
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    color: theme.textTheme.labelSmall?.color,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
