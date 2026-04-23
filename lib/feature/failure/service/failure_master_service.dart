import 'dart:convert';
import '../../../service/network_service/api_client.dart';
import '../../../service/network_service/app_urls.dart';
import '../model/failure_master_model.dart';

class FailureMasterService {
  final ApiClient _apiClient = ApiClient();

  Future<FailureCategoryResponse> getCategoryTypes({int type = 2}) async {
    final response = await _apiClient.get(
      AppUrls.getFailureCategoryTypes,
      queryParameters: {'type': type.toString()},
    );
    final Map<String, dynamic> jsonBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return FailureCategoryResponse.fromJson(jsonBody);
    } else {
      throw Exception(jsonBody['message'] ?? 'Failed to fetch categories');
    }
  }

  Future<FailureLocationResponse> getLocations({int type = 2}) async {
    final response = await _apiClient.get(
      AppUrls.getLocations,
      queryParameters: {'type': type.toString()},
    );
    final Map<String, dynamic> jsonBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return FailureLocationResponse.fromJson(jsonBody);
    } else {
      throw Exception(jsonBody['message'] ?? 'Failed to fetch locations');
    }
  }

  Future<FailureFunctionLocationResponse> getFunctionLocations({int type = 2}) async {
    final response = await _apiClient.get(
      AppUrls.getFunctionLocations,
      queryParameters: {'type': type.toString()},
    );
    final Map<String, dynamic> jsonBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return FailureFunctionLocationResponse.fromJson(jsonBody);
    } else {
      throw Exception(jsonBody['message'] ?? 'Failed to fetch function locations');
    }
  }

  Future<FailureSubLocationResponse> getSubLocations({int type = 2}) async {
    final response = await _apiClient.get(
      AppUrls.getSubLocations,
      queryParameters: {'type': type.toString()},
    );
    final Map<String, dynamic> jsonBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return FailureSubLocationResponse.fromJson(jsonBody);
    } else {
      throw Exception(jsonBody['message'] ?? 'Failed to fetch sub locations');
    }
  }

  Future<ObjectPartResponse> getObjectParts({int type = 2}) async {
    final response = await _apiClient.get(
      AppUrls.getObjectParts,
      queryParameters: {'type': type.toString()},
    );
    final Map<String, dynamic> jsonBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return ObjectPartResponse.fromJson(jsonBody);
    } else {
      throw Exception(jsonBody['message'] ?? 'Failed to fetch object parts');
    }
  }

  Future<FaultResponse> getFaults({int type = 2}) async {
    final response = await _apiClient.get(
      AppUrls.getFaults,
      queryParameters: {'type': type.toString()},
    );
    final Map<String, dynamic> jsonBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return FaultResponse.fromJson(jsonBody);
    } else {
      throw Exception(jsonBody['message'] ?? 'Failed to fetch faults');
    }
  }

  Future<RootCauseResponse> getRootCauses({int type = 2}) async {
    final response = await _apiClient.get(
      AppUrls.getRootCauses,
      queryParameters: {'type': type.toString()},
    );
    final Map<String, dynamic> jsonBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return RootCauseResponse.fromJson(jsonBody);
    } else {
      throw Exception(jsonBody['message'] ?? 'Failed to fetch root causes');
    }
  }

  Future<FailureMaterialResponse> getMaterials({int type = 2}) async {
    final response = await _apiClient.get(
      AppUrls.getMaterials,
      queryParameters: {'type': type.toString()},
    );
    final Map<String, dynamic> jsonBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return FailureMaterialResponse.fromJson(jsonBody);
    } else {
      throw Exception(jsonBody['message'] ?? 'Failed to fetch materials');
    }
  }

  Future<FailureActionTakenResponse> getActionTaken({int type = 2}) async {
    final response = await _apiClient.get(
      AppUrls.getActionTaken,
      queryParameters: {'type': type.toString()},
    );
    final Map<String, dynamic> jsonBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return FailureActionTakenResponse.fromJson(jsonBody);
    } else {
      throw Exception(jsonBody['message'] ?? 'Failed to fetch action taken');
    }
  }

  Future<StoreLocationResponse> getStoreLocations({int type = 2}) async {
    final response = await _apiClient.get(
      AppUrls.getStoreLocations,
      queryParameters: {'type': type.toString()},
    );
    final Map<String, dynamic> jsonBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return StoreLocationResponse.fromJson(jsonBody);
    } else {
      throw Exception(jsonBody['message'] ?? 'Failed to fetch store locations');
    }
  }
}
