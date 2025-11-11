import 'package:json_annotation/json_annotation.dart';
import 'package:faithmood_app/core/core_exports.dart';

part '_auth_request.g.dart';

@JsonSerializable(includeIfNull: false)
class AuthRequest {
  final String? id;
  final String? name;
  final int? age;
  final String? email;
  final String? password;
  final Lang? lang;
  final String? otpCode;
  final String? newPassword;
  final String? fcmToken;
  final String? timezone;

  AuthRequest({
    this.id,
    this.name,
    this.age,
    this.email,
    this.password,
    this.lang,
    this.otpCode,
    this.newPassword,
    this.fcmToken,
    this.timezone,
  });

  factory AuthRequest.fromJson(Map<String, dynamic> json) =>
      _$AuthRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AuthRequestToJson(this);

  copyWith({
    String? id,
    String? name,
    int? age,
    String? email,
    String? password,
    Lang? lang,
    String? otpCode,
    String? newPassword,
    String? fcmToken,
    String? timezone,
  }) {
    return AuthRequest(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      email: email ?? this.email,
      password: password ?? this.password,
      lang: lang ?? this.lang,
      otpCode: otpCode ?? this.otpCode,
      newPassword: newPassword ?? this.newPassword,
      fcmToken: fcmToken ?? this.fcmToken,
      timezone: timezone ?? this.timezone,
    );
  }
}
