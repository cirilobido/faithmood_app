import 'package:json_annotation/json_annotation.dart';

import '_user.dart';

part '_user_response.g.dart';

@JsonSerializable()
class UserResponse {
  final String? message;
  final User? user;
  final String? token;
  final String? tokenExpiration;
  final String? refreshToken;
  final String? refreshExpiration;
  final String? expiresIn;

  UserResponse({
    this.message,
    this.user,
    this.token,
    this.tokenExpiration,
    this.refreshToken,
    this.refreshExpiration,
    this.expiresIn,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) =>
      _$UserResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UserResponseToJson(this);
}
