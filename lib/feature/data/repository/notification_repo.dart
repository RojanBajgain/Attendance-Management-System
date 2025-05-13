import 'package:ams/feature/data/datasource/remote/api_client.dart';
import 'package:ams/feature/data/datasource/remote/api_response.dart';
import 'package:ams/feature/data/datasource/remote/api_urls.dart';
import 'package:ams/feature/presentation/pages/notification/model/notification_model.dart';

class NotificationRepo {
  final ApiClient apiClient;

  NotificationRepo({required this.apiClient});

  // Get Notifications
  Future<ApiResponse> getNotification() async {
    final token = apiClient.token;

    // if (token.isEmpty) {
    //   throw Exception('JWT Token is missing or invalid');
    // }

    final response = await ApiClient.getApi(
      ApiUrls.notification,
      token: token,
      fromJson: (json) => NotificationModel.fromJson(json),
    );
    return response;
  }
}
