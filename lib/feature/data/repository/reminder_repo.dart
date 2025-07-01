import 'dart:developer';

import 'package:ams/feature/data/datasource/remote/api_client.dart';
import 'package:ams/feature/data/datasource/remote/api_response.dart';
import 'package:ams/feature/data/datasource/remote/api_urls.dart';

class ReminderRepo {
  final ApiClient apiClient;

  ReminderRepo({required this.apiClient});

  Future<ApiResponse> addReminder(
    int profileID,
    String title,
    String remarks,
    String startdate,
    String enddate,
  ) async {
    final token = await apiClient.token;
    final orgApiKey = await apiClient.organization;

    final requestBody = {
      'profile': profileID,
      'title': title,
      'remarks': remarks,
      'start_date': startdate,
      'end_date': enddate,
    };

    log('Reminder request body: $requestBody');

    final response = await apiClient.postApi(
      ApiUrls.addremainder,
      token: token,
      apiKey: orgApiKey,
      requestBody: requestBody,
      fromJson: (json) => json,
    );

    log("Reminder creation response: ${response.response}");
    return response;
  }
}
