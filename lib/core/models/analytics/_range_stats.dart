import 'package:json_annotation/json_annotation.dart';

part '_range_stats.g.dart';

@JsonSerializable(includeIfNull: false)
class RangeStats {
  final int? totalLogs;
  final int? logsWithNotes;
  final int? totalDevotionals;
  final int? devotionalsWithNotes;
  @JsonKey(name: 'predominantEmotionalMoodId')
  final int? predominantEmotionalMoodId;
  @JsonKey(name: 'predominantSpiritualMoodId')
  final int? predominantSpiritualMoodId;
  @JsonKey(name: 'emotionalMoodCountsById')
  final Map<String, int>? emotionalMoodCountsById;
  @JsonKey(name: 'spiritualMoodCountsById')
  final Map<String, int>? spiritualMoodCountsById;

  RangeStats({
    this.totalLogs,
    this.logsWithNotes,
    this.totalDevotionals,
    this.devotionalsWithNotes,
    this.predominantEmotionalMoodId,
    this.predominantSpiritualMoodId,
    this.emotionalMoodCountsById,
    this.spiritualMoodCountsById,
  });

  factory RangeStats.fromJson(Map<String, dynamic> json) =>
      _$RangeStatsFromJson(json);

  Map<String, dynamic> toJson() => _$RangeStatsToJson(this);
}

