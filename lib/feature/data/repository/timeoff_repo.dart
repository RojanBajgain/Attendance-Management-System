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
      fromJson: (json) => TimeoffModel.fromJson(json),
    );
    return response;
  }

  // Post Timeoff
  Future<ApiResponse> createtimeoff(int userID, int typeID, String startdate,
      String enddate, String reason) async {
    final token = apiClient.token;

    const url = ApiUrls.posttimeoff;
    if (kDebugMode) {
      print(url);
    }

    final response = await ApiClient.postApi(
      requestBody: {
        'user': userID,
        'type': typeID,
        'start_date': startdate,
        'end_date': enddate,
        'reason': reason,
      },
      url,
      token: token,
      fromJson: null,
    );
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
      // Use POST instead of PATCH
      url,
      requestBody: {'reason': reason, 'status': 're-apply'},
      token: token,
      fromJson: null,
    );
    return response;
  }
}
