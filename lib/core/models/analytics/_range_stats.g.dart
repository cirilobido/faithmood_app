// GENERATED CODE - DO NOT MODIFY BY HAND

part of '_range_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RangeStats _$RangeStatsFromJson(Map<String, dynamic> json) => RangeStats(
  totalLogs: (json['totalLogs'] as num?)?.toInt(),
  logsWithNotes: (json['logsWithNotes'] as num?)?.toInt(),
  totalDevotionals: (json['totalDevotionals'] as num?)?.toInt(),
  devotionalsWithNotes: (json['devotionalsWithNotes'] as num?)?.toInt(),
  predominantEmotionalMoodId: (json['predominantEmotionalMoodId'] as num?)
      ?.toInt(),
  predominantSpiritualMoodId: (json['predominantSpiritualMoodId'] as num?)
      ?.toInt(),
  emotionalMoodCountsById:
      (json['emotionalMoodCountsById'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ),
  spiritualMoodCountsById:
      (json['spiritualMoodCountsById'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ),
);

Map<String, dynamic> _$RangeStatsToJson(
  RangeStats instance,
) => <String, dynamic>{
  if (instance.totalLogs case final value?) 'totalLogs': value,
  if (instance.logsWithNotes case final value?) 'logsWithNotes': value,
  if (instance.totalDevotionals case final value?) 'totalDevotionals': value,
  if (instance.devotionalsWithNotes case final value?)
    'devotionalsWithNotes': value,
  if (instance.predominantEmotionalMoodId case final value?)
    'predominantEmotionalMoodId': value,
  if (instance.predominantSpiritualMoodId case final value?)
    'predominantSpiritualMoodId': value,
  if (instance.emotionalMoodCountsById case final value?)
    'emotionalMoodCountsById': value,
  if (instance.spiritualMoodCountsById case final value?)
    'spiritualMoodCountsById': value,
};
