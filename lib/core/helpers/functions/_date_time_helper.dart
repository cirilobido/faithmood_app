import '../../core_exports.dart';

class DateTimeHelper {
  static Map<String, DateTime> getDateRange(AnalyticsPeriod period) {
    switch (period) {
      case AnalyticsPeriod.thisWeek:
        return _getThisWeekRange();
      case AnalyticsPeriod.lastWeek:
        return _getLastWeekRange();
      case AnalyticsPeriod.thisMonth:
        return _getThisMonthRange();
      case AnalyticsPeriod.lastMonth:
        return _getLastMonthRange();
    }
  }

  static Map<String, DateTime> _getThisWeekRange() {
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    final sunday = monday.add(
      const Duration(days: 6, hours: 23, minutes: 59, seconds: 59),
    );

    return {
      'start': DateTime(monday.year, monday.month, monday.day),
      'end': sunday,
    };
  }

  static Map<String, DateTime> _getLastWeekRange() {
    final now = DateTime.now();
    final lastWeekMonday = now.subtract(Duration(days: now.weekday + 6));
    final lastWeekSunday = lastWeekMonday.add(
      const Duration(days: 6, hours: 23, minutes: 59, seconds: 59),
    );

    return {
      'start': DateTime(
        lastWeekMonday.year,
        lastWeekMonday.month,
        lastWeekMonday.day,
      ),
      'end': lastWeekSunday,
    };
  }

  static Map<String, DateTime> _getThisMonthRange() {
    final now = DateTime.now();
    final firstDay = DateTime(now.year, now.month, 1);
    final lastDay = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

    return {'start': firstDay, 'end': lastDay};
  }

  static Map<String, DateTime> _getLastMonthRange() {
    final now = DateTime.now();
    final firstDay = DateTime(now.year, now.month - 1, 1);
    final lastDay = DateTime(now.year, now.month, 0, 23, 59, 59);
    return {'start': firstDay, 'end': lastDay};
  }
}

