import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../service/network_service/api_client.dart';
import '../../../service/network_service/app_urls.dart';
import '../model/login_response.dart';

class AuthService {
  AuthService({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<LoginResponse> login({
    required String email,
    required String password,
    String? deviceToken,
  }) async {
    final http.Response response = await _apiClient.post(
      AppUrls.login,
      body: <String, dynamic>{
        'email': email,
        'password': password,
        'device_token': deviceToken,
      },
    );
    final Map<String, dynamic> jsonBody =
        jsonDecode(response.body) as Map<String, dynamic>;
     print("response====${response.body}");
    if (response.statusCode == 200) {
      return LoginResponse.fromJson(jsonBody);
    }
     print("error==${response.statusCode}");
    final message = jsonBody['message']?.toString() ??
        jsonBody['detail']?.toString() ??
        'Unable to login. (${response.statusCode})';
    throw AuthException(message);
  }
}

class AuthException implements Exception {
  AuthException(this.message);
  final String message;

  @override
  String toString() => '$message';
}

