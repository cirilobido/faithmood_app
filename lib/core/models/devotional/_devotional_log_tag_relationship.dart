import 'package:json_annotation/json_annotation.dart';

import '../tags/_tag.dart';

part '_devotional_log_tag_relationship.g.dart';

@JsonSerializable(includeIfNull: false)
class DevotionalLogTagRelationship {
  final int? id;
  final int? devotionalId;
  final int? tagId;
  final Tag? tag;

  DevotionalLogTagRelationship({
    this.id,
    this.devotionalId,
    this.tagId,
    this.tag,
  });

  factory DevotionalLogTagRelationship.fromJson(Map<String, dynamic> json) =>
      _$DevotionalLogTagRelationshipFromJson(json);

  Map<String, dynamic> toJson() => _$DevotionalLogTagRelationshipToJson(this);
}

