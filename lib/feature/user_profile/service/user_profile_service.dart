import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../../service/auth_manager.dart';
import '../../../service/network_service/api_client.dart';
import '../../../service/network_service/app_urls.dart';
import '../model/user_profile_model.dart';
import '../model/master_model.dart';

class UserProfileService {
  final ApiClient _apiClient;

  UserProfileService({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  Future<UserProfileResponse> getUserProfile({required int userId}) async {
    final token = await AuthManager().getToken();
    final uri = Uri.parse('${AppUrls.baseUrl}${AppUrls.updateUsers}').replace(
      queryParameters: {'user_id': userId.toString()},
    );

    final response = await http.get(
      uri,
      headers: {
        'accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    final Map<String, dynamic> jsonBody = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return UserProfileResponse.fromJson(jsonBody);
    } else {
      final message = jsonBody['message'] ?? 'Failed to fetch profile';
      throw Exception(message);
    }
  }

  Future<UserProfileResponse> updateUserProfile({
    required int userId,
    required Map<String, dynamic> userData,
    File? profilePic,
  }) async {
    final token = await AuthManager().getToken();
    
    // Construct the URI with query parameter user_id
    final uri = Uri.parse('${AppUrls.baseUrl}${AppUrls.updateUsers}').replace(
      queryParameters: {'user_id': userId.toString()},
    );

    final request = http.MultipartRequest('PUT', uri);

    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    // Add JSON data as a field called 'userData'
    request.fields['userData'] = jsonEncode(userData);

    // Add profile picture if provided
    if (profilePic != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'file',
        profilePic.path,
      ));
    }

    try {
      final streamedResponse = await request.send().timeout(const Duration(seconds: 30));
      final response = await http.Response.fromStream(streamedResponse);

      final Map<String, dynamic> jsonBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return UserProfileResponse.fromJson(jsonBody);
      } else {
        final message = jsonBody['message'] ?? 
                        (jsonBody['detail'] is List ? jsonBody['detail'][0]['msg'] : jsonBody['detail']) ?? 
                        'Failed to update profile';
        throw Exception(message);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<UserProfileResponse> getUserDetails({required String userCode}) async {
    final token = await AuthManager().getToken();
    final uri = Uri.parse('${AppUrls.baseUrl}${AppUrls.getUsers}').replace(
      queryParameters: {'userCode': userCode},
    );

    final response = await http.get(
      uri,
      headers: {
        'accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    final Map<String, dynamic> jsonBody = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return UserProfileResponse.fromJson(jsonBody);
    } else {
      final message = jsonBody['message'] ?? 'Failed to fetch user details';
      throw Exception(message);
    }
  }

  Future<CityResponse> getCities({int type = 2}) async {
    final response = await _apiClient.get(
      AppUrls.getCities,
      queryParameters: {'type': type.toString()},
    );

    final Map<String, dynamic> jsonBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return CityResponse.fromJson(jsonBody);
    } else {
      throw Exception(jsonBody['message'] ?? 'Failed to fetch cities');
    }
  }

  Future<DepartmentTypeResponse> getDepartmentTypes({int type = 2}) async {
    final response = await _apiClient.get(
      AppUrls.getDepartmentTypes,
      queryParameters: {'type': type.toString()},
    );

    final Map<String, dynamic> jsonBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return DepartmentTypeResponse.fromJson(jsonBody);
    } else {
      throw Exception(jsonBody['message'] ?? 'Failed to fetch department types');
    }
  }

  Future<RoleResponse> getRoles({int type = 2}) async {
    final response = await _apiClient.get(
      AppUrls.getRoles,
      queryParameters: {'type': type.toString()},
    );

    final Map<String, dynamic> jsonBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return RoleResponse.fromJson(jsonBody);
    } else {
      throw Exception(jsonBody['message'] ?? 'Failed to fetch roles');
    }
  }

  Future<DesignationResponse> getDesignations({int type = 2}) async {
    final response = await _apiClient.get(
      AppUrls.getDesignations,
      queryParameters: {'type': type.toString()},
    );

    final Map<String, dynamic> jsonBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return DesignationResponse.fromJson(jsonBody);
    } else {
      throw Exception(jsonBody['message'] ?? 'Failed to fetch designations');
    }
  }

  Future<UserProfileResponse> getUsers({int type = 2}) async {
    final response = await _apiClient.get(
      AppUrls.updateUsers,
      queryParameters: {'type': type.toString()},
    );

    final Map<String, dynamic> jsonBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return UserProfileResponse.fromJson(jsonBody);
    } else {
      throw Exception(jsonBody['message'] ?? 'Failed to fetch users');
    }
  }
}
