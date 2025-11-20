// GENERATED CODE - DO NOT MODIFY BY HAND

part of '_mood_session_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MoodSessionResponse _$MoodSessionResponseFromJson(Map<String, dynamic> json) =>
    MoodSessionResponse(
      sessionId: json['sessionId'] as String?,
      message: json['message'] as String?,
    );

Map<String, dynamic> _$MoodSessionResponseToJson(
  MoodSessionResponse instance,
) => <String, dynamic>{
  if (instance.sessionId case final value?) 'sessionId': value,
  if (instance.message case final value?) 'message': value,
};
