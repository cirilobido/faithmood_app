import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:ui';

import '../../../../core/core_exports.dart';
import '../../../../generated/l10n.dart';
import '../_profile_view_model.dart';
import '_mood_summary_card.dart';
import '_daily_tracking_card.dart';

class AnalyticsSection extends StatelessWidget {
  final bool isPremium;
  final Analytics? analytics;
  final bool isWeek;

  const AnalyticsSection({
    super.key,
    required this.isPremium,
    this.analytics,
    this.isWeek = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      children: [
        // CONTENIDO ORIGINAL (sin blur)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _EmotionalMoodSection(
              analytics: analytics,
              isWeek: isWeek,
              isPremium: isPremium,
            ),
            const SizedBox(height: AppSizes.spacingLarge),
            if (isPremium)
              _SpiritualMoodSection(
                analytics: analytics,
                isWeek: isWeek,
                isPremium: isPremium,
              ),
            if (isPremium) const SizedBox(height: AppSizes.spacingMedium),
          ],
        ),

        // OVERLAY con BLUR + GRADIENT
        if (!isPremium)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.surface.withValues(alpha: 0.4),
                    theme.colorScheme.surface,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _EmotionalMoodSection extends ConsumerWidget {
  final Analytics? analytics;
  final bool isWeek;
  final bool isPremium;

  const _EmotionalMoodSection({
    this.analytics,
    this.isWeek = false,
    this.isPremium = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final lang = S.of(context);
    final predominantMoodId = analytics?.rangeStats?.predominantEmotionalMoodId;
    final viewModel = ref.read(profileViewModelProvider.notifier);
    final predominantMood = viewModel.getMoodById(
      predominantMoodId,
      isEmotional: true,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(lang.emotionalMoodSummary, style: theme.textTheme.titleLarge),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: lang.youFeltMostOften,
                style: theme.textTheme.bodyMedium,
              ),
              WidgetSpan(
                child: ImageFiltered(
                  imageFilter: isPremium
                      ? ImageFilter.blur(sigmaX: 0, sigmaY: 0)
                      : ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                  child: Text(
                    "${(isPremium ? (predominantMood?.icon ?? '') : '💚')}${(predominantMood?.name ?? '')}",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: theme.textTheme.titleSmall?.fontWeight,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (isWeek) const SizedBox(height: AppSizes.spacingSmall),
        if (isWeek)
          ImageFiltered(
            imageFilter: isPremium
                ? ImageFilter.blur(sigmaX: 0, sigmaY: 0)
                : ImageFilter.blur(sigmaX: 3, sigmaY: 3),
            child: DailyTrackingCard(
              analytics: analytics,
              dataType: DailyDataType.emotional,
              isPremium: isPremium,
            ),
          ),
        const SizedBox(height: AppSizes.spacingSmall),
        ImageFiltered(
          imageFilter: isPremium
              ? ImageFilter.blur(sigmaX: 0, sigmaY: 0)
              : ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          child: MoodSummaryCard(
            rangeStats: analytics?.rangeStats,
            isEmotional: true,
            isPremium: isPremium,
          ),
        ),
      ],
    );
  }
}

class _SpiritualMoodSection extends ConsumerWidget {
  final Analytics? analytics;
  final bool isWeek;
  final bool isPremium;

  const _SpiritualMoodSection({
    this.analytics,
    this.isWeek = false,
    this.isPremium = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final lang = S.of(context);
    final predominantMoodId = analytics?.rangeStats?.predominantSpiritualMoodId;
    final viewModel = ref.read(profileViewModelProvider.notifier);
    final predominantMood = viewModel.getMoodById(
      predominantMoodId,
      isEmotional: false,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(lang.spiritualMoodSummary, style: theme.textTheme.titleLarge),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(text: lang.predominantSpiritualMood, style: theme.textTheme.bodyMedium),
              WidgetSpan(child: ImageFiltered(
                imageFilter: isPremium
                  ? ImageFilter.blur(sigmaX: 0, sigmaY: 0)
                  : ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                child: Text(
                  "${(isPremium ? (predominantMood?.icon ?? '') : '💜')}${(predominantMood?.name ?? '')}",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: theme.textTheme.titleSmall?.fontWeight,
                  ),
                ),
              ),
            )],
          ),
        ),
        if (isWeek) const SizedBox(height: AppSizes.spacingSmall),
        if (isWeek)
          DailyTrackingCard(
            analytics: analytics,
            dataType: DailyDataType.spiritual,
            isPremium: isPremium,
          ),
        const SizedBox(height: AppSizes.spacingSmall),
        MoodSummaryCard(
          rangeStats: analytics?.rangeStats,
          isEmotional: false,
          isPremium: isPremium,
        ),
      ],
    );
  }
}
