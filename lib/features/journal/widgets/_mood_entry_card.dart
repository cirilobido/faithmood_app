import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/core_exports.dart';

class MoodEntryCard extends StatelessWidget {
  final MoodSession session;
  final VoidCallback? onTap;

  const MoodEntryCard({super.key, required this.session, this.onTap});

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('MMM d, yyyy', Lang.en.name).format(date);
  }

  String _getMoodEmoji() {
    if (session.emotional?.mood?.icon != null &&
        session.emotional!.mood!.icon!.isNotEmpty) {
      return session.emotional!.mood!.icon!;
    }
    return '💭';
  }

  String _getMoodName() {
    if (session.emotional?.mood != null) {
      final mood = session.emotional!.mood!;
      if (mood.translations != null && mood.translations!.isNotEmpty) {
        return mood.translations!.first.name ?? mood.name ?? '';
      }
      return mood.name ?? '';
    }
    return '';
  }

  String _getSpiritualEmoji() {
    if (session.spiritual?.mood?.icon != null &&
        session.spiritual!.mood!.icon!.isNotEmpty) {
      return session.spiritual!.mood!.icon!;
    }
    return '💭';
  }

  String _getSpiritualMoodName() {
    if (session.spiritual?.mood != null) {
      final mood = session.spiritual!.mood!;
      if (mood.translations != null && mood.translations!.isNotEmpty) {
        return mood.translations!.first.name ?? mood.name ?? '';
      }
      return mood.name ?? '';
    }
    return '';
  }

  String _getNoteSnippet() {
    if (session.note == null || session.note!.isEmpty) {
      return '';
    }
    final note = session.note!;
    if (note.length > 100) {
      return '${note.substring(0, 100)}...';
    }
    return note;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                _getMoodEmoji(),
                style: theme.textTheme.headlineMedium,
              ),
            ),
            const SizedBox(width: AppSizes.spacingSmall),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _getMoodName(),
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(
                        _formatDate(session.date),
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: theme.textTheme.labelSmall?.color,
                        ),
                      ),
                    ],
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
                  const SizedBox(height: AppSizes.spacingXSmall),
                  Container(
                    padding: const EdgeInsets.all(AppSizes.paddingXSmall),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.spacingXSmall,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "${_getSpiritualEmoji()} ${_getSpiritualMoodName()}",
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: theme.textTheme.labelSmall?.color,
                            ),
                          ),
                        ],
                      ),
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
