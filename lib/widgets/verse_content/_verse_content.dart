import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/core_exports.dart';
import '../../core/models/verse/_verse_translation.dart';

class VerseContent extends ConsumerWidget {
  final Verse? verse;
  final List<Verse>? verses;
  final List<DevotionalLogVerseRelationship>? verseRelationships;
  final bool useStyledContainer;
  final String? userLang;

  const VerseContent({
    super.key,
    this.verse,
    this.verses,
    this.verseRelationships,
    this.useStyledContainer = false,
    this.userLang,
  }) : assert(
          (verse != null && verses == null && verseRelationships == null) ||
          (verse == null && verses != null && verseRelationships == null) ||
          (verse == null && verses == null && verseRelationships != null),
          'Exactly one of verse, verses, or verseRelationships must be provided',
        );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final lang = userLang ?? ref.read(authProvider).user?.lang?.name ?? 'en';

    if (verse != null) {
      return _buildSingleVerse(context, theme, verse!, lang);
    } else if (verses != null) {
      return _buildVerseList(context, theme, verses!, lang);
    } else if (verseRelationships != null) {
      return _buildVerseRelationshipList(context, theme, verseRelationships!, lang);
    }

    return const SizedBox.shrink();
  }

  Widget _buildSingleVerse(
    BuildContext context,
    ThemeData theme,
    Verse verse,
    String lang,
  ) {
    VerseTranslation? translation;
    if (verse.translations != null && verse.translations!.isNotEmpty) {
      translation = verse.translations!.firstWhere(
        (t) => t.lang == lang,
        orElse: () => verse.translations!.first,
      );
    }

    final verseText = translation?.text ?? verse.text ?? '';
    final verseRef = translation?.ref ?? verse.ref ?? '';

    if (verseText.isEmpty) {
      return const SizedBox.shrink();
    }

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(verseText, style: theme.textTheme.bodyLarge),
        if (verseRef.isNotEmpty) ...[
          const SizedBox(height: AppSizes.spacingXSmall),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              verseRef,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.labelSmall?.color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ],
    );

    if (useStyledContainer) {
      return Container(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
        ),
        child: content,
      );
    }

    return content;
  }

  Widget _buildVerseList(
    BuildContext context,
    ThemeData theme,
    List<Verse> verses,
    String lang,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: verses.map((verse) {
        final verseText = verse.text ?? '';
        final verseRef = verse.ref ?? '';

        if (verseText.isEmpty) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: AppSizes.spacingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(verseText, style: theme.textTheme.bodyLarge),
              if (verseRef.isNotEmpty) ...[
                const SizedBox(height: AppSizes.spacingXSmall),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    verseRef,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.textTheme.labelSmall?.color,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildVerseRelationshipList(
    BuildContext context,
    ThemeData theme,
    List<DevotionalLogVerseRelationship> verseRelationships,
    String lang,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: verseRelationships.map((verseRelationship) {
        final verse = verseRelationship.verse;
        if (verse == null ||
            verse.translations == null ||
            verse.translations!.isEmpty) {
          return const SizedBox.shrink();
        }

        final translation = verse.translations!.firstWhere(
          (t) => t.lang == lang,
          orElse: () => verse.translations!.first,
        );

        final verseText = translation.text ?? '';
        final verseRef = translation.ref ?? '';

        if (verseText.isEmpty) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: AppSizes.spacingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(verseText, style: theme.textTheme.bodyLarge),
              if (verseRef.isNotEmpty) ...[
                const SizedBox(height: AppSizes.spacingXSmall),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    verseRef,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.textTheme.labelSmall?.color,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }
}

