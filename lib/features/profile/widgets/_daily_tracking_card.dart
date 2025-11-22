import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  List<String> _localizedWeekDays(String locale) {
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    return List.generate(7, (i) {
      final day = monday.add(Duration(days: i));
      return DateFormat.E(locale).format(day);
    });
  }

  Map<String, String?> _buildIconMap(
    List<String> weekDays,
    String locale,
    WidgetRef ref,
  ) {
    final Map<String, String?> iconByDay = {
      for (var day in weekDays) day: null,
    };

    if (analytics?.dailyStats == null) return iconByDay;

    final viewModel = ref.read(profileViewModelProvider.notifier);

    for (final stat in analytics!.dailyStats!) {
      final dayAbbr = DateFormat.E(
        locale,
      ).format(DateTime.parse(stat.date ?? ''));
      final moodId = dataType == DailyDataType.emotional
          ? stat.predominantEmotionalMoodId
          : stat.predominantSpiritualMoodId;

      if (moodId != null) {
        final mood = viewModel.getMoodById(
          moodId,
          isEmotional: dataType == DailyDataType.emotional,
        );
        iconByDay[dayAbbr] = isPremium ? mood?.icon : '💙';
      }
    }

    return iconByDay;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = Localizations.localeOf(context).toString();
    final weekDays = _localizedWeekDays(locale);
    final iconByDay = _buildIconMap(weekDays, locale, ref);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: weekDays.map((day) {
            return _DayColumn(day: day, icon: iconByDay[day]);
          }).toList(),
        ),
      ],
    );
  }
}

class _DayColumn extends StatelessWidget {
  final String day;
  final String? icon;

  const _DayColumn({required this.day, required this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSizes.spacingSmall),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            day,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: theme.textTheme.titleSmall?.fontWeight,
              color: theme.textTheme.labelSmall?.color,
            ),
          ),
          SizedBox(
            height: AppSizes.iconSizeRegular,
            width: AppSizes.iconSizeRegular,
            child: Text(
              icon ?? '—',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
