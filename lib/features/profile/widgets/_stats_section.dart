import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/core_exports.dart';
import '../../../widgets/widgets_exports.dart';
import '../_profile_view_model.dart';
import '../../../generated/l10n.dart';


class StatsSection extends ConsumerWidget {
  final bool isPremium;
  final Analytics? analytics;
  final int? streak;

  const StatsSection({
    super.key,
    required this.isPremium,
    this.analytics,
    this.streak,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(profileViewModelProvider.notifier);
    final state = ref.watch(profileViewModelProvider);
    final theme = Theme.of(context);
    final lang = S.of(context);

    final totalLogs = analytics?.rangeStats?.totalLogs ?? 0;
    final totalDevotionals = analytics?.rangeStats?.totalDevotionals ?? 0;
    final totalDays = analytics?.dailyStats?.length ?? 0;
    final streakDays = streak ?? 0;

    final predominantEmotionalMoodId =
        analytics?.rangeStats?.predominantEmotionalMoodId;
    final predominantSpiritualMoodId =
        analytics?.rangeStats?.predominantSpiritualMoodId;
    final emotionalMood = viewModel.getMoodById(
      predominantEmotionalMoodId,
      isEmotional: true,
    );
    final spiritualMood = viewModel.getMoodById(
      predominantSpiritualMoodId,
      isEmotional: false,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                '📈 ${AnalyticsPeriod.toTitle(context: context, type: state.selectedPeriod ?? AnalyticsPeriod.thisWeek) ?? ''}',
                style: theme.textTheme.titleLarge,
              ),
            ),
            if (isPremium)
              _PeriodFilterDropDown(
                selectedPeriod: state.selectedPeriod,
                onChanged: (value) {
                  viewModel.getAnalytics(value);
                },
              ),
          ],
        ),
        const SizedBox(height: AppSizes.spacingSmall),
        Text(
          lang.youveLoggedEntriesOnDays(totalDays),
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.textTheme.labelSmall?.color,
          ),
        ),
        const SizedBox(height: AppSizes.spacingSmall),
        if (totalLogs > 0 || totalDevotionals > 0)
          Column(
            children: [
              // First row: Total Logs and Total Devotionals
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      icon: AppIcons.heartIcon,
                      value: totalLogs.toString(),
                      label: lang.moods,
                    ),
                  ),
                  const SizedBox(width: AppSizes.spacingSmall),
                  Expanded(
                    child: _StatCard(
                      icon: AppIcons.openBookIcon,
                      value: totalDevotionals.toString(),
                      label: lang.devotionals,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.spacingSmall),
              // Second row: Most Frequent Emotional and Spiritual Mood
              Row(
                children: [
                  Expanded(
                    child: _MoodStatCard(
                      icon: AppIcons.happyIcon,
                      mood: emotionalMood,
                      label: lang.myEmotion,
                    ),
                  ),
                  const SizedBox(width: AppSizes.spacingSmall),
                  Expanded(
                    child: _MoodStatCard(
                      icon: AppIcons.spiritIcon,
                      mood: spiritualMood,
                      label: lang.mySpirit,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.spacingSmall),
              _StreakCard(streak: streakDays),
            ],
          ),
      ],
    );
  }
}

class _PeriodFilterDropDown extends StatelessWidget {
  final AnalyticsPeriod? selectedPeriod;
  final Function(AnalyticsPeriod)? onChanged;

  const _PeriodFilterDropDown({
    required this.selectedPeriod,
    required this.onChanged,
  });

