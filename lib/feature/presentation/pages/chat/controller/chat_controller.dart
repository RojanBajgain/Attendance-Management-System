import 'dart:developer';
import 'dart:io';
import 'package:ams/feature/data/datasource/remote/api_response.dart';
import 'package:ams/feature/data/repository/chat_repo.dart';
import 'package:ams/feature/presentation/pages/chat/model/chat_model.dart';
import 'package:ams/feature/presentation/pages/chat/model/get_chat_by_id.dart';
import 'package:ams/feature/utils/ssnackbar_utils.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  var chats = <ChatModel>[].obs;
  var currentChatMessages = <ChatByIdModel>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var currentChatUserId = 0.obs;
  var currentChatDepartmentId = 0.obs;
  final RxBool isSending = false.obs;

  final ChatRepo chatRepo;

  ChatController({required this.chatRepo});

  @override
  void onInit() {
    super.onInit();
    getAllChats();
  }

  Future<void> getAllChats() async {
    isLoading(true);
    errorMessage('');
    try {
      ApiResponse response = await chatRepo.getChats();

      if (response.status == ApiStatus.SUCCESS && response.response != null) {
        // Parse the response data
        List<dynamic> chatData = response.response;
        chats.value = chatData.map((json) => ChatModel.fromJson(json)).toList();

        // Sort chats by timestamp (most recent first)
        chats.sort((a, b) {
          if (a.timestamp == null && b.timestamp == null) return 0;
          if (a.timestamp == null) return 1;
          if (b.timestamp == null) return -1;
          return b.timestamp!.compareTo(a.timestamp!);
        });
      } else {
        errorMessage.value = response.message ?? 'Failed to fetch chats';
        SSnackbarUtil.showSnackbar(
          'Chat Error',
          errorMessage.value,
          SnackbarType.error,
        );
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
      log('Error in getAllChats: $e');
      SSnackbarUtil.showSnackbar(
        'Chat Error',
        errorMessage.value,
        SnackbarType.error,
      );
    } finally {
      isLoading(false);
    }
  }

  // Get messages for user chat (admin messages)
  Future<void> getChatMessagesForUser(int userId, {int? departmentId}) async {
    isLoading(true);
    errorMessage('');
    currentChatMessages.clear();

    try {
      ApiResponse response;

      if (departmentId != null && departmentId > 0) {
        // Department chat
        response = await chatRepo.getDepartmentMessages(departmentId);
        currentChatDepartmentId.value = departmentId;
        currentChatUserId.value = 0; // No specific user for department chat
      } else {
        // User chat
        response = await chatRepo.getUserMessages(userId);
        currentChatUserId.value = userId;
        currentChatDepartmentId.value = 0; // No department for user chat
      }

      if (response.status == ApiStatus.SUCCESS && response.response != null) {
        // Parse the message data
        List<dynamic> messageData = response.response;
        currentChatMessages.value =
            messageData.map((json) => ChatByIdModel.fromJson(json)).toList();

        // Sort messages by timestamp (newest first for reverse ListView)
        currentChatMessages.sort((a, b) {
          if (a.timestamp == null && b.timestamp == null) return 0;
          if (a.timestamp == null) return 1;
          if (b.timestamp == null) return -1;
          return b.timestamp!.compareTo(a.timestamp!);
        });

        log('Loaded ${currentChatMessages.length} messages');
      } else {
        errorMessage.value = response.message ?? 'Failed to fetch messages';
        SSnackbarUtil.showSnackbar(
          'Chat Error',
          errorMessage.value,
          SnackbarType.error,
        );
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
      log('Error in getChatMessagesForUser: $e');
      SSnackbarUtil.showSnackbar(
        'Chat Error',
        errorMessage.value,
        SnackbarType.error,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> sendMessage({
    required String message,
    int? receiverId,
    int? departmentId,
  }) async {
    try {
      isSending.value = true;

      final response = await chatRepo.sendMessage(
        message: message,
        senderID: receiverId,
        departmentID: departmentId,
      );

      if (response.status == ApiStatus.SUCCESS && response.response != null) {
        // Message sent successfully
        print('Message sent successfully');
      } else {
        // Handle API error
        throw Exception(response.message ?? 'Failed to send message');
      }
    } catch (e) {
      print('Error sending message: $e');
      rethrow; // Re-throw so the UI can handle the error
    } finally {
      isSending.value = false;
    }
  }

  // New method to send message with file
  Future<void> sendMessageWithFile({
    required File file,
    String? message,
    int? receiverId,
    int? departmentId,
  }) async {
    try {
      isSending.value = true;

      final response = await chatRepo.sendMessageWithFile(
        file: file,
        message: message ?? '',
        receiverID: receiverId,
        departmentID: departmentId,
      );

      if (response.status == ApiStatus.SUCCESS && response.response != null) {
        // File sent successfully
        print('File sent successfully');
      } else {
        // Handle API error
        throw Exception(response.message ?? 'Failed to send file');
      }
    } catch (e) {
      print('Error sending file: $e');
      rethrow; // Re-throw so the UI can handle the error
    } finally {
      isSending.value = false;
    }
  }

  // Separate method specifically for department messages
  Future<void> getDepartmentMessages(int departmentId) async {
    await getChatMessagesForUser(0, departmentId: departmentId);
  }

  // Separate method specifically for user messages
  Future<void> getUserMessages(int userId) async {
    await getChatMessagesForUser(userId);
  }

  // Add method to send messages (when you implement WebSocket)
  void addMessageToCurrentChat(ChatByIdModel message) {
    currentChatMessages.insert(0, message);
  }

  // Add method to clear current chat when switching conversations
  void clearCurrentChat() {
    currentChatMessages.clear();
    currentChatUserId.value = 0;
    currentChatDepartmentId.value = 0;
  }

  // Helper method to determine if current chat is a department chat
  bool get isCurrentChatDepartment => currentChatDepartmentId.value > 0;

  // Helper method to determine if current chat is a user chat
  bool get isCurrentChatUser => currentChatUserId.value > 0;

  // Set up WebSocket listener for real-time messages
  /* void _setupWebSocketListener() {
    try {
      final webSocketController = Get.find<WebSocketController>();
      webSocketController.stream?.listen(
        (message) {
          log('WebSocket message received in ChatController: $message');
          try {
            final data = message is String ? jsonDecode(message) : message;
            if (data is Map<String, dynamic>) {
              final newChat = ChatByIdModel.fromJson(data);
              addMessageToCurrentChat(newChat);
              SSnackbarUtil.showSnackbar(
                'New Message',
                newChat.message ?? 'New message received',
                SnackbarType.info,
              );
            }
          } catch (e) {
            log('Error parsing WebSocket message: $e');
          }
        },
        onError: (error) {
          log('WebSocket error: $error');
        },
        onDone: () {
          log('WebSocket closed');
        },
      );
    } catch (e) {
      log('Error setting up WebSocket listener: $e');
    }
  } */

  // Send a message via WebSocket
  /* void sendMessage(
    String messageText, {
    int? receiverId,
    String? receiverName,
    int? departmentId,
    String? departmentName,
  }) {
    try {
      final webSocketController = Get.find<WebSocketController>();
      final authController = Get.find<AuthController>();
      final userId = authController.alluserData.value.user ?? 0;

      final chatMessage = ChatByIdModel(
        id: 0, // Temporary ID, server will assign actual ID
        sender: Receiver(
          id: userId,
          user: 'Current User', // Replace with actual user name from AuthController
          isActive: true,
        ),
        receiver: receiverId != null
            ? Receiver(id: receiverId, user: receiverName ?? 'Unknown', isActive: true)
            : null,
        department: departmentId,
        message: messageText,
        timestamp: DateTime.now(),
        hasRead: false,
      );

      // webSocketController.sendWebSocketMessage(chatMessageToJson(chatMessage));
      
      // Add to local state optimistically
      addMessageToCurrentChat(chatMessage);
    } catch (e) {
      log('Error sending WebSocket message: $e');
      SSnackbarUtil.showSnackbar(
        'Chat Error',
        'Failed to send message: $e',
        SnackbarType.error,
      );
    }
  } */
}
