import 'package:ams/feature/data/datasource/remote/api_client.dart';
import 'package:ams/feature/data/datasource/remote/api_response.dart';
import 'package:ams/feature/data/datasource/remote/api_urls.dart';
import 'package:ams/feature/presentation/pages/dashboard/model/location_model.dart';
import 'package:flutter/foundation.dart';

class ClockInOutRepo {
  final ApiClient apiClient;

  ClockInOutRepo({required this.apiClient});

  // Get office location
  Future<ApiResponse> getOfficeLocation() async {
    final token = apiClient.token;

    if (token.isEmpty) {
      throw Exception('JWT Token is missing or invalid');
    }

    final response = await ApiClient.getApi(
      ApiUrls.officelocation,
      token: token,
      fromJson: (json) => LocationModel.fromJson(json),
    );
    return response;
  }

  // Post clock In
  Future<ApiResponse> postClockin(
      int deviceID, String latitude, String longitude) async {
    final token = apiClient.token;

    if (token.isEmpty) {
      throw Exception('JWT token is missing or invalid');
    }
    const url = ApiUrls.postclockin;
    if (kDebugMode) {
      print(url);
    }

    final response = await ApiClient.postApi(
      requestBody: {
        'device_id': deviceID,
        'latitude': latitude,
        'longitude': longitude,
      },
      url,
      token: token,
      fromJson: null,
    );
    return response;
  }

  // Post Clock Out
  Future<ApiResponse> postClockout(
      int deviceID, String latitude, String longitude) async {
    final token = apiClient.token;

    if (token.isEmpty) {
      throw Exception('JWT token is missing or invalid');
    }
    const url = ApiUrls.postclockout;
    if (kDebugMode) {
      print(url);
    }

    final response = await ApiClient.postApi(
      requestBody: {
        'device_id': deviceID,
        'latitude': latitude,
        'longitude': longitude,
      },
      url,
      token: token,
      fromJson: null,
    );
    return response;
  }

  // Post on Break
  Future<ApiResponse> postOnBreak(int employeeId) async {
    final token = apiClient.token;

    if (token.isEmpty) {
      throw Exception('JWT token is missing or invalid');
    }
    const url = ApiUrls.onbreak;
    if (kDebugMode) {
      print(url);
    }

    final response = await ApiClient.postApi(
      requestBody: {
        'employee_no': employeeId,
      },
      url,
      token: token,
      fromJson: null,
    );
    return response;
  }

  // Post on Resume
  Future<ApiResponse> postResume(
    int employeeId,
    String latitude,
    String longitude,
  ) async {
    final token = apiClient.token;

    if (token.isEmpty) {
      throw Exception('JWT token is missing or invalid');
    }
    const url = ApiUrls.onresume;
    if (kDebugMode) {
      print(url);
    }

    final response = await ApiClient.postApi(
      requestBody: {
        'employee_no': employeeId,
        'latitude': latitude,
        'longitude': longitude,
      },
      url,
      token: token,
      fromJson: null,
    );
    return response;
  }
}
