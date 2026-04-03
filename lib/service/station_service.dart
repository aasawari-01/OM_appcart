import 'dart:convert';
import 'package:http/http.dart' as http;
import './network_service/api_client.dart';
import './network_service/app_urls.dart';
import '../feature/lost&found/model/lost_found_table_record.dart'; // Reusing Station model for now

class StationListResponse {
  final bool status;
  final String message;
  final List<Station> data;
  final int totalRecords;

  StationListResponse({
    required this.status,
    required this.message,
    required this.data,
    required this.totalRecords,
  });

  factory StationListResponse.fromJson(Map<String, dynamic> json) => StationListResponse(
        status: json["status"] ?? false,
        message: json["message"] ?? "",
        data: json["data"] == null
            ? []
            : List<Station>.from(json["data"].map((x) => Station.fromJson(x))),
        totalRecords: json["totalRecords"] ?? 0,
      );
}

class StationService {
  final ApiClient _apiClient = ApiClient();

  Future<StationListResponse> getStations() async {
    final response = await _apiClient.get(
      AppUrls.getStations,
      queryParameters: {
        'type': '2',
      },
    );

    final Map<String, dynamic> jsonBody = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return StationListResponse.fromJson(jsonBody);
    } else {
      throw Exception(jsonBody['message'] ?? 'Failed to fetch stations');
    }
  }
}
