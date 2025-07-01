import 'package:ams/feature/data/datasource/remote/api_client.dart';
import 'package:ams/feature/data/datasource/remote/api_response.dart';
import 'package:ams/feature/data/datasource/remote/api_urls.dart';
import 'package:ams/feature/presentation/pages/notification/model/notification_model.dart';

class NotificationRepo {
  final ApiClient apiClient;

  NotificationRepo({required this.apiClient});

  // Get Notifications
  Future<ApiResponse> getNotification() async {
    final token = await apiClient.token;
    final organization = await apiClient.organization;

    final response = await apiClient.getApi(
      ApiUrls.notification,
      token: token,
      apiKey: organization,
      fromJson: (json) => NotificationModel.fromJson(json),
    );
    return response;
  }
}
