// GENERATED CODE - DO NOT MODIFY BY HAND

part of '_plans_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlansResponse _$PlansResponseFromJson(Map<String, dynamic> json) =>
    PlansResponse(
      message: json['message'] as String?,
      plans: (json['plans'] as List<dynamic>?)
          ?.map((e) => Plans.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PlansResponseToJson(PlansResponse instance) =>
    <String, dynamic>{'message': instance.message, 'plans': instance.plans};
