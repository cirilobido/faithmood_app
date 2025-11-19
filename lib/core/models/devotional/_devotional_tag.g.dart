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
      color: json['color'] as String?,
      icon: json['icon'] as String?,
      isActive: json['isActive'] as bool?,
    );

Map<String, dynamic> _$DevotionalTagToJson(DevotionalTag instance) =>
    <String, dynamic>{
      if (instance.id case final value?) 'id': value,
      if (instance.key case final value?) 'key': value,
      if (instance.name case final value?) 'name': value,
      if (instance.color case final value?) 'color': value,
      if (instance.icon case final value?) 'icon': value,
      if (instance.isActive case final value?) 'isActive': value,
    };
