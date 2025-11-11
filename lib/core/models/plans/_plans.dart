import 'package:json_annotation/json_annotation.dart';

import '_plan_name.dart';

part '_plans.g.dart';

@JsonSerializable(includeIfNull: false)
class Plans {
  final int? id;
  final PlanName? name;
  final int? dailyLimit;
  final String? price;
  final String? gpPlanId;

  Plans({
    this.id,
    this.name,
    this.dailyLimit,
    this.price,
    this.gpPlanId,
  });

  factory Plans.fromJson(Map<String, dynamic> json) =>
      _$PlansFromJson(json);

  Map<String, dynamic> toJson() => _$PlansToJson(this);
}
