import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:om_appcart/feature/user_profile/service/user_profile_service.dart';
import 'package:om_appcart/service/network_service/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  SharedPreferences.setMockInitialValues({});
  group('UserProfileService Master APIs', () {
    test('getCities returns CityResponse on 200', () async {
      final mockClient = MockClient((request) async {
        final responseBody = {
          "status": true,
          "message": "City list fetched",
          "data": [
            {
              "name": "banglore",
              "cityCode": "BNGL",
              "isActive": true,
              "id": 6,
              "createdAt": "2025-12-16T12:42:23.537254+05:30",
              "updatedAt": "2025-12-16T12:42:23.537799+05:30",
              "isDeleted": 0
            }
          ],
          "totalRecords": 1
        };
        return http.Response(jsonEncode(responseBody), 200);
      });

      final apiClient = ApiClient(httpClient: mockClient);
      final service = UserProfileService(apiClient: apiClient);

      final result = await service.getCities();

      expect(result.status, true);
      expect(result.data.length, 1);
      expect(result.data[0].name, 'banglore');
      expect(result.data[0].cityCode, 'BNGL');
    });

    test('getDepartmentTypes returns DepartmentTypeResponse on 200', () async {
      final mockClient = MockClient((request) async {
        final responseBody = {
          "status": true,
          "message": "Department type list fetched",
          "data": [
            {
              "name": "civil",
              "isActive": true,
              "departmentTypeCode": "CVL",
              "id": 14,
              "createdAt": "2026-01-21T09:33:54.961837+05:30",
              "updatedAt": "2026-01-21T09:35:25.602340+05:30",
              "isDeleted": 0
            }
          ],
          "totalRecords": 1
        };
        return http.Response(jsonEncode(responseBody), 200);
      });

      final apiClient = ApiClient(httpClient: mockClient);
      final service = UserProfileService(apiClient: apiClient);

      final result = await service.getDepartmentTypes();

      expect(result.status, true);
      expect(result.data.length, 1);
      expect(result.data[0].name, 'civil');
      expect(result.data[0].departmentTypeCode, 'CVL');
    });

    test('getRoles returns RoleResponse on 200', () async {
      final mockClient = MockClient((request) async {
        final responseBody = {
          "status": true,
          "message": "Role List fetched ",
          "data": [
            {
              "name": "Admin",
              "roleCode": "2",
              "isActive": true,
              "id": 2,
              "createdAt": "2026-01-30T10:50:40.741167+05:30",
              "updatedAt": "2026-01-30T10:50:40.741981+05:30",
              "isDeleted": 0
            }
          ],
          "totalRecords": 1
        };
        return http.Response(jsonEncode(responseBody), 200);
      });

      final apiClient = ApiClient(httpClient: mockClient);
      final service = UserProfileService(apiClient: apiClient);

      final result = await service.getRoles();

      expect(result.status, true);
      expect(result.data.length, 1);
      expect(result.data[0].name, 'Admin');
      expect(result.data[0].roleCode, '2');
    });

    test('getDesignations returns DesignationResponse on 200', () async {
      final mockClient = MockClient((request) async {
        final responseBody = {
          "status": true,
          "message": "Designation list fetched",
          "data": [
            {
              "name": "ac asst",
              "designationCode": "1109",
              "isActive": true,
              "id": 1099,
              "createdAt": "2025-10-31T16:28:22.638194+05:30",
              "updatedAt": "2025-10-31T16:28:24.361563+05:30",
              "isDeleted": 0
            }
          ],
          "totalRecords": 1
        };
        return http.Response(jsonEncode(responseBody), 200);
      });

      final apiClient = ApiClient(httpClient: mockClient);
      final service = UserProfileService(apiClient: apiClient);

      final result = await service.getDesignations();

      expect(result.status, true);
      expect(result.data.length, 1);
      expect(result.data[0].name, 'ac asst');
      expect(result.data[0].designationCode, '1109');
    });
  });
}
