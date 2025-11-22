// GENERATED CODE - DO NOT MODIFY BY HAND

part of '_analytics_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnalyticsResponse _$AnalyticsResponseFromJson(Map<String, dynamic> json) =>
    AnalyticsResponse(
      dailyStats: (json['dailyStats'] as List<dynamic>?)
          ?.map((e) => DailyStats.fromJson(e as Map<String, dynamic>))
          .toList(),
      rangeStats: json['rangeStats'] == null
          ? null
          : RangeStats.fromJson(json['rangeStats'] as Map<String, dynamic>),
      activityByDate: (json['activityByDate'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, ActivityData.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$AnalyticsResponseToJson(AnalyticsResponse instance) =>
    <String, dynamic>{
      if (instance.dailyStats case final value?) 'dailyStats': value,
      if (instance.rangeStats case final value?) 'rangeStats': value,
      if (instance.activityByDate case final value?) 'activityByDate': value,
    };
