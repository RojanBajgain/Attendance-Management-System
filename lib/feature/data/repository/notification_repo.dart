import 'package:ams/feature/data/datasource/remote/api_client.dart';
import 'package:ams/feature/data/datasource/remote/api_response.dart';
import 'package:ams/feature/data/datasource/remote/api_urls.dart';
import 'package:ams/feature/presentation/pages/notification/model/notification_model.dart';

class NotificationRepo {
  final ApiClient apiClient;

  NotificationRepo({required this.apiClient});

  // Get Notifications
  Future<ApiResponse> getNotification({int page = 1, int limit = 10}) async {
    final token = await apiClient.token;
    final organization = await apiClient.organization;

    final response = await apiClient.getApi(
      '${ApiUrls.notification}?page=$page&limit=$limit',
      token: token,
      apiKey: organization,
      fromJson: (json) => NotificationModel.fromJson(json),
    );
    return response;
  }

  Future<ApiResponse> deleteNotification(int id) async {
    final token = await apiClient.token;
    final organization = await apiClient.organization;

    final response = await apiClient.deleteApi('${ApiUrls.notification}$id/',
        token: token, apiKey: organization, fromJson: null);
    return response;
  }
   Future<ApiResponse> readNotification() async {
    final token = await apiClient.token;
    final organization = await apiClient.organization;

    final response = await apiClient.postApi('${ApiUrls.notification}mark-unread/',
    requestBody: null,
        token: token, apiKey: organization, fromJson: null);
    return response;
  }


  // Future<ApiResponse> readNotification(int id, String title) async {
  //   final token = await apiClient.token;
  //   final organization = await apiClient.organization;

  //   final response = await apiClient.putApi('${ApiUrls.notification}$id/',
  //       requestBody: {'id': id,'title':title}, token: token, apiKey: organization, fromJson: null);
  //   return response;
  // }
}
