import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../../../../core/core_exports.dart';
import '../_profile_view_model.dart';

enum DailyDataType { emotional, spiritual }

class DailyTrackingCard extends ConsumerWidget {
  final Analytics? analytics;
  final DailyDataType dataType;
  final bool isPremium;

  const DailyTrackingCard({
    super.key,
    required this.analytics,
    required this.dataType,
    required this.isPremium,
  });

  List<DateTime> _getCurrentWeekDates() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final weekday = today.weekday;
    final monday = today.subtract(Duration(days: weekday - 1));
    final weekDates = List.generate(
      7,
      (index) => monday.add(Duration(days: index)),
    );
    return weekDates;
  }

  String _getDayName(DateTime date, Lang? lang) {
    final locale = lang?.name ?? Lang.en.name;
    final dateFormat = DateFormat('E', locale);
    return toBeginningOfSentenceCase(dateFormat.format(date)) ??
        dateFormat.format(date);
  }

  String _getDayNumber(DateTime date) {
    return date.day.toString().padLeft(2, '0');
  }

  Map<DateTime, String?> _buildIconMap(WidgetRef ref) {
    final Map<DateTime, String?> iconByDate = {};

    if (analytics?.dailyStats == null) return iconByDate;

    final viewModel = ref.read(profileViewModelProvider.notifier);

    for (final stat in analytics!.dailyStats!) {
      try {
        final statDate = DateTime.parse(stat.date ?? '');
        final dateOnly = DateTime(statDate.year, statDate.month, statDate.day);
        final moodId = dataType == DailyDataType.emotional
            ? stat.predominantEmotionalMoodId
            : stat.predominantSpiritualMoodId;

        if (moodId != null) {
          final mood = viewModel.getMoodById(
            moodId,
            isEmotional: dataType == DailyDataType.emotional,
          );
          iconByDate[dateOnly] = isPremium ? mood?.icon : null;
        }
      } catch (e) {
        continue;
      }
    }

    return iconByDate;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final userLang = ref.read(authProvider).user?.lang;
    final weekDates = _getCurrentWeekDates();
    final iconByDate = _buildIconMap(ref);
    final today = DateTime.now();
    final todayOnly = DateTime(today.year, today.month, today.day);

    return SizedBox(
      height: AppSizes.homeWeekItemsContainerHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: weekDates.asMap().entries.map((entry) {
          final index = entry.key;
          final date = entry.value;
          final dateOnly = DateTime(date.year, date.month, date.day);
          final isToday = dateOnly.isAtSameMomentAs(todayOnly);
          final isFuture = dateOnly.isAfter(todayOnly);
          final hasData = iconByDate.containsKey(dateOnly);
          final moodEmoji = iconByDate[dateOnly];

          Color backgroundColor;
          if (isToday) {
            backgroundColor = theme.colorScheme.secondary.withValues(
              alpha: 0.6,
            );
          } else if (isFuture) {
            backgroundColor = theme.colorScheme.onSurface;
          } else {
            backgroundColor = theme.colorScheme.primary.withValues(
              alpha: 0.2,
            );
          }

          return Container(
            width: AppSizes.homeWeekItemsWidth,
            margin: EdgeInsets.only(
              right: index < weekDates.length - 1
                  ? AppSizes.spacingSmall
                  : 0,
            ),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(AppSizes.radiusFull),
            ),
            padding: const EdgeInsets.symmetric(
              vertical: AppSizes.paddingSmall,
              horizontal: AppSizes.paddingXSmall,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      _getDayName(date, userLang),
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.textTheme.labelSmall?.color!,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      _getDayNumber(date),
                      style: theme.textTheme.titleSmall,
                    ),
                  ],
                ),
                if (hasData && moodEmoji != null && moodEmoji.isNotEmpty)
                  Text(moodEmoji, style: theme.textTheme.titleLarge)
                else
                  SvgPicture.asset(
                    AppIcons.dottedCircleIcon,
                    width: AppSizes.iconSizeRegular,
                    height: AppSizes.iconSizeRegular,
                    colorFilter: ColorFilter.mode(
                      theme.iconTheme.color!,
                      BlendMode.srcIn,
                    ),
                  ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
