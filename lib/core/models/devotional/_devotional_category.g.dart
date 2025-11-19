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
      description: json['description'] as String?,
      coverImage: json['coverImage'] as String?,
      iconEmoji: json['iconEmoji'] as String?,
      isPremium: json['isPremium'] as bool?,
      isActive: json['isActive'] as bool?,
      order: (json['order'] as num?)?.toInt(),
    );

Map<String, dynamic> _$DevotionalCategoryToJson(DevotionalCategory instance) =>
    <String, dynamic>{
      if (instance.id case final value?) 'id': value,
      if (instance.key case final value?) 'key': value,
      if (instance.title case final value?) 'title': value,
      if (instance.description case final value?) 'description': value,
      if (instance.coverImage case final value?) 'coverImage': value,
      if (instance.iconEmoji case final value?) 'iconEmoji': value,
      if (instance.isPremium case final value?) 'isPremium': value,
      if (instance.isActive case final value?) 'isActive': value,
      if (instance.order case final value?) 'order': value,
    };
