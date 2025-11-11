import 'package:json_annotation/json_annotation.dart';

import '_plans.dart';

part '_plans_response.g.dart';

@JsonSerializable()
class PlansResponse {
  final String? message;
  final List<Plans>? plans;

  PlansResponse({
    this.message,
    this.plans,
  });

  factory PlansResponse.fromJson(Map<String, dynamic> json) =>
      _$PlansResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PlansResponseToJson(this);
}
