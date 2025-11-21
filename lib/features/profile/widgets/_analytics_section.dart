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
    return ImageFiltered(
      imageFilter: isPremium
          ? ImageFilter.blur(sigmaX: 0, sigmaY: 0)
          : ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _EmotionalMoodSection(analytics: analytics, isWeek: isWeek),
          const SizedBox(height: AppSizes.spacingLarge),
          _SpiritualMoodSection(analytics: analytics, isWeek: isWeek),
          const SizedBox(height: AppSizes.spacingMedium),
        ],
      ),
    );
  }
}

class _EmotionalMoodSection extends ConsumerWidget {
  final Analytics? analytics;
  final bool isWeek;

  const _EmotionalMoodSection({this.analytics, this.isWeek = false});

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
        Row(
          children: [
            Text(lang.youFeltMostOften, style: theme.textTheme.bodyMedium),
            const SizedBox(width: AppSizes.spacingXSmall),
            Text(
              "${predominantMood?.icon ?? ''}${(predominantMood?.name ?? '')}",
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: theme.textTheme.titleSmall?.fontWeight,
              ),
            ),
          ],
        ),
        if (isWeek) const SizedBox(height: AppSizes.spacingSmall),
        if (isWeek)
          DailyTrackingCard(
            analytics: analytics,
            dataType: DailyDataType.emotional,
          ),
        const SizedBox(height: AppSizes.spacingSmall),
        MoodSummaryCard(rangeStats: analytics?.rangeStats, isEmotional: true),
      ],
    );
  }
}

class _SpiritualMoodSection extends ConsumerWidget {
  final Analytics? analytics;
  final bool isWeek;

  const _SpiritualMoodSection({this.analytics, this.isWeek = false});

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
        Row(
          children: [
            Text(
              lang.predominantSpiritualMood,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(width: AppSizes.spacingXSmall),
            Text(
              "${predominantMood?.icon ?? ''}${(predominantMood?.name ?? '')}",
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: theme.textTheme.titleSmall?.fontWeight,
              ),
            ),
          ],
        ),

        if (isWeek) const SizedBox(height: AppSizes.spacingSmall),
        if (isWeek)
          DailyTrackingCard(
            analytics: analytics,
            dataType: DailyDataType.spiritual,
          ),
        const SizedBox(height: AppSizes.spacingSmall),
        MoodSummaryCard(rangeStats: analytics?.rangeStats, isEmotional: false),
      ],
    );
  }
}
