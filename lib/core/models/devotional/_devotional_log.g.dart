// GENERATED CODE - DO NOT MODIFY BY HAND

part of '_devotional_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DevotionalLog _$DevotionalLogFromJson(Map<String, dynamic> json) =>
    DevotionalLog(
      id: (json['id'] as num?)?.toInt(),
      userId: (json['userId'] as num?)?.toInt(),
      devotional: json['devotional'] == null
          ? null
          : DevotionalLogDevotional.fromJson(
              json['devotional'] as Map<String, dynamic>,
            ),
      isFavorite: json['isFavorite'] as bool?,
      isCompleted: json['isCompleted'] as bool?,
      note: json['note'] as String?,
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$DevotionalLogToJson(DevotionalLog instance) =>
    <String, dynamic>{
      if (instance.id case final value?) 'id': value,
      if (instance.userId case final value?) 'userId': value,
      if (instance.devotional case final value?) 'devotional': value,
      if (instance.isFavorite case final value?) 'isFavorite': value,
      if (instance.isCompleted case final value?) 'isCompleted': value,
      if (instance.note case final value?) 'note': value,
      if (instance.completedAt?.toIso8601String() case final value?)
        'completedAt': value,
      if (instance.createdAt?.toIso8601String() case final value?)
        'createdAt': value,
      if (instance.updatedAt?.toIso8601String() case final value?)
        'updatedAt': value,
    };
