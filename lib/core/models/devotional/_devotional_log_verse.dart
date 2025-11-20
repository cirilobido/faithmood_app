import 'package:json_annotation/json_annotation.dart';

import '_devotional_log_verse_translation.dart';

part '_devotional_log_verse.g.dart';

@JsonSerializable(includeIfNull: false)
class DevotionalLogVerse {
  final int? id;
  final String? bookKey;
  final int? chapter;
  final int? verseNumber;
  @JsonKey(name: 'createdAt')
  final DateTime? createdAt;
  final List<DevotionalLogVerseTranslation>? translations;

  DevotionalLogVerse({
    this.id,
    this.bookKey,
    this.chapter,
    this.verseNumber,
    this.createdAt,
    this.translations,
  });

  factory DevotionalLogVerse.fromJson(Map<String, dynamic> json) =>
      _$DevotionalLogVerseFromJson(json);

  Map<String, dynamic> toJson() => _$DevotionalLogVerseToJson(this);
}

