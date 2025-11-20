// GENERATED CODE - DO NOT MODIFY BY HAND

part of '_mood.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Mood _$MoodFromJson(Map<String, dynamic> json) => Mood(
  id: (json['id'] as num?)?.toInt(),
  key: json['key'] as String?,
  name: json['name'] as String?,
  description: json['description'] as String?,
  category: json['category'] as String?,
  icon: json['icon'] as String?,
  tags: (json['tags'] as List<dynamic>?)
      ?.map((e) => MoodTag.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$MoodToJson(Mood instance) => <String, dynamic>{
  if (instance.id case final value?) 'id': value,
  if (instance.key case final value?) 'key': value,
  if (instance.name case final value?) 'name': value,
  if (instance.description case final value?) 'description': value,
  if (instance.category case final value?) 'category': value,
  if (instance.icon case final value?) 'icon': value,
  if (instance.tags case final value?) 'tags': value,
};
