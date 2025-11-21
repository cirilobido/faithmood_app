import '_daily_stats.dart';
import '_range_stats.dart';

class Analytics {
  final List<DailyStats>? dailyStats;
  final RangeStats? rangeStats;
  final List<String>? datesWithLogs;

  Analytics({
    this.dailyStats,
    this.rangeStats,
    this.datesWithLogs,
  });
}

