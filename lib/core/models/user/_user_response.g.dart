// GENERATED CODE - DO NOT MODIFY BY HAND

part of '_user_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserResponse _$UserResponseFromJson(Map<String, dynamic> json) => UserResponse(
  message: json['message'] as String?,
  user: json['user'] == null
      ? null
      : User.fromJson(json['user'] as Map<String, dynamic>),
  token: json['token'] as String?,
  tokenExpiration: json['tokenExpiration'] as String?,
  refreshToken: json['refreshToken'] as String?,
  refreshExpiration: json['refreshExpiration'] as String?,
  expiresIn: json['expiresIn'] as String?,
);

Map<String, dynamic> _$UserResponseToJson(UserResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'user': instance.user,
      'token': instance.token,
      'tokenExpiration': instance.tokenExpiration,
      'refreshToken': instance.refreshToken,
      'refreshExpiration': instance.refreshExpiration,
      'expiresIn': instance.expiresIn,
    };
