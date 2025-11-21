import 'package:json_annotation/json_annotation.dart';
import '_analytics.dart';
import '_daily_stats.dart';
import '_range_stats.dart';

part '_analytics_response.g.dart';

@JsonSerializable(includeIfNull: false)
class AnalyticsResponse {
  @JsonKey(name: 'dailyStats')
  final List<DailyStats>? dailyStats;
  @JsonKey(name: 'rangeStats')
  final RangeStats? rangeStats;
  @JsonKey(name: 'datesWithLogs')
  final List<String>? datesWithLogs;

  AnalyticsResponse({
    this.dailyStats,
    this.rangeStats,
    this.datesWithLogs,
  });

  factory AnalyticsResponse.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AnalyticsResponseToJson(this);

  Analytics toAnalytics() {
    return Analytics(
      dailyStats: dailyStats,
      rangeStats: rangeStats,
      datesWithLogs: datesWithLogs,
    );
  }
}

