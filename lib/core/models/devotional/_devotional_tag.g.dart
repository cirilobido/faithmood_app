// GENERATED CODE - DO NOT MODIFY BY HAND

part of '_devotional_tag.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DevotionalTag _$DevotionalTagFromJson(Map<String, dynamic> json) =>
    DevotionalTag(
      id: (json['id'] as num?)?.toInt(),
      key: json['key'] as String?,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$DevotionalTagToJson(DevotionalTag instance) =>
    <String, dynamic>{
      if (instance.id case final value?) 'id': value,
      if (instance.key case final value?) 'key': value,
      if (instance.name case final value?) 'name': value,
    };
