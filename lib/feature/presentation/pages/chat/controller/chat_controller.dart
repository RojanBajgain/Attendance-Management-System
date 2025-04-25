// import 'dart:developer';
// import 'package:get/get.dart';
// import 'package:ams/feature/data/datasource/remote/api_response.dart';
// import 'package:ams/feature/data/repository/chat_repo.dart';
// import 'package:ams/feature/presentation/pages/chat/model/chat_model.dart';
// import 'package:ams/feature/presentation/pages/chat/service/websocket_service.dart';

// class ChatController extends GetxController {
//   var chatHistory = <ChatModel>[].obs;
//   var isLoading = false.obs;
//   var errorMessage = ''.obs;
//   var currentConversation = RxInt(-1); // ID of current conversation/receiver

//   final ChatRepo chatRepo;
//   final WebSocketService _websocketService = WebSocketService();

//   ChatController({required this.chatRepo});

//   @override
//   void onInit() {
//     super.onInit();
//     _initWebSocket();
//     getChats();
//   }

//   // Initialize WebSocket connection
//   void _initWebSocket() {
//     final token = chatRepo.apiClient.token;
//     // Get current user ID from your auth service
//     final userId =
//         getUserId(); // Implement this method based on your auth system

//     // Connect to WebSocket
//     _websocketService.connect(token, userId: userId);

//     // Listen for incoming messages
//     _websocketService.messageStream.listen((message) {
//       // Add new message to chat history
//       _handleIncomingMessage(message);
//     });
//   }

//   // Placeholder - implement based on your auth system
//   int getUserId() {
//     // Return the current user ID from your authentication system
//     return 1; // Replace with actual implementation
//   }

//   // Handle incoming WebSocket message
//   void _handleIncomingMessage(ChatModel message) {
//     // If message belongs to current conversation, add to chat history
//     if (message.receiver == currentConversation.value ||
//         message.sender?.id == currentConversation.value) {
//       chatHistory.add(message);
//     }

//     // You might want to update your UI to show notification for new messages
//     // in other conversations as well
//   }

//   // Get chat history with a specific user
//   Future<void> getChatHistory(int userId) async {
//     isLoading(true);
//     currentConversation.value = userId;

//     try {
//       ApiResponse response = await chatRepo.getChatHistory(userId);

//       if (response.status == ApiStatus.SUCCESS && response.response != null) {
//         log("Fetched chat history: ${response.response}");

//         // Assume the API returns a list of ChatModel objects
//         final List<dynamic> chatData = response.response;
//         chatHistory.value =
//             chatData.map((data) => ChatModel.fromJson(data)).toList();
//       } else {
//         errorMessage.value = "Error: ${response.message}";
//       }
//     } catch (e) {
//       errorMessage.value = "An error occurred: $e";
//     } finally {
//       isLoading(false);
//     }
//   }

//   // Get list of all chats/conversations
//   Future<void> getChats() async {
//     isLoading(true);
//     try {
//       ApiResponse response = await chatRepo.getChats();

//       if (response.status == ApiStatus.SUCCESS && response.response != null) {
//         log("Fetched chats list: ${response.response}");

//         // Process response based on your API structure
//       } else {
//         errorMessage.value = "Error: ${response.message}";
//       }
//     } catch (e) {
//       errorMessage.value = "An error occurred: $e";
//     } finally {
//       isLoading(false);
//     }
//   }

//   // Send a message
//   Future<void> sendMessage(String message, int receiverId,
//       {String? mediaUrl}) async {
//     if (message.isEmpty && mediaUrl == null) return;

//     final messageData = {
//       "receiver": receiverId,
//       "message": message,
//       "media_url": mediaUrl
//     };

//     try {
//       // Send via WebSocket
//       _websocketService.sendMessage(messageData);

//       // Optionally, you can also send via REST API as a fallback
//       ApiResponse response = await chatRepo.sendMessage(messageData);

//       if (response.status != ApiStatus.SUCCESS) {
//         errorMessage.value = "Error sending message: ${response.message}";
//       }
//     } catch (e) {
//       errorMessage.value = "Failed to send message: $e";
//     }
//   }

//   @override
//   void onClose() {
//     _websocketService.disconnect();
//     super.onClose();
//   }
// }
