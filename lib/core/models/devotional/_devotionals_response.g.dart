// GENERATED CODE - DO NOT MODIFY BY HAND

part of '_devotionals_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DevotionalsResponse _$DevotionalsResponseFromJson(Map<String, dynamic> json) =>
    DevotionalsResponse(
      total: (json['total'] as num?)?.toInt(),
      page: (json['page'] as num?)?.toInt(),
      limit: (json['limit'] as num?)?.toInt(),
      totalPages: (json['totalPages'] as num?)?.toInt(),
      results: (json['results'] as List<dynamic>?)
          ?.map((e) => Devotional.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DevotionalsResponseToJson(
  DevotionalsResponse instance,
) => <String, dynamic>{
  if (instance.total case final value?) 'total': value,
  if (instance.page case final value?) 'page': value,
  if (instance.limit case final value?) 'limit': value,
  if (instance.totalPages case final value?) 'totalPages': value,
  if (instance.results case final value?) 'results': value,
};
