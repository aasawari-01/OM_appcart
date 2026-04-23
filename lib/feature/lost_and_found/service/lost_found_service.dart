import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../../service/auth_manager.dart';
import '../../../service/network_service/api_client.dart';
import '../../../service/network_service/app_urls.dart';
import '../model/lost_found_table_record.dart';

class LostFoundService {
  final ApiClient _apiClient;

  LostFoundService({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  Future<LostFoundResponse> getLostFoundTable({
    int skip = 0,
    int limit = 10,
    String? search,
    String sortBy = 'createdAt',
    int sortOrder = 2,
    Map<String, dynamic>? filter,
  }) async {
    final queryParams = {
      'skip': skip.toString(),
      'limit': limit.toString(),
      'sortBy': sortBy,
      'sortOrder': sortOrder.toString(),
      if (search != null) 'search': search,
      if (filter != null) 'filter': jsonEncode(filter),
    };

    final response = await _apiClient.get(
      AppUrls.lostFoundTable,
      queryParameters: queryParams,
    );

    final Map<String, dynamic> jsonBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return LostFoundResponse.fromJson(jsonBody);
    } else {
      throw Exception(jsonBody['message'] ?? 'Failed to load lost and found items');
    }
  }

  Future<LostFoundSingleResponse> getSingleLostFoundData(String uniqueCode) async {
    final response = await _apiClient.get(
      AppUrls.singleLostFoundData,
      queryParameters: {'uniqueCode': uniqueCode},
    );

    final Map<String, dynamic> jsonBody = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return LostFoundSingleResponse.fromJson(jsonBody);
    } else {
      throw Exception(jsonBody['message'] ?? 'Failed to load record details');
    }
  }

  Future<Map<String, dynamic>> createLostFound(Map<String, dynamic> data, List<File> files) async {
    final token = await AuthManager().getToken();
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${AppUrls.baseUrl}${AppUrls.createLostFound}'),
    );

    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    request.fields['lostFoundData'] = jsonEncode(data);

    for (var file in files) {
      request.files.add(await http.MultipartFile.fromPath(
        'files',
        file.path,
      ));
    }

    final streamedResponse = await request.send().timeout(const Duration(seconds: 30));
    final response = await http.Response.fromStream(streamedResponse);

    final Map<String, dynamic> jsonBody = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonBody;
    } else {
      throw Exception(jsonBody['message'] ?? 'Failed to create lost and found item');
    }
  }

  Future<Map<String, dynamic>> updateLostFound(int lostFoundID, Map<String, dynamic> data, List<File> files) async {
    final token = await AuthManager().getToken();
    final request = http.MultipartRequest(
      'PUT',
      Uri.parse('${AppUrls.baseUrl}${AppUrls.createLostFound}').replace(queryParameters: {
        'lostFoundID': lostFoundID.toString(),
      }),
    );

    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    request.fields['lostFoundData'] = jsonEncode(data);

    for (var file in files) {
      request.files.add(await http.MultipartFile.fromPath(
        'files',
        file.path,
      ));
    }

    final streamedResponse = await request.send().timeout(const Duration(seconds: 30));
    final response = await http.Response.fromStream(streamedResponse);
    final Map<String, dynamic> jsonBody = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonBody;
    } else {
      throw Exception(jsonBody['message'] ?? 'Failed to update lost and found item');
    }
  }

  Future<Map<String, dynamic>> autoMatch(String uniqueCode) async {
    final response = await _apiClient.get(
      AppUrls.autoMatch,
      queryParameters: {'uniqueCode': uniqueCode},
    );

    final Map<String, dynamic> jsonBody = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return jsonBody;
    } else {
      throw Exception(jsonBody['message'] ?? 'Failed to perform auto-match');
    }
  }

  Future<Map<String, dynamic>> finalizeMatch(int lostID, int foundID) async {
    final response = await _apiClient.post(
      AppUrls.finalizeMatch,
      queryParameters: {
        'lostID': lostID.toString(),
        'foundID': foundID.toString(),
      },
    );

    final Map<String, dynamic> jsonBody = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonBody;
    } else {
      throw Exception(jsonBody['message'] ?? 'Failed to finalize match');
    }
  }

  Future<Map<String, dynamic>> bulkSoftDelete(List<int> ids) async {
    final response = await _apiClient.put(
      AppUrls.bulkSoftDeleteLostFound,
      body: {'ids': ids},
    );

    final Map<String, dynamic> jsonBody = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return jsonBody;
    } else {
      throw Exception(jsonBody['message'] ?? 'Failed to delete records');
    }
  }
}
