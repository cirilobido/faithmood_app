import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/core_exports.dart';
import '../_profile_view_model.dart';
import '../../../../generated/l10n.dart';

class MoodSummaryCard extends ConsumerWidget {
  final RangeStats? rangeStats;
  final bool isEmotional;
  final bool isPremium;

  const MoodSummaryCard({
    super.key,
    required this.rangeStats,
    this.isEmotional = true,
    this.isPremium = false,
  });

  List<_MoodStat> _calculateMoodStats(WidgetRef ref) {
    final total = rangeStats?.totalLogs ?? 0;
    if (total == 0) {
      return [];
    }

    final moodCounts = isEmotional
        ? rangeStats?.emotionalMoodCountsById
        : rangeStats?.spiritualMoodCountsById;

    if (moodCounts == null) return [];

    final viewModel = ref.read(profileViewModelProvider.notifier);

    return moodCounts.entries
        .map((entry) {
          final moodId = int.tryParse(entry.key);
          final count = entry.value;
          final rawPercentage = total > 0 ? (count / total) * 100 : 0.0;
          final percentage = double.parse(
            rawPercentage.isNaN ? '0.0' : rawPercentage.toStringAsFixed(1),
          );
          final mood = viewModel.getMoodById(moodId, isEmotional: isEmotional);
          return _MoodStat(
            moodId: moodId,
            mood: mood,
            entries: count,
            percentage: percentage,
          );
        })
        .toList()
      ..sort((a, b) => b.entries.compareTo(a.entries));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final moodStats = _calculateMoodStats(ref);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(
        top: AppSizes.paddingMedium,
        left: AppSizes.paddingMedium,
        right: AppSizes.paddingMedium,
        bottom: AppSizes.spacingSmall,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        children: moodStats
            .map(
              (stat) => Padding(
                padding: const EdgeInsets.only(bottom: AppSizes.spacingSmall),
                child: _MoodStatRow(stat: stat, isPremium: isPremium),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _MoodStat {
  final int? moodId;
  final Mood? mood;
  final int entries;
  final double percentage;

  _MoodStat({
    required this.moodId,
    this.mood,
    required this.entries,
    required this.percentage,
  });
}

class _MoodStatRow extends StatelessWidget {
  final _MoodStat stat;
  final bool isPremium;

  const _MoodStatRow({required this.stat, required this.isPremium});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lang = S.of(context);
    final mood = stat.mood;
    final moodName = '${(isPremium ? mood?.icon ?? '' : '😊')} ${(mood?.name ?? '')}';

    return Row(
      children: [
        Expanded(
          flex: 5,
          child: Text(
            moodName,
            style: theme.textTheme.titleSmall,
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            '${stat.entries} ${lang.moods}',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            '${stat.percentage}%',
            textAlign: TextAlign.end,
            style: theme.textTheme.bodyMedium
          ),
        ),
      ],
    );
  }
}

