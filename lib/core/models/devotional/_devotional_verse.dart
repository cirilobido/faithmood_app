import 'package:json_annotation/json_annotation.dart';

part '_devotional_verse.g.dart';

@JsonSerializable(includeIfNull: false)
class DevotionalVerse {
  final int? id;
  final String? ref;
  final String? text;

  DevotionalVerse({
    this.id,
    this.ref,
    this.text,
  });

  factory DevotionalVerse.fromJson(Map<String, dynamic> json) =>
      _$DevotionalVerseFromJson(json);

  Map<String, dynamic> toJson() => _$DevotionalVerseToJson(this);
}

