// GENERATED CODE - DO NOT MODIFY BY HAND

part of '_tag.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tag _$TagFromJson(Map<String, dynamic> json) => Tag(
  id: (json['id'] as num?)?.toInt(),
  key: json['key'] as String?,
  name: json['name'] as String?,
  color: json['color'] as String?,
  icon: json['icon'] as String?,
  isActive: json['isActive'] as bool?,
  translations: (json['translations'] as List<dynamic>?)
      ?.map((e) => NameTranslation.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$TagToJson(Tag instance) => <String, dynamic>{
  if (instance.id case final value?) 'id': value,
  if (instance.key case final value?) 'key': value,
  if (instance.name case final value?) 'name': value,
  if (instance.color case final value?) 'color': value,
  if (instance.icon case final value?) 'icon': value,
  if (instance.isActive case final value?) 'isActive': value,
  if (instance.translations case final value?) 'translations': value,
};
