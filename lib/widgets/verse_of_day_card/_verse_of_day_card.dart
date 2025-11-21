import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/core_exports.dart';
import '../../generated/l10n.dart';

class VerseOfDayCard extends ConsumerWidget {
  final bool isLoading;
  final Verse? verse;
  final String? userLang;

  const VerseOfDayCard({
    super.key,
    required this.isLoading,
    this.verse,
    this.userLang,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final lang = S.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.paddingMedium),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(AppSizes.radiusNormal),
      ),
      child: isLoading
          ? _buildLoadingState()
          : verse != null && _hasVerseContent(verse!)
          ? _buildVerseContent(context, ref, theme, lang)
          : _buildErrorState(context, theme, lang),
    );
  }

  bool _hasVerseContent(Verse verse) {
    if (verse.text != null && verse.text!.isNotEmpty) return true;
    if (verse.translations != null && verse.translations!.isNotEmpty) {
      return verse.translations!.any((t) => t.text != null && t.text!.isNotEmpty);
    }
    return false;
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.paddingLarge),
        child: Padding(
          padding: EdgeInsets.all(AppSizes.paddingMedium),
          child: SizedBox(
            width: AppSizes.iconSizeMedium,
            height: AppSizes.iconSizeMedium,
            child: CircularProgressIndicator(strokeWidth: 3),
          ),
        ),
      ),
    );
  }

  Widget _buildVerseContent(BuildContext context, WidgetRef ref, ThemeData theme, S lang) {
    final verseText = verse!.text ?? '';
    final verseRef = verse!.ref ?? '';
    
    String? translationText;
    String? translationRef;
    
    if (verse!.translations != null && verse!.translations!.isNotEmpty) {
      final userLangCode = userLang ?? ref.read(authProvider).user?.lang?.name ?? 'en';
      final translation = verse!.translations!.firstWhere(
        (t) => t.lang == userLangCode,
        orElse: () => verse!.translations!.first,
      );
      translationText = translation.text;
      translationRef = translation.ref;
    }

    final displayText = translationText ?? verseText;
    final displayRef = translationRef ?? verseRef;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          lang.verseOfTheDay,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.textTheme.labelSmall?.color,
          ),
        ),
        const SizedBox(height: AppSizes.spacingSmall),
        if (displayText.isNotEmpty)
          Text(
            '"$displayText"',
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.italic,
            ),
          ),
        if (displayRef.isNotEmpty) ...[
          const SizedBox(height: AppSizes.spacingSmall),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              displayRef,
              textAlign: TextAlign.end,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.labelSmall?.color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildErrorState(BuildContext context, ThemeData theme, S lang) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          lang.verseOfTheDay,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.textTheme.labelSmall?.color,
          ),
        ),
        const SizedBox(height: AppSizes.spacingSmall),
        Text(
          lang.unableToLoadVersePleaseTryAgainLater,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.textTheme.labelSmall?.color,
          ),
        ),
      ],
    );
  }
}

