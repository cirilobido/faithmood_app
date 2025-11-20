import 'package:json_annotation/json_annotation.dart';

part '_devotional_tag_translation.g.dart';

@JsonSerializable(includeIfNull: false)
class DevotionalTagTranslation {
  final String? name;

  DevotionalTagTranslation({this.name});

  factory DevotionalTagTranslation.fromJson(Map<String, dynamic> json) =>
      _$DevotionalTagTranslationFromJson(json);

  Map<String, dynamic> toJson() => _$DevotionalTagTranslationToJson(this);
}

