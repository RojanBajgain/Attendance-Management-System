// import 'dart:convert';
// import 'dart:developer';
// import 'package:ams/feature/data/datasource/remote/api_response.dart';
// import 'package:ams/feature/data/repository/chat_repo.dart';
// import 'package:ams/feature/presentation/pages/chat/model/get_chat_by_id.dart';
// import 'package:ams/feature/presentation/pages/login/controller/login_controller.dart';
// import 'package:ams/feature/presentation/pages/websocket/controller/websocket_controller.dart';
// import 'package:ams/feature/utils/ssnackbar_utils.dart';
// import 'package:get/get.dart';

// class ChatController extends GetxController {
//   var chatHistory = <ChatByIdModel>[].obs;
//   var isLoading = false.obs;
//   var errorMessage = ''.obs;

//   final ChatRepo chatRepo;

//   ChatController({required this.chatRepo});

//   @override
//   void onInit() {
//     super.onInit();
//     getChats();
//     _setupWebSocketListener();
//   }

//   Future<void> getChats() async {
//     isLoading(true);
//     try {
//       ApiResponse response = await chatRepo.getChats();

//       if (response.status == ApiStatus.SUCCESS && response.response != null) {
//         log('Fetched chats list: ${response.response}');
//         chatHistory.value =
//             chatByIdModelFromRawJson(jsonEncode(response.response));
//       } else {
//         errorMessage.value = response.message ?? 'Failed to fetch chats';
//         SSnackbarUtil.showSnackbar(
//           'Chat Error',
//           errorMessage.value,
//           SnackbarType.error,
//         );
//       }
//     } catch (e) {
//       errorMessage.value = 'An error occurred: $e';
//       SSnackbarUtil.showSnackbar(
//         'Chat Error',
//         errorMessage.value,
//         SnackbarType.error,
//       );
//     } finally {
//       isLoading(false);
//     }
//   }

//   // Fetch messages for a specific user or department
//   Future<void> getChatMessages({
//     required int userId,
//     int? departmentId,
//   }) async {
//     isLoading(true);
//     try {
//       List<ChatByIdModel> allMessages = [];
//       int page = 1;
//       bool hasMore = true;

//       while (hasMore) {
//         ApiResponse response = await chatRepo.getChatMessages(
//           userId: userId,
//           departmentId: departmentId,
//         );

//         if (response.status == ApiStatus.SUCCESS && response.response != null) {
//           log('Fetched chat messages page $page: ${response.response}');
//           final messages =
//               chatByIdModelFromRawJson(jsonEncode(response.response));
//           allMessages.addAll(messages);
//           hasMore = response.response.length >= 10;
//           page++;
//         } else {
//           errorMessage.value =
//               response.message ?? 'Failed to fetch chat messages';
//           SSnackbarUtil.showSnackbar(
//             'Chat Error',
//             errorMessage.value,
//             SnackbarType.error,
//           );
//           break;
//         }
//       }
//       chatHistory.value = allMessages;
//       errorMessage.value = '';
//       chatHistory.refresh();
//     } catch (e) {
//       log('Error in getChatMessages: $e');
//       SSnackbarUtil.showSnackbar(
//         'Chat Error',
//         errorMessage.value,
//         SnackbarType.error,
//       );
//     } finally {
//       isLoading(false);
//     }
//   }

//   // Set up WebSocket listener for real-time messages
//   void _setupWebSocketListener() {
//     try {
//       final webSocketController = Get.find<WebSocketController>();
//       webSocketController.stream?.listen(
//         (message) {
//           log('WebSocket message received in ChatController: $message');
//           try {
//             final data = message is String ? jsonDecode(message) : message;
//             if (data is Map<String, dynamic>) {
//               final newChat = ChatByIdModel.fromJson(data);
//               chatHistory.insert(0, newChat);
//               SSnackbarUtil.showSnackbar(
//                 'New Message',
//                 newChat.message ?? 'Media received',
//                 SnackbarType.info,
//               );
//             }
//           } catch (e) {
//             log('Error parsing WebSocket message: $e');
//           }
//         },
//         onError: (error) {
//           log('WebSocket error: $error');
//         },
//         onDone: () {
//           log('WebSocket closed');
//         },
//       );
//     } catch (e) {
//       log('Error setting up WebSocket listener: $e');
//     }
//   }

//   // Send a message via WebSocket
//   void sendMessage(
//     String message, {
//     int? receiverId,
//     String? receiverName,
//     int? departmentId,
//     String? departmentName,
//   }) {
//     try {
//       final webSocketController = Get.find<WebSocketController>();
//       final authController = Get.find<AuthController>();
//       final userId = authController.alluserData.value.user ?? 0;

//       final chatMessage = ChatByIdModel(
//         id: 0, // Temporary ID, server will assign actual ID
//         sender: Receiver(
//           id: userId,
//           user:
//               'Current User', // Replace with actual user name from AuthController
//           isActive: true,
//         ),
//         receiver: receiverId != null
//             ? Receiver(id: receiverId, user: receiverName, isActive: true)
//             : null,
//         department: departmentId != null
//             ? {'id': departmentId, 'name': departmentName}
//             : null,
//         message: message,
//         timestamp: DateTime.now(),
//         hasRead: false,
//       );

//       // webSocketController.sendWebSocketMessage(chatMessage.toRawJson());
//     } catch (e) {
//       log('Error sending WebSocket message: $e');
//       SSnackbarUtil.showSnackbar(
//         'Chat Error',
//         'Failed to send message: $e',
//         SnackbarType.error,
//       );
//     }
//   }
// }