  static final periodList = [
    AnalyticsPeriod.thisWeek,
    AnalyticsPeriod.lastWeek,
    AnalyticsPeriod.thisMonth,
    AnalyticsPeriod.lastMonth,
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lang = S.of(context);

    return InkWell(
      splashColor: Colors.transparent,
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                lang.selectAPeriod,
                style: theme.textTheme.titleMedium,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: periodList.map((e) {
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      AnalyticsPeriod.toTitle(context: context, type: e) ?? '',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: (selectedPeriod == e)
                            ? theme.textTheme.titleMedium?.fontWeight
                            : null,
                        color: (selectedPeriod == e)
                            ? theme.colorScheme.primary
                            : theme.textTheme.bodyLarge?.color,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      onChanged?.call(e);
                    },
                  );
                }).toList(),
              ),
              actions: [
                CustomButton(
                  title: lang.cancel,
                  type: ButtonType.neutral,
                  isShortText: true,
                  onTap: () => Navigator.pop(context),
                ),
              ],
            );
          },
        );
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AnalyticsPeriod.toTitle(context: context, type: selectedPeriod) ??
                '',
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(width: AppSizes.spacingXSmall),
          SvgPicture.asset(
            AppIcons.arrowRightIcon,
            height: AppSizes.iconSizeSmall,
            width: AppSizes.iconSizeSmall,
            colorFilter: ColorFilter.mode(
              theme.colorScheme.primary,
              BlendMode.srcIn,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String icon;
  final String value;
  final String label;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingMedium,
        vertical: AppSizes.paddingSmall,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface,
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            icon,
            height: AppSizes.iconSizeRegular,
            width: AppSizes.iconSizeRegular,
            colorFilter: ColorFilter.mode(
              theme.colorScheme.primary,
              BlendMode.srcIn,
            ),
          ),
          Text(label, style: theme.textTheme.bodyMedium),
          const SizedBox(height: AppSizes.spacingXSmall),
          Text(value, style: theme.textTheme.titleLarge),
        ],
      ),
    );
  }
}

class _MoodStatCard extends StatelessWidget {
  final String icon;
  final Mood? mood;
  final String label;

  const _MoodStatCard({
    required this.icon,
    required this.mood,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingMedium,
        vertical: AppSizes.paddingSmall,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface,
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            icon,
            height: AppSizes.iconSizeRegular,
            width: AppSizes.iconSizeRegular,
            colorFilter: ColorFilter.mode(
              theme.colorScheme.primary,
              BlendMode.srcIn,
            ),
          ),
          Text(label, style: theme.textTheme.bodyMedium),
          const SizedBox(height: AppSizes.spacingXSmall),
          Text(
            "${mood?.icon ?? ''}${(mood?.name ?? 'N/A')}",
            style: theme.textTheme.titleSmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _StreakCard extends StatelessWidget {
  final int streak;

  const _StreakCard({required this.streak});

  /// Returns a Christian-themed emoji and status based on streak length
  /// Represents the spiritual journey and growth in faith
  Map<String, String> _getStreakInfo(int days, S lang) {
    String emoji;
    String status;

    if (days == 0) {
      emoji = '🕯️';
      status = lang.streakStatusLightingInnerLight;
    } else if (days >= 1 && days <= 2) {
      emoji = '🌱';
      status = lang.streakStatusSeedOfFaith;
    } else if (days >= 3 && days <= 4) {
      emoji = '🌿';
      status = lang.streakStatusStartingToGrow;
    } else if (days >= 5 && days <= 7) {
      emoji = '🍃';
      status = lang.streakStatusConstantGrowth;
    } else if (days >= 8 && days <= 11) {
      emoji = '✝️';
      status = lang.streakStatusFoundationInChrist;
    } else if (days >= 12 && days <= 15) {
      emoji = '🙏';
      status = lang.streakStatusDisciplineInPrayer;
    } else if (days >= 16 && days <= 19) {
      emoji = '🕊️';
      status = lang.streakStatusPeaceOfHolySpirit;
    } else if (days >= 20 && days <= 23) {
      emoji = '📖';
      status = lang.streakStatusFedByTheWord;
    } else if (days >= 24 && days <= 26) {
      emoji = '🌳';
      status = lang.streakStatusFirmAndDeepFaith;
    } else if (days >= 27 && days <= 29) {
      emoji = '🌅';
      status = lang.streakStatusPerseveranceToTheEnd;
    } else if (days == 30) {
      emoji = '🫶';
      status = lang.streakStatusGratefulHeart;
    } else if (days == 31) {
      emoji = '👑';
      status = lang.streakStatusVictoryOfTheMonth;
    } else {
      emoji = '✨';
      status = lang.streakStatusExpandingFaith;
    }
    return {'emoji': emoji, 'status': status};
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lang = S.of(context);
    final streakInfo = _getStreakInfo(streak, lang);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingMedium,
        vertical: AppSizes.paddingMedium,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(streakInfo['emoji']!, style: theme.textTheme.headlineSmall),
              const SizedBox(width: AppSizes.spacingSmall),
              Text(streak.toString(), style: theme.textTheme.headlineSmall),
              const SizedBox(width: AppSizes.spacingXSmall),
              Text(' ${lang.streakDays}', style: theme.textTheme.headlineSmall),
            ],
          ),
          const SizedBox(height: AppSizes.spacingXSmall),
          Text(
            streakInfo['status']!,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.labelSmall?.color,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
