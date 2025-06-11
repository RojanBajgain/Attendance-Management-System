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
    int? receiverId,
    int? senderId,
    int? userId,
    int? departmentId,
  }) async {
    final token = apiClient.token;

    // Build query parameters based on the type of chat
    String queryString = '';

    if (departmentId != null && departmentId > 0) {
      // Department chat: user= (empty) and department=ID
      queryString = '?user=&department=$departmentId';
    } else if (userId != null && userId > 1) {
      // Admin/User chat: user=ID and department= (empty)
      queryString = '?user=$userId&department=';
    } else {
      // Default case - this shouldn't happen but handle it
      queryString = '?user=&department=';
    }

    String url = '${ApiUrls.chat}$queryString';

    final response = await ApiClient.getApi(
      url,
      token: token,
      apiKey: apiClient.organization,
      fromJson: (json) => json,
    );
    return response;
  }

  // Get department messages specifically
  Future<ApiResponse> getDepartmentMessages(int departmentId) async {
    final token = apiClient.token;
    String url = '${ApiUrls.chat}?user=&department=$departmentId';

    final response = await ApiClient.getApi(
      url,
      token: token,
      apiKey: apiClient.organization,
      fromJson: (json) => json,
    );
    return response;
  }

  // Get admin/user messages specifically
  Future<ApiResponse> getUserMessages(int userId) async {
    final token = apiClient.token;
    String url = '${ApiUrls.chat}?user=$userId&department=';

    final response = await ApiClient.getApi(
      url,
      token: token,
      apiKey: apiClient.organization,
      fromJson: (json) => json,
    );
    return response;
  }

  // Send a message (if you have an endpoint for this)
  Future<ApiResponse> sendMessage({
    required String message,
    int? senderID,
    int? departmentID,
    String? mediaUrl,
  }) async {
    final token = apiClient.token;

    // final body = <String, dynamic>{
    //   'message': message,
    //   if (senderID != null) 'receiver': senderID,
    //   if (departmentID != null) 'department': departmentID,
    //   if (mediaUrl != null) 'media_url': mediaUrl,
    // };

    final response = await ApiClient.postApi(
      ApiUrls.chat,
      // body: body,
      requestBody: {
        'message': message,
        if (senderID != null) 'receiver': senderID,
        if (departmentID != null) 'department': departmentID,
        // if (mediaUrl != null) 'media_url': mediaUrl,
      },
      token: token,
      apiKey: apiClient.organization,
      fromJson: (json) => json,
    );
    return response;
  }
}
