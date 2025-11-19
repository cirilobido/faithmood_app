// GENERATED CODE - DO NOT MODIFY BY HAND

part of '_devotional_log_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DevotionalLogRequest _$DevotionalLogRequestFromJson(
  Map<String, dynamic> json,
) => DevotionalLogRequest(
  devotionalId: (json['devotionalId'] as num).toInt(),
  isFavorite: json['isFavorite'] as bool,
  isCompleted: json['isCompleted'] as bool,
  note: json['note'] as String?,
);

Map<String, dynamic> _$DevotionalLogRequestToJson(
  DevotionalLogRequest instance,
) => <String, dynamic>{
  'devotionalId': instance.devotionalId,
  'isFavorite': instance.isFavorite,
  'isCompleted': instance.isCompleted,
  if (instance.note case final value?) 'note': value,
};
