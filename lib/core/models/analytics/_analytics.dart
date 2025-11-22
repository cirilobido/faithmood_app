import '_daily_stats.dart';
import '_range_stats.dart';
import '_activity_data.dart';

class Analytics {
  final List<DailyStats>? dailyStats;
  final RangeStats? rangeStats;
  final Map<String, ActivityData>? activityByDate;

  Analytics({
    this.dailyStats,
    this.rangeStats,
    this.activityByDate,
  });
}

