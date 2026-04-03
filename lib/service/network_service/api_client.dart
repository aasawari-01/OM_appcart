import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../../feature/auth_login/view/login_view.dart';
import '../auth_manager.dart';

import 'app_urls.dart';

class ApiClient {
  ApiClient({
    http.Client? httpClient,
    this.baseUrl = AppUrls.baseUrl,
  }) : _client = httpClient ?? http.Client();

  final http.Client _client;
  final String baseUrl;

  Uri _buildUri(String endpoint) {
    final normalizedBase = baseUrl.endsWith('/') ? baseUrl : '$baseUrl/';
    return Uri.parse('$normalizedBase$endpoint');
  }

  Future<http.Response> post(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
  }) async {
    var uri = _buildUri(endpoint);
    if (queryParameters != null) {
      uri = uri.replace(queryParameters: queryParameters);
    }
    final token = await AuthManager().getToken();
    final mergedHeaders = <String, String>{
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
      if (headers != null) ...headers,
    };
    print("endpoint==$uri body==$body");
    final encodedBody = body == null ? null : jsonEncode(body);

    try {
      final response = await _client
          .post(uri, headers: mergedHeaders, body: encodedBody)
          .timeout(const Duration(seconds: 30));
      print("response===$response");
      return _handleResponse(response);
    } catch (e) {
      print("Error during POST request to $uri: $e");
      rethrow;
    }
  }

  Future<http.Response> put(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
  }) async {
    var uri = _buildUri(endpoint);
    if (queryParameters != null) {
      uri = uri.replace(queryParameters: queryParameters);
    }
    final token = await AuthManager().getToken();
    final mergedHeaders = <String, String>{
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
      if (headers != null) ...headers,
    };
    print("endpoint==$uri body==$body");
    final encodedBody = body == null ? null : jsonEncode(body);

    try {
      final response = await _client
          .put(uri, headers: mergedHeaders, body: encodedBody)
          .timeout(const Duration(seconds: 30));
      print("response===$response");
      return _handleResponse(response);
    } catch (e) {
      print("Error during PUT request to $uri: $e");
      rethrow;
    }
  }

  Future<http.Response> get(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    final uri = _buildUri(endpoint).replace(queryParameters: queryParameters);
    final token = await AuthManager().getToken();
    final mergedHeaders = <String, String>{
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
      if (headers != null) ...headers,
    };
    print("endpoint==$uri");

    try {
      final response = await _client
          .get(uri, headers: mergedHeaders)
          .timeout(const Duration(seconds: 30));
      print("response===$response");
      return _handleResponse(response);
    } catch (e) {
      print("Error during GET request to $uri: $e");
      rethrow;
    }
  }

  http.Response _handleResponse(http.Response response) {
    if (response.statusCode == 401 || response.statusCode == 403) {
      try {
        final body = jsonDecode(response.body);
        print("body==+$body");
        if (body['detail'] == 'Not authenticated') {
          _showReLoginDialog();
        }
      } catch (e) {
        // If it's not JSON or detail is missing, still might be auth error
        if (response.statusCode == 401) {
          _showReLoginDialog();
        }
      }
    }
    print("body==+${response.body}");
    return response;
  }

  void _showReLoginDialog() {
    if (Get.isDialogOpen ?? false) return;

    Get.defaultDialog(
      title: "Session Expired",
      middleText: "Your session has expired or you are not authenticated. Please log out and log in again to continue.",
      textConfirm: "Logout",
      confirmTextColor: Colors.white,
      onConfirm: () async {
        await AuthManager().logout();
        Get.offAll(() => const LoginView());
      },
      barrierDismissible: false,
    );
  }
}

