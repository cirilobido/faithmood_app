// GENERATED CODE - DO NOT MODIFY BY HAND

part of '_devotional_log_tag.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DevotionalLogTag _$DevotionalLogTagFromJson(Map<String, dynamic> json) =>
    DevotionalLogTag(
      id: (json['id'] as num?)?.toInt(),
      icon: json['icon'] as String?,
      color: json['color'] as String?,
      translations: (json['translations'] as List<dynamic>?)
          ?.map(
            (e) => DevotionalTagTranslation.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );

Map<String, dynamic> _$DevotionalLogTagToJson(DevotionalLogTag instance) =>
    <String, dynamic>{
      if (instance.id case final value?) 'id': value,
      if (instance.icon case final value?) 'icon': value,
      if (instance.color case final value?) 'color': value,
      if (instance.translations case final value?) 'translations': value,
    };
