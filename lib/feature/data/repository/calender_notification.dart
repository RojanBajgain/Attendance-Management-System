import 'package:ams/feature/data/datasource/remote/api_client.dart';
import 'package:ams/feature/data/datasource/remote/api_response.dart';
import 'package:ams/feature/data/datasource/remote/api_urls.dart';

class EventCalenderRepo {
  final ApiClient apiClient;

  EventCalenderRepo({required this.apiClient});

  // Get Event Calender
  Future<ApiResponse> getEventCalenders() async {
    final token = apiClient.token;

    final response = await ApiClient.getApi(
      ApiUrls.eventpolicy,
      token: token,
      apiKey: apiClient.organization,
      fromJson: (json) => json,
    );
    return response;
  }
}
