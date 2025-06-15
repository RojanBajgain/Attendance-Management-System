import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:ams/feature/data/datasource/remote/api_response.dart';
import 'package:ams/feature/data/repository/chat_repo.dart';
import 'package:ams/feature/presentation/pages/chat/model/chat_model.dart';
import 'package:ams/feature/presentation/pages/chat/model/get_chat_by_id.dart';
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

      if (token.isEmpty || organization.isEmpty) {
        log('Token or organization not available');
        return;
      }

      await _webSocketService.connect(
        token: token,
        organization: organization,
      );

      // Set up WebSocket message listener
      _webSocketService.stream?.listen(
        (message) {
          log('WebSocket message received: $message');
          _handleWebSocketMessage(message);
        },
        onError: (error) {
          log('WebSocket error: $error');
          isWebSocketConnected.value = false;
        },
        onDone: () {
          log('WebSocket connection closed');
          isWebSocketConnected.value = false;
        },
      );

      // Set up reactive connection status tracking
      ever(_webSocketService.isConnected, (connected) {
        isWebSocketConnected.value = connected;
        log('WebSocket connection status changed: $connected');
      });

      // Initial connection status
      isWebSocketConnected.value = _webSocketService.isConnected.value;
    } catch (e) {
      log('WebSocket init error: $e');
      isWebSocketConnected.value = false;
    }
  }

  // Handle incoming WebSocket messages
  void _handleWebSocketMessage(dynamic message) {
    try {
      Map<String, dynamic> data;

      if (message is String) {
        data = jsonDecode(message);
      } else if (message is Map<String, dynamic>) {
        data = message;
      } else {
        log('Unknown message format: $message');
        return;
      }

      log('Parsed WebSocket message: $data');

      // Handle different message types based on your WebSocket structure
      if (data.containsKey('type')) {
        switch (data['type']) {
          case 'chat_message':
            _handleNewChatMessage(data);
            break;
          case 'auth_success':
            log('WebSocket authentication successful');
            isWebSocketConnected.value = true;
            break;
          case 'auth_error':
            log('WebSocket authentication failed');
            isWebSocketConnected.value = false;
            break;
          default:
            log('Unknown WebSocket message type: ${data['type']}');
        }
      } else {
        // Handle direct message format (like in your log)
        // This handles the format: {"id": 8, "receiver": {...}, "sender": {...}, "message": "hello"}
        if (data.containsKey('id') && data.containsKey('message')) {
          _handleDirectMessage(data);
        }
      }
    } catch (e) {
      log('Error parsing WebSocket message: $e');
    }
  }

  // Handle direct message format (from your WebSocket log)
  void _handleDirectMessage(Map<String, dynamic> data) {
    try {
      log('Processing direct message: $data');

      // Convert the message to ChatByIdModel format
      final newMessage = ChatByIdModel(
        id: data['id'],
        message: data['message'],
        timestamp: DateTime.now(),
        sender: data['sender'] != null
            ? Receiver(
                id: data['sender']['id'],
                user: data['sender']['user'],
                isActive: data['sender']['is_active'],
                profileImage: data['sender']['profile_image'],
              )
            : null,
        receiver: data['receiver'] != null
            ? Receiver(
                id: data['receiver']['id'],
                user: data['receiver']['user'],
                isActive: data['receiver']['is_active'],
                profileImage: data['receiver']['profile_image'],
              )
            : null,
        department: data['department'],
        document: data['document'],
      );

      // Check if this message belongs to current chat
      final isForCurrentUserChat = _isMessageForCurrentUserChat(newMessage);
      final isForCurrentDepartmentChat =
          _isMessageForCurrentDepartmentChat(newMessage);

      log('Message for current user chat: $isForCurrentUserChat');
      log('Message for current department chat: $isForCurrentDepartmentChat');

      if (isForCurrentUserChat || isForCurrentDepartmentChat) {
        // Check if message already exists to avoid duplicates
        final existingMessageIndex = currentChatMessages.indexWhere(
          (msg) => msg.id == newMessage.id,
        );

        if (existingMessageIndex == -1) {
          // Add new message only if it doesn't exist
          currentChatMessages.insert(0, newMessage);
          log('Added new message to current chat. Total messages: ${currentChatMessages.length}');
        } else {
          // Update existing message (in case it was a temporary one)
          currentChatMessages[existingMessageIndex] = newMessage;
          log('Updated existing message in current chat');
        }

        // Force UI update
        currentChatMessages.refresh();

        // Update chat list
        _updateChatsList(newMessage);
      } else {
        log('Message not for current chat, just updating chats list');
        _updateChatsList(newMessage);
      }
    } catch (e) {
      log('Error handling direct message: $e');
    }
  }

  void replaceTemporaryMessage(int tempId, ChatByIdModel realMessage) {
    final tempIndex = currentChatMessages.indexWhere((msg) => msg.id == tempId);
    if (tempIndex != -1) {
      currentChatMessages[tempIndex] = realMessage;
      currentChatMessages.refresh();
    }
  }

  void _updateChatsList(ChatByIdModel newMessage) {
    final chatIndex = chats.indexWhere((chat) {
      if (newMessage.department != null) {
        return chat.department?.id == newMessage.department;
      } else {
        return chat.sender?.id == newMessage.sender?.id ||
            chat.receiver?.id == newMessage.sender?.id;
      }
    });

    if (chatIndex != -1) {
      final updatedChat = chats[chatIndex].copyWith(
        message: newMessage.message,
        timestamp: newMessage.timestamp,
      );
      chats[chatIndex] = updatedChat;
      chats.refresh();
    }
  }

  // Handle new chat message from WebSocket (structured format)
  void _handleNewChatMessage(Map<String, dynamic> data) {
    try {
      // Expecting structure: {"type": "chat_message", "message": {...}}
      if (!data.containsKey('message')) {
        log('Chat message data missing message field');
        return;
      }

      final messageData = data['message'];
      final newMessage = ChatByIdModel.fromJson(messageData);

      // Check if this message belongs to current chat
      final isForCurrentUserChat = _isMessageForCurrentUserChat(newMessage);
      final isForCurrentDepartmentChat =
          _isMessageForCurrentDepartmentChat(newMessage);

      if (isForCurrentUserChat || isForCurrentDepartmentChat) {
        // Add to current chat messages
        currentChatMessages.insert(0, newMessage);
        // Force UI update
        currentChatMessages.refresh();
      }

      // Refresh chat list to update last message
      getAllChats();
    } catch (e) {
      log('Error handling new chat message: $e');
    }
  }

  // Helper methods to check if message is for current chat
  bool _isMessageForCurrentUserChat(ChatByIdModel message) {
    if (currentChatUserId.value <= 0) return false;

    return (message.sender?.id == currentChatUserId.value ||
        message.receiver?.id == currentChatUserId.value);
  }

  bool _isMessageForCurrentDepartmentChat(ChatByIdModel message) {
    if (currentChatDepartmentId.value <= 0) return false;

    return message.department == currentChatDepartmentId.value;
  }

  // Reconnect WebSocket if needed
  Future<void> reconnectWebSocket() async {
    if (!_webSocketService.isConnected.value) {
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
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
      log('Error in getAllChats: $e');
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
        log('Loading department chat for department ID: $departmentId');
      } else {
        // User chat
        response = await chatRepo.getUserMessages(userId);
        currentChatUserId.value = userId;
        currentChatDepartmentId.value = 0; // No department for user chat
        log('Loading user chat for user ID: $userId');
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
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
      log('Error in getChatMessagesForUser: $e');
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
      if (_webSocketService.isConnected.value) {
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
        // Message sent successfully - don't reload, let WebSocket handle updates
        log('Message sent successfully');

        // Optionally update the temporary message with server response
        if (response.response is Map<String, dynamic>) {
          final serverMessage = ChatByIdModel.fromJson(response.response);
          // You could replace the temporary message here if needed
        }
      } else {
        // Handle API error
        throw Exception(response.message ?? 'Failed to send message');
      }
    } catch (e) {
      log('Error sending message: $e');
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
        // File sent successfully - don't reload, let WebSocket handle updates
        log('File sent successfully');

        // Update temporary message with real server URL if available
        if (response.response is Map<String, dynamic>) {
          final serverMessage = ChatByIdModel.fromJson(response.response);
          // Replace the temporary message with local file path with server URL
          final tempIndex = currentChatMessages.indexWhere(
            (msg) => msg.document?.startsWith('/') == true, // Local file path
          );
          if (tempIndex != -1) {
            currentChatMessages[tempIndex] = serverMessage;
            currentChatMessages.refresh();
          }
        }
      } else {
        // Handle API error
        throw Exception(response.message ?? 'Failed to send file');
      }
    } catch (e) {
      log('Error sending file: $e');
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
    currentChatMessages.refresh();
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
