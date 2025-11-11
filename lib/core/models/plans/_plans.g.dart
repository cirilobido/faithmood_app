// GENERATED CODE - DO NOT MODIFY BY HAND

part of '_plans.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Plans _$PlansFromJson(Map<String, dynamic> json) => Plans(
  id: (json['id'] as num?)?.toInt(),
  name: $enumDecodeNullable(_$PlanNameEnumMap, json['name']),
  dailyLimit: (json['dailyLimit'] as num?)?.toInt(),
  price: json['price'] as String?,
  gpPlanId: json['gpPlanId'] as String?,
);

Map<String, dynamic> _$PlansToJson(Plans instance) => <String, dynamic>{
  if (instance.id case final value?) 'id': value,
  if (_$PlanNameEnumMap[instance.name] case final value?) 'name': value,
  if (instance.dailyLimit case final value?) 'dailyLimit': value,
  if (instance.price case final value?) 'price': value,
  if (instance.gpPlanId case final value?) 'gpPlanId': value,
};

const _$PlanNameEnumMap = {PlanName.FREE: 'FREE', PlanName.PREMIUM: 'PREMIUM'};
