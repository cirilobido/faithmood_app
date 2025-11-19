import 'package:json_annotation/json_annotation.dart';

import '_devotional_tag.dart';

part '_tags_response.g.dart';

@JsonSerializable(includeIfNull: false)
class TagsResponse {
  final List<DevotionalTag>? tags;

  TagsResponse({
    this.tags,
  });

  factory TagsResponse.fromJson(Map<String, dynamic> json) =>
      _$TagsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TagsResponseToJson(this);
}

