// GENERATED CODE - DO NOT MODIFY BY HAND

part of '_moods_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MoodsResponse _$MoodsResponseFromJson(Map<String, dynamic> json) =>
    MoodsResponse(
      moods: (json['moods'] as List<dynamic>?)
          ?.map((e) => Mood.fromJson(e as Map<String, dynamic>))
          .toList(),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$MoodsResponseToJson(MoodsResponse instance) =>
    <String, dynamic>{
      if (instance.moods case final value?) 'moods': value,
      if (instance.message case final value?) 'message': value,
    };
