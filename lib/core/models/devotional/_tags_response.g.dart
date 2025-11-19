// GENERATED CODE - DO NOT MODIFY BY HAND

part of '_tags_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TagsResponse _$TagsResponseFromJson(Map<String, dynamic> json) => TagsResponse(
  tags: (json['tags'] as List<dynamic>?)
      ?.map((e) => DevotionalTag.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$TagsResponseToJson(TagsResponse instance) =>
    <String, dynamic>{if (instance.tags case final value?) 'tags': value};
