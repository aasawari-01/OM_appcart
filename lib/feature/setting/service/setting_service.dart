import 'dart:convert';

import '../../../service/network_service/api_client.dart';
import 'package:http/http.dart' as http;


import '../../../service/network_service/app_urls.dart';
import '../model/change_password_resp.dart';

class SettingService {
  SettingService({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<ChangePasswordResponse> changePassword({
    required int userId,
    required String oldPassword,
    required String newPassword,
  }) async {
    final http.Response response = await _apiClient.put(
      '${AppUrls.changePassword}?user_id=$userId',
      body: <String, dynamic>{
        'oldPassword': oldPassword,
        'newPassword': newPassword,
      },
    );

    final Map<String, dynamic> jsonBody =
    jsonDecode(response.body) as Map<String, dynamic>;
    print("changePassword response==== ${response.body}");

    if (response.statusCode == 200) {
      return ChangePasswordResponse.fromJson(jsonBody);
}
    print("changePassword error== ${response.statusCode}");
    final message = jsonBody['message']?.toString() ??
        jsonBody['detail']?.toString() ??
        'Unable to change password. (${response.statusCode})';
    throw AuthException(message);
  }




}

class AuthException implements Exception {
  AuthException(this.message);
  final String message;

  @override
  String toString() => '$message';
}