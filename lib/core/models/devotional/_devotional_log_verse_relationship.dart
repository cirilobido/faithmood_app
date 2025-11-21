import 'package:json_annotation/json_annotation.dart';

import '../verse/_verse.dart';

part '_devotional_log_verse_relationship.g.dart';

@JsonSerializable(includeIfNull: false)
class DevotionalLogVerseRelationship {
  final int? id;
  final int? devotionalId;
  final int? verseId;
  final Verse? verse;

  DevotionalLogVerseRelationship({
    this.id,
    this.devotionalId,
    this.verseId,
    this.verse,
  });

  factory DevotionalLogVerseRelationship.fromJson(Map<String, dynamic> json) =>
      _$DevotionalLogVerseRelationshipFromJson(json);

  Map<String, dynamic> toJson() => _$DevotionalLogVerseRelationshipToJson(this);
}

