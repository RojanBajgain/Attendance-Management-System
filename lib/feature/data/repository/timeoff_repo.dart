import 'dart:developer';

import 'package:ams/feature/data/datasource/remote/api_client.dart';
import 'package:ams/feature/data/datasource/remote/api_response.dart';
import 'package:ams/feature/data/datasource/remote/api_urls.dart';
import 'package:ams/feature/presentation/pages/timeoff/model/timeoff_model.dart';
import 'package:flutter/foundation.dart';

class TimeoffRepo {
  final ApiClient apiClient;

  TimeoffRepo({required this.apiClient});

  // Get timeoffs
  Future<ApiResponse> getTimeoff() async {
    final token = apiClient.token;

    final response = await ApiClient.getApi(
      ApiUrls.timeoff,
      token: token,
      apiKey: apiClient.organization,
      fromJson: (json) => TimeoffModel.fromJson(json),
    );
    return response;
  }

  // Post Timeoff
  Future<ApiResponse> createtimeoff(
    int profile,
    int type,
    String startDate,
    String endDate,
    String reason,
  ) async {
    final token = apiClient.token;
    final orgApiKey = apiClient.organization;

    // Verify all required parameters
    if (profile == null || type == null) {
      throw Exception('Missing required parameters');
    }

    final requestBody = {
      'profile': profile,
      'type': type,
      'start_date': startDate,
      'end_date': endDate,
      'reason': reason,
    };

    log('Timeoff request body: $requestBody');

    final response = await ApiClient.postApi(
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
    final token = apiClient.token;

    if (token.isEmpty) {
      throw Exception('JWT token is missing or invalid');
    }

    final url = '${ApiUrls.reapplytimeoff}$id/update_status/';

    final response = await ApiClient.patchApi(
      url,
      requestBody: {'reason': reason, 'status': 're-apply'},
      token: token,
      fromJson: null,
    );
    return response;
  }
}
