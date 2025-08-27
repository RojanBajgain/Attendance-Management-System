// Fix for ClockInOutRepo
import 'dart:convert';
import 'dart:developer';

import 'package:ams/feature/data/datasource/remote/api_client.dart';
import 'package:ams/feature/data/datasource/remote/api_response.dart';
import 'package:ams/feature/data/datasource/remote/api_urls.dart';
import 'package:ams/feature/presentation/pages/dashboard/model/breaktime.dart';
import 'package:ams/feature/presentation/pages/dashboard/model/check_access_point_model.dart';
import 'package:ams/feature/presentation/pages/dashboard/model/location_model.dart';
import 'package:ams/feature/presentation/pages/dashboard/model/resume_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ClockInOutRepo {
  final ApiClient apiClient;

  ClockInOutRepo({required this.apiClient});

  // Get office location
  Future<ApiResponse> getOfficeLocation() async {
    final token = await apiClient.token;
    final organization = await apiClient.organization;

    final response = await apiClient.getApi(
      ApiUrls.officelocation,
      token: token,
      apiKey: organization,
      fromJson: (json) => LocationModel.fromJson(json),
    );
    return response;
  }

  // Access Point
  Future<ApiResponse> checkAccessPoints() async {
    final token = await apiClient.token;
    final organization = await apiClient.organization;

    final response = await apiClient.getApi(
      ApiUrls.accesspoint,
      token: token,
      apiKey: organization,
      fromJson: (json) => CheckAccessPointModel.fromJson(json),
    );
    return response;
  }

  Future<ApiResponse> getCurrentIpAddress() async {
    try {
      final uri = Uri.parse('https://api.ipify.org/?format=json');
      log("🌐 Fetching public IP from: ${uri.toString()}");

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final ipData = json.decode(response.body);
        return ApiResponse.completed(ipData);
      }

      return ApiResponse.error(
        'Failed to get IP address: ${response.statusCode}',
      );
    } catch (e) {
      return ApiResponse.error(
        'Failed to get IP address: $e',
      );
    }
  }

  Future<ApiResponse> postClockin(
    int deviceID,
    String latitude,
    String longitude,
  ) async {
    final token = await apiClient.token;
    final organization = await apiClient.organization;

    if (token.isEmpty) {
      throw Exception('JWT token is missing or invalid');
    }

    // Validate location data - make sure we're sending strings, not empty values
    if (latitude.isEmpty || longitude.isEmpty) {
      return ApiResponse.error('Location data is required for clock-in');
    }

    try {
      // Step 1: Check access point requirements
      final accessResponse = await checkAccessPoints();
      if (accessResponse.status != ApiStatus.SUCCESS ||
          accessResponse.response == null) {
        return ApiResponse.error('Failed to check access point settings');
      }

      final accessPoint =
          (accessResponse.response as CheckAccessPointModel).data.first;

      // Step 2: Prepare request with proper URL construction
      final url = Uri.parse(ApiUrls.baseUrl + ApiUrls.postclockin);

      // Step 3: Prepare headers
      final headers = {
        'Authorization': 'Bearer $token',
        'x-organization': organization,
        'Content-Type': 'application/json',
      };

      final Map<String, dynamic> body = {
        'device_id': deviceID,
        'latitude': latitude,
        'longitude': longitude,
      };

      // Step 5: Add IP if required
      if (accessPoint.ipAddress == true) {
        final ipResponse = await getCurrentIpAddress();
        if (ipResponse.status == ApiStatus.SUCCESS &&
            ipResponse.response != null) {
          final ipAddress = ipResponse.response['ip'];
          headers['x-address'] = ipAddress;
        } else {
          return ApiResponse.error(
              'IP address is required but could not be determined');
        }
      }

      // Enhanced logging
      log("🌍 Clock-in Request Details:");
      log("URL: $url");
      log("Headers: $headers");
      log("Body: $body");

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );

      log("🔵 Clock-in Response: ${response.statusCode} - ${response.body}");

      if (response.statusCode == 200) {
        return ApiResponse.completed(jsonDecode(response.body));
      } else if (response.statusCode == 400 &&
          response.body.contains("Feature not enabled")) {
        return ApiResponse.error(
          'Clock-in feature is not enabled by your administrator',
        );
      } else if (response.statusCode == 500) {
        // Provide more detailed error message
        if (response.body.contains("_has_Verified_Geo()")) {
          return ApiResponse.error(
            'Location verification failed. Please ensure your GPS is accurate and you are within the allowed office perimeter.',
          );
        } else {
          return ApiResponse.error(
            'Server error: ${response.body}',
          );
        }
      } else {
        return ApiResponse.error(
          'Failed to clock in: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      log("❌ Clock-in error: $e");
      return ApiResponse.error('Clock-in failed: $e');
    }
  }

  // Post Clock Out with IP
  Future<ApiResponse> postClockout(
      int deviceID, String latitude, String longitude, String ipAddress) async {
    final token = await apiClient.token;
    final organization = await apiClient.organization;

    if (token.isEmpty) {
      throw Exception('JWT token is missing or invalid');
    }

    try {
      // Use consistent base URL
      final url = ApiUrls.baseUrl + ApiUrls.postclockout;
      log("📨 Sending clock-out request to: $url");
      log("📦 Request payload: {device_id: $deviceID, latitude: $latitude, longitude: $longitude, x-address: $ipAddress}");

      // Using direct HTTP request for consistency with clock-in implementation
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'x-organization': organization,
      };

      // FIXED: Send raw location data without reformatting
      final Map<String, dynamic> body = {
        'device_id': deviceID,
        'latitude': latitude,
        'longitude': longitude,
      };

      // Add IP as header
      headers['x-address'] = ipAddress;

      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        return ApiResponse.completed(jsonDecode(response.body));
      } else if (response.statusCode == 400 &&
          response.body.contains("Feature not enabled")) {
        // Special handling for "Feature not enabled" error
        return ApiResponse.error(
            'Clock-out feature is not enabled by your administrator. Please contact support.');
      } else {
        return ApiResponse.error(
            'Failed to clock out: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      return ApiResponse.error('Clock-out failed: $e');
    }
  }
//get breaktime
  Future<ApiResponse> breaktime() async {
    final token = await apiClient.token;
    final organization = await apiClient.organization;

    // Use consistent base URL
    const url = ApiUrls.breaktime;

    if (kDebugMode) {
      print(url);
    }

    final response = await apiClient.getApi(
    
      url,
      token: token,
      apiKey: organization,
      fromJson: (json) => List<BreakTime>.from(
      (json as List).map((x) => BreakTime.fromJson(x)),)
    );
    return response;
  }
  // Post on Break
  Future<ApiResponse> postOnBreak(int employeeId) async {
    final token = await apiClient.token;
    final organization = await apiClient.organization;

    // Use consistent base URL
    const url = ApiUrls.onbreak;

    if (kDebugMode) {
      print(url);
    }

    final response = await apiClient.postApi(
      requestBody: {
        'employee_no': employeeId,
      },
      url,
      token: token,
      apiKey: organization,
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
    final token = await apiClient.token;
    final organization = await apiClient.organization;

    // Use consistent base URL
    const url = ApiUrls.onresume;

    if (kDebugMode) {
      print(url);
    }

    final response = await apiClient.postApi(
      requestBody: {
        'employee_no': employeeId,
        'latitude': latitude,
        'longitude': longitude,
      },
      url,
      token: token,
      apiKey: organization,
      fromJson:  (json) => ResumeResponse.fromJson(json),
    );
    return response;
  }
}
