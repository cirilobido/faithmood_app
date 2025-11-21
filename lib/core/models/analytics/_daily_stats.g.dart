// GENERATED CODE - DO NOT MODIFY BY HAND

part of '_daily_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DailyStats _$DailyStatsFromJson(Map<String, dynamic> json) => DailyStats(
  date: json['date'] as String?,
  moodCount: (json['moodCount'] as num?)?.toInt(),
  predominantEmotionalMoodId: (json['predominantEmotionalMoodId'] as num?)
      ?.toInt(),
  predominantSpiritualMoodId: (json['predominantSpiritualMoodId'] as num?)
      ?.toInt(),
);

Map<String, dynamic> _$DailyStatsToJson(DailyStats instance) =>
    <String, dynamic>{
      if (instance.date case final value?) 'date': value,
      if (instance.moodCount case final value?) 'moodCount': value,
      if (instance.predominantEmotionalMoodId case final value?)
        'predominantEmotionalMoodId': value,
      if (instance.predominantSpiritualMoodId case final value?)
        'predominantSpiritualMoodId': value,
    };
