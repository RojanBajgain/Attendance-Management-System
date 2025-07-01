import 'package:ams/feature/data/datasource/remote/api_client.dart';
import 'package:ams/feature/data/datasource/remote/api_response.dart';
import 'package:ams/feature/data/datasource/remote/api_urls.dart';

class EventCalenderRepo {
  final ApiClient apiClient;

  EventCalenderRepo({required this.apiClient});

  // Get Event Calender
  Future<ApiResponse> getEventCalenders() async {
    final token = await apiClient.token;
    final organization = await apiClient.organization;

    final response = await apiClient.getApi(
      ApiUrls.eventpolicy,
      token: token,
      apiKey: organization,
      fromJson: (json) => json,
    );
    return response;
  }
}
