import 'package:json_annotation/json_annotation.dart';

part '_devotional_tag.g.dart';

@JsonSerializable(includeIfNull: false)
class DevotionalTag {
  final int? id;
  final String? key;
  final String? name;

  DevotionalTag({
    this.id,
    this.key,
    this.name,
  });

  factory DevotionalTag.fromJson(Map<String, dynamic> json) =>
      _$DevotionalTagFromJson(json);

  Map<String, dynamic> toJson() => _$DevotionalTagToJson(this);
}

