// GENERATED CODE - DO NOT MODIFY BY HAND

part of '_devotional_logs_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DevotionalLogsResponse _$DevotionalLogsResponseFromJson(
  Map<String, dynamic> json,
) => DevotionalLogsResponse(
  total: (json['total'] as num?)?.toInt(),
  page: PaginatedResponse.parseInt(json['page']),
  limit: PaginatedResponse.parseInt(json['limit']),
  totalPages: (json['totalPages'] as num?)?.toInt(),
  sortBy: json['sortBy'] as String?,
  order: json['order'] as String?,
  logs: (json['logs'] as List<dynamic>?)
      ?.map((e) => DevotionalLog.fromJson(e as Map<String, dynamic>))
      .toList(),
  message: json['message'] as String?,
);

Map<String, dynamic> _$DevotionalLogsResponseToJson(
  DevotionalLogsResponse instance,
) => <String, dynamic>{
  if (instance.total case final value?) 'total': value,
  if (instance.totalPages case final value?) 'totalPages': value,
  if (instance.sortBy case final value?) 'sortBy': value,
  if (instance.order case final value?) 'order': value,
  if (instance.message case final value?) 'message': value,
  if (instance.logs case final value?) 'logs': value,
  if (PaginatedResponse.stringify(instance.page) case final value?)
    'page': value,
  if (PaginatedResponse.stringify(instance.limit) case final value?)
    'limit': value,
};
