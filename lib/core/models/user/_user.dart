import 'package:json_annotation/json_annotation.dart';

import '../../core_exports.dart';

part '_user.g.dart';

@JsonSerializable(includeIfNull: false)
class User {
  final int? id;
  final String? deviceId;
  final String? name;
  final String? email;
  final String? password;
  final String? newPassword;
  final int? age;
  final Lang? lang;
  final PlanName? planType;
  final int? maxDailyRequest;
  final int? countDreams;
  final int? todayDreams;
  final bool? isActive;
  User({
    this.id,
    this.deviceId,
    this.name,
    this.email,
    this.password,
    this.newPassword,
    this.age,
    this.lang,
    this.planType,
    this.maxDailyRequest,
    this.countDreams,
    this.todayDreams,
    this.isActive,
  });

  factory User.fromJson(Map<String, dynamic> json) =>
      _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  User copyWith({
    int? id,
    String? deviceId,
    String? name,
    String? email,
    String? password,
    String? newPassword,
    int? age,
    Lang? lang,
    PlanName? planType,
    int? maxDailyRequest,
    int? countDreams,
    int? todayDreams,
    bool? isActive,
    String? adaptyProfileId,
    String? subscriptionStatus,
    DateTime? subscriptionEndsAt,
    DateTime? lastAdaptyCheck,
  }) {
    return User(
      id: id ?? this.id,
      deviceId: deviceId ?? this.deviceId,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      newPassword: newPassword ?? this.newPassword,
      age: age ?? this.age,
      lang: lang ?? this.lang,
      planType: planType ?? this.planType,
      maxDailyRequest: maxDailyRequest ?? this.maxDailyRequest,
      countDreams: countDreams ?? this.countDreams,
      todayDreams: todayDreams ?? this.todayDreams,
      isActive: isActive ?? this.isActive,
    );
  }
}
