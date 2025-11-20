// GENERATED CODE - DO NOT MODIFY BY HAND

part of '_mood_sessions_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MoodSessionsResponse _$MoodSessionsResponseFromJson(
  Map<String, dynamic> json,
) => MoodSessionsResponse(
  total: (json['total'] as num?)?.toInt(),
  page: MoodSessionsResponse._parseInt(json['page']),
  limit: MoodSessionsResponse._parseInt(json['limit']),
  totalPages: (json['totalPages'] as num?)?.toInt(),
  sortBy: json['sortBy'] as String?,
  order: json['order'] as String?,
  sessions: (json['sessions'] as List<dynamic>?)
      ?.map((e) => MoodSession.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$MoodSessionsResponseToJson(
  MoodSessionsResponse instance,
) => <String, dynamic>{
  if (instance.total case final value?) 'total': value,
  if (MoodSessionsResponse._stringify(instance.page) case final value?)
    'page': value,
  if (MoodSessionsResponse._stringify(instance.limit) case final value?)
    'limit': value,
  if (instance.totalPages case final value?) 'totalPages': value,
  if (instance.sortBy case final value?) 'sortBy': value,
  if (instance.order case final value?) 'order': value,
  if (instance.sessions case final value?) 'sessions': value,
};
