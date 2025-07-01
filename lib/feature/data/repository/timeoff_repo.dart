import 'dart:developer';

import 'package:ams/feature/data/datasource/remote/api_client.dart';
import 'package:ams/feature/data/datasource/remote/api_response.dart';
import 'package:ams/feature/data/datasource/remote/api_urls.dart';
import 'package:ams/feature/presentation/pages/timeoff/model/timeoff_model.dart';

class TimeoffRepo {
  final ApiClient apiClient;

  TimeoffRepo({required this.apiClient});

  // Get timeoffs
  Future<ApiResponse> getTimeoff() async {
    final token = await apiClient.token;
    final organization = await apiClient.organization;

    final response = await apiClient.getApi(
      ApiUrls.timeoff,
      token: token,
      apiKey: organization,
      fromJson: (json) => TimeoffModel.fromJson(json),
    );
    return response;
  }

  // Get Leave Policy
  Future<ApiResponse> getUserLeaveByPolicy() async {
    final token = await apiClient.token;
    final organization = await apiClient.organization;

    final response = await apiClient.getApi(
      ApiUrls.leavepolicy,
      token: token,
      apiKey: organization,
      fromJson: (json) => json,
    );
    return response;
  }

  // Post Timeoff
  Future<ApiResponse> createtimeoff(
    int profileID,
    int type,
    String startDate,
    String endDate,
    String reason,
  ) async {
    final token = await apiClient.token;
    final orgApiKey = await apiClient.organization;

    final requestBody = {
      'profile': profileID,
      'type': type,
      'start_date': startDate,
      'end_date': endDate,
      'reason': reason,
    };

    log('Timeoff request body: $requestBody');

    final response = await apiClient.postApi(
      ApiUrls.posttimeoff,
      token: token,
      apiKey: orgApiKey,
      requestBody: requestBody,
      fromJson: (json) => json,
    );

    log("Timeoff creation response: ${response.response}");
    return response;
  }

  // Patch timeoff
  Future<ApiResponse> postReapply(int id, String reason) async {
    final token = await apiClient.token;
    final organization = await apiClient.organization;

    // if (token.isEmpty) {
    //   throw Exception('JWT token is missing or invalid');
    // }

    final url = '${ApiUrls.reapplytimeoff}$id/update_status/';

    final response = await apiClient.patchApi(
      url,
      requestBody: {'reason': reason, 'status': 're-apply'},
      token: token,
      apiKey: organization,
      fromJson: null,
    );
    return response;
  }

  Future<ApiResponse> deleteTimeoff(int id) async {
    final token = await apiClient.token;
    final organization = await apiClient.organization;

    // if (token.isEmpty) {
    //   throw Exception('JWT token is missing or invalid');
    // }

    final url = '${ApiUrls.timeoff}$id/';

    final response = await apiClient.deleteApi(
      url,
      token: token,
      apiKey: organization,
      fromJson: null,
    );

    return response;
  }
}
