import 'package:json_annotation/json_annotation.dart';

import '_devotional_tag_translation.dart';

part '_devotional_log_tag.g.dart';

@JsonSerializable(includeIfNull: false)
class DevotionalLogTag {
  final int? id;
  final String? icon;
  final String? color;
  final List<DevotionalTagTranslation>? translations;

  DevotionalLogTag({
    this.id,
    this.icon,
    this.color,
    this.translations,
  });

  factory DevotionalLogTag.fromJson(Map<String, dynamic> json) =>
      _$DevotionalLogTagFromJson(json);

  Map<String, dynamic> toJson() => _$DevotionalLogTagToJson(this);
}

