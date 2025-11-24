import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/core_exports.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  final httpClient = ref.watch(dioProvider);
  final requestProcessor = ref.read(requestProcessorProvider);
  return AuthServiceImpl(
    httpClient: httpClient,
    requestProcessor: requestProcessor,
  );
});

abstract class AuthService {
  Future<UserResponse?> registerUser(AuthRequest params);

  Future<UserResponse?> loginUser(AuthRequest params);

  Future<UserResponse?> refreshToken(String refreshToken);

  Future<UserResponse?> getUser(int id);

  Future<UserResponse?> updateUserData(User params);

  Future<UserResponse?> deleteUser(int id);

  Future<UserResponse?> changePassword(User params);

  Future<bool> sendOtp(AuthRequest params);

  Future<bool> verifyOtp(AuthRequest params);

  Future<UserResponse?> syncSubscription(AuthRequest params);
}

class AuthServiceImpl implements AuthService {
  final Dio httpClient;
  final RequestProcessor requestProcessor;

  AuthServiceImpl({required this.httpClient, required this.requestProcessor});

  @override
  Future<UserResponse?> registerUser(AuthRequest params) async {
    try {
      return await requestProcessor.process(
        request: httpClient.post(Endpoints.register, data: params.toJson()),
        jsonMapper: (data) {
          final response = UserResponse.fromJson(data as Map<String, dynamic>);
          if (response.token == null) {
            throw Exception();
          }
          return response;
        },
      );
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<UserResponse?> loginUser(AuthRequest params) async {
    try {
      return await requestProcessor.process(
        request: httpClient.post(Endpoints.login, data: params.toJson()),
        jsonMapper: (data) {
          final response = UserResponse.fromJson(data as Map<String, dynamic>);
          if (response.token == null) {
            throw Exception();
          }
          return response;
        },
      );
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<UserResponse?> refreshToken(String refreshToken) async {
    try {
      return await requestProcessor.process(
        request: httpClient.post(
          Endpoints.refreshToken,
          data: {"refreshToken": refreshToken},
        ),
        jsonMapper: (data) {
          final response = UserResponse.fromJson(data as Map<String, dynamic>);
          if (response.token == null) {
            throw Exception();
          }
          return response;
        },
      );
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<UserResponse?> getUser(int id) async {
    try {
      return await requestProcessor.process(
        request: httpClient.get("${Endpoints.user}/$id"),
        jsonMapper: (data) {
          final response = UserResponse.fromJson(data as Map<String, dynamic>);
          if (response.user == null) {
            throw Exception();
          }
          return response;
        },
      );
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<UserResponse?> updateUserData(User params) async {
    try {
      return await requestProcessor.process(
        request: httpClient.put(
          '${Endpoints.user}/update/${params.id}',
          data: params.toJson(),
        ),
        jsonMapper: (data) {
          final response = UserResponse.fromJson(data as Map<String, dynamic>);
          if (response.user == null) {
            throw Exception();
          }
          return response;
        },
      );
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<UserResponse?> deleteUser(int id) async {
    try {
      return await requestProcessor.process(
        request: httpClient.delete("${Endpoints.user}/delete/$id"),
        jsonMapper: (data) {
          final response = UserResponse.fromJson(data as Map<String, dynamic>);
          if (response.message == null) {
            throw Exception();
          }
          return response;
        },
      );
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<UserResponse?> changePassword(User params) async {
    try {
      final userJson = params.toJson();
      final paramsMap = params as dynamic;
      if (paramsMap.password != null) {
        userJson['password'] = paramsMap.password;
      }
      if (paramsMap.newPassword != null) {
        userJson['newPassword'] = paramsMap.newPassword;
      }
      return await requestProcessor.process(
        request: httpClient.put(
          '${Endpoints.changePassword}/${params.id}',
          data: userJson,
        ),
        jsonMapper: (data) {
          final response = UserResponse.fromJson(data as Map<String, dynamic>);
          if (response.user == null) {
            throw Exception();
          }
          return response;
        },
      );
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<bool> sendOtp(AuthRequest params) async {
    try {
      return await requestProcessor.process(
        request: httpClient.post(Endpoints.sendOtp, data: params.toJson()),
        jsonMapper: (data) {
          final response = data as Map<String, dynamic>;
          if (response['message'] == null) {
            throw Exception();
          }
          return true;
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> verifyOtp(AuthRequest params) async {
    try {
      return await requestProcessor.process(
        request: httpClient.post(Endpoints.verifyOtp, data: params.toJson()),
        jsonMapper: (data) {
          final response = data as Map<String, dynamic>;
          if (response['message'] == null) {
            throw Exception();
          }
          return true;
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserResponse?> syncSubscription(AuthRequest params) async {
    try {
      return await requestProcessor.process(
        request: httpClient.post(
          '${Endpoints.syncSubscription}/${params.id}',
          data: params.toJson(),
        ),
        jsonMapper: (data) {
          final response = UserResponse.fromJson(data as Map<String, dynamic>);
          if (response.user == null) {
            throw Exception();
          }
          return response;
        },
      );
    } catch (e) {
      throw Exception();
    }
  }
}
