import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:ams/feature/data/datasource/remote/api_response.dart';
import 'package:ams/feature/data/repository/chat_repo.dart';
import 'package:ams/feature/presentation/pages/chat/model/chat_model.dart';
import 'package:ams/feature/presentation/pages/chat/model/get_chat_by_id.dart';
import 'package:ams/feature/utils/ssnackbar_utils.dart';
import 'package:get/get.dart';

import '../service/websocket_service.dart';

class ChatController extends GetxController {
  var chats = <ChatModel>[].obs;
  var currentChatMessages = <ChatByIdModel>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var currentChatUserId = 0.obs;
  var currentChatDepartmentId = 0.obs;
  final RxBool isSending = false.obs;
  final RxBool isWebSocketConnected = false.obs;

  final ChatRepo chatRepo;
  final WebSocketService _webSocketService = WebSocketService();

  ChatController({required this.chatRepo});

  @override
  void onInit() {
    super.onInit();
    getAllChats();
    _initializeWebSocket();
  }

  @override
  void onClose() {
    _webSocketService.disconnect();
    super.onClose();
  }

  // Initialize WebSocket connection
  Future<void> _initializeWebSocket() async {
    try {
      final token = chatRepo.apiClient.token;
      final organization = chatRepo.apiClient.organization;

      await _webSocketService.connect(
        token: token,
        organization: organization,
      );

      isWebSocketConnected.value = _webSocketService.isConnected;

      // Listen to WebSocket messages
      _webSocketService.stream?.listen(
        (message) {
          _handleWebSocketMessage(message);
        },
        onError: (error) {
          log('WebSocket stream error: $error');
          isWebSocketConnected.value = false;
        },
        onDone: () {
          log('WebSocket stream closed');
          isWebSocketConnected.value = false;
        },
      );
    } catch (e) {
      log('Failed to initialize WebSocket: $e');
      isWebSocketConnected.value = false;
    }
  }

  // Handle incoming WebSocket messages
  void _handleWebSocketMessage(dynamic message) {
    try {
      final data = message is String ? jsonDecode(message) : message;

      if (data is Map<String, dynamic>) {
        log('Received WebSocket message: $data');

        // Handle different message types
        switch (data['type']) {
          case 'chat_message':
            _handleNewChatMessage(data);
            break;
          case 'auth_success':
            log('WebSocket authentication successful');
            break;
          case 'auth_error':
            log('WebSocket authentication failed');
            break;
          default:
            log('Unknown WebSocket message type: ${data['type']}');
        }
      }
    } catch (e) {
      log('Error parsing WebSocket message: $e');
    }
  }

  // Handle new chat message from WebSocket
  void _handleNewChatMessage(Map<String, dynamic> data) {
    try {
      final newMessage = ChatByIdModel.fromJson(data['message']);

      // Check if this message belongs to current chat
      final isForCurrentUserChat = currentChatUserId.value > 0 &&
          (newMessage.sender?.id == currentChatUserId.value ||
              newMessage.receiver?.id == currentChatUserId.value);

      final isForCurrentDepartmentChat = currentChatDepartmentId.value > 0 &&
          newMessage.department == currentChatDepartmentId.value;

      if (isForCurrentUserChat || isForCurrentDepartmentChat) {
        // Add to current chat messages
        currentChatMessages.insert(0, newMessage);

        // Show notification
        SSnackbarUtil.showSnackbar(
          'New Message',
          newMessage.message ?? 'New message received',
          SnackbarType.info,
        );
      }

      // Refresh chat list to update last message
      getAllChats();
    } catch (e) {
      log('Error handling new chat message: $e');
    }
  }

  // Reconnect WebSocket if needed
  Future<void> reconnectWebSocket() async {
    if (!_webSocketService.isConnected) {
      await _initializeWebSocket();
    }
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

      // Send via WebSocket if connected
      if (_webSocketService.isConnected) {
        _webSocketService.sendMessage({
          'message': message,
          'receiver_id': receiverId,
          'department_id': departmentId,
        });
      }

      // Also send via HTTP API as fallback
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
}
