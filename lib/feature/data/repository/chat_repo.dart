// import 'package:ams/feature/data/datasource/remote/api_client.dart';
// import 'package:ams/feature/data/datasource/remote/api_response.dart';
// import 'package:ams/feature/data/datasource/remote/api_urls.dart';
// import 'package:ams/feature/presentation/pages/chat/model/chat_model.dart';

// class ChatRepo {
//   final ApiClient apiClient;

//   ChatRepo({required this.apiClient});

//   // Get list of all chats/conversations
//   Future<ApiResponse> getChats() async {
//     final token = apiClient.token;

//     final response = await ApiClient.getApi(
//       ApiUrls.chat,
//       token: token,
//       fromJson: (json) => json, // Parse based on your API response structure
//     );
//     return response;
//   }

//   // Get chat history with a specific user
//   Future<ApiResponse> getChatHistory(int userId) async {
//     final token = apiClient.token;

//     final response = await ApiClient.getApi(
//       "${ApiUrls.chat}$userId/",
//       token: token,
//       fromJson: (json) => json, // Parse as List<ChatModel>
//     );
//     return response;
//   }

//   // Send a message via REST API (backup for WebSocket)
//   Future<ApiResponse> sendMessage(Map<String, dynamic> messageData) async {
//     final token = apiClient.token;

//     final response = await ApiClient.postApi(
//       ApiUrls.chat,
//       requestBody: messageData,
//       token: token,
//       fromJson: (json) => ChatModel.fromJson(json),
//     );
//     return response;
//   }

//   // Mark messages as read
//   // Future<ApiResponse> markAsRead(int messageId) async {
//   //   final token = apiClient.token;

//   //   final response = await ApiClient.patchApi(
//   //     "${ApiUrls.chat}$messageId/read/",
//   //     body: {},
//   //     token: token,
//   //     fromJson: (json) => json,
//   //   );
//   //   return response;
//   // }
// }
