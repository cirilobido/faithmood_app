// GENERATED CODE - DO NOT MODIFY BY HAND

part of '_devotional_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DevotionalCategory _$DevotionalCategoryFromJson(Map<String, dynamic> json) =>
    DevotionalCategory(
      id: (json['id'] as num?)?.toInt(),
      key: json['key'] as String?,
      title: json['title'] as String?,
    );

Map<String, dynamic> _$DevotionalCategoryToJson(DevotionalCategory instance) =>
    <String, dynamic>{
      if (instance.id case final value?) 'id': value,
      if (instance.key case final value?) 'key': value,
      if (instance.title case final value?) 'title': value,
    };
