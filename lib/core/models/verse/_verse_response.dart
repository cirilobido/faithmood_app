import 'package:json_annotation/json_annotation.dart';

import '_verse.dart';

part '_verse_response.g.dart';

@JsonSerializable(includeIfNull: false)
class VerseResponse {
  final Verse? verse;

  VerseResponse({
    this.verse,
  });

  factory VerseResponse.fromJson(Map<String, dynamic> json) => _$VerseResponseFromJson(json);
}
