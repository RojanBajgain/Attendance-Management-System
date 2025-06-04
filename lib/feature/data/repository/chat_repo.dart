import 'package:ams/feature/data/datasource/remote/api_client.dart';
import 'package:ams/feature/data/datasource/remote/api_response.dart';
import 'package:ams/feature/data/datasource/remote/api_urls.dart';

class ChatRepo {
  final ApiClient apiClient;

  ChatRepo({required this.apiClient});

  // Get list of all chats/conversations
  Future<ApiResponse> getChats() async {
    final token = apiClient.token;

    final response = await ApiClient.getApi(
      ApiUrls.chat,
      token: token,
      apiKey: apiClient.organization,
      fromJson: (json) => json,
    );
    return response;
  }

  // Get messages for a specific user or department
  Future<ApiResponse> getChatMessages({
    required int userId,
    int? departmentId,
  }) async {
    final token = apiClient.token;
    final queryParams = <String, String>{
      'user': userId.toString(),
    };
    if (departmentId != null) {
      queryParams['department'] = departmentId.toString();
    }

    final response = await ApiClient.getApi(
      ApiUrls.chat,
      token: token,
      apiKey: apiClient.organization,
      // queryParameters: queryParams,
      fromJson: (json) => json,
    );
    return response;
  }
}
