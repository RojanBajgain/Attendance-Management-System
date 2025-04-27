import 'package:ams/feature/data/datasource/remote/api_client.dart';
import 'package:ams/feature/data/datasource/remote/api_response.dart';
import 'package:ams/feature/data/datasource/remote/api_urls.dart';

class EventCalenderRepo {
  final ApiClient apiClient;

  EventCalenderRepo({required this.apiClient});

  // Get Event Calender
  Future<ApiResponse> getEventCalenders() async {
    final token = apiClient.token;

    if (token.isEmpty) {
      throw Exception('JWT Token is missing or invalid');
    }

    final response = await ApiClient.getApi(
      ApiUrls.eventpolicy,
      token: token,
      fromJson: (json) => json,
    );
    return response;
  }
}
