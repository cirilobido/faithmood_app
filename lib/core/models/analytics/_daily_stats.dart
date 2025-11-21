import 'package:json_annotation/json_annotation.dart';

part '_daily_stats.g.dart';

@JsonSerializable(includeIfNull: false)
class DailyStats {
  final String? date;
  final int? moodCount;
  @JsonKey(name: 'predominantEmotionalMoodId')
  final int? predominantEmotionalMoodId;
  @JsonKey(name: 'predominantSpiritualMoodId')
  final int? predominantSpiritualMoodId;

  DailyStats({
    this.date,
    this.moodCount,
    this.predominantEmotionalMoodId,
    this.predominantSpiritualMoodId,
  });

  factory DailyStats.fromJson(Map<String, dynamic> json) =>
      _$DailyStatsFromJson(json);

  Map<String, dynamic> toJson() => _$DailyStatsToJson(this);
}

