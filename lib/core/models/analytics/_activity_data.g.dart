// GENERATED CODE - DO NOT MODIFY BY HAND

part of '_activity_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActivityData _$ActivityDataFromJson(Map<String, dynamic> json) => ActivityData(
  mood: json['mood'] as bool?,
  devotional: json['devotional'] as bool?,
);

Map<String, dynamic> _$ActivityDataToJson(ActivityData instance) =>
    <String, dynamic>{
      if (instance.mood case final value?) 'mood': value,
      if (instance.devotional case final value?) 'devotional': value,
    };
