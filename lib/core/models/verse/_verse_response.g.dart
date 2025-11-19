// GENERATED CODE - DO NOT MODIFY BY HAND

part of '_verse_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerseResponse _$VerseResponseFromJson(Map<String, dynamic> json) =>
    VerseResponse(
      verse: json['verse'] == null
          ? null
          : Verse.fromJson(json['verse'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$VerseResponseToJson(VerseResponse instance) =>
    <String, dynamic>{if (instance.verse case final value?) 'verse': value};
