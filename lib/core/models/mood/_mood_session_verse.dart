import 'package:json_annotation/json_annotation.dart';

import '../verse/_verse_translation.dart';

part '_mood_session_verse.g.dart';

@JsonSerializable(includeIfNull: false)
class MoodSessionVerse {
  final int? id;
  final String? bookKey;
  final int? chapter;
  final int? verseNumber;
  final List<VerseTranslation>? translations;

  MoodSessionVerse({
    this.id,
    this.bookKey,
    this.chapter,
    this.verseNumber,
    this.translations,
  });

  factory MoodSessionVerse.fromJson(Map<String, dynamic> json) =>
      _$MoodSessionVerseFromJson(json);

  Map<String, dynamic> toJson() => _$MoodSessionVerseToJson(this);
}
