import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:ams/feature/data/datasource/remote/api_response.dart';
import 'package:ams/feature/data/repository/chat_repo.dart';
import 'package:ams/feature/presentation/pages/chat/model/chat_model.dart';
import 'package:ams/feature/presentation/pages/profile/controller/profile_controller.dart';
import 'package:get/get.dart';

import '../service/websocket_service.dart';

class ChatController extends GetxController {
  var chats = <ChatModel>[].obs;
  var currentChatMessages = <ChatModel>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var currentChatUserId = 0.obs;
  var currentChatDepartmentId = 0.obs;
  final RxBool isSending = false.obs;
  final RxBool isWebSocketConnected = false.obs;

  final ProfileController profilecontroller = Get.find<ProfileController>();

  final ChatRepo chatRepo;
  final WebSocketService _webSocketService = WebSocketService();

  ChatController({required this.chatRepo});

  @override
  void onInit() {
    super.onInit();
    // getAllChats();
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
      final token = await chatRepo.apiClient.token;
      final organization = await chatRepo.apiClient.organization;

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
        if (data.containsKey('id') && data.containsKey('message')) {
          _handleDirectMessage(data);
        }
      }
    } catch (e) {
      log('Error parsing WebSocket message: $e');
    }
  }

  // Add this new helper method
  void _addMessageToCurrentChat(ChatModel message) {
    try {
      log('➕ Adding message to current chat: ${message.id}');

      // Check if message already exists
      final existingIndex =
          currentChatMessages.indexWhere((m) => m.id == message.id);

      if (existingIndex == -1) {
        // New message - add to beginning
        currentChatMessages.insert(0, message);
        log('   - Added new message');
      } else {
        // Existing message - update it
        currentChatMessages[existingIndex] = message;
        log('   - Updated existing message');
      }

      // Sort by timestamp (newest first)
      currentChatMessages.sort((a, b) => b.timestamp!.compareTo(a.timestamp!));
      currentChatMessages.refresh();
    } catch (e) {
      log('Error adding message to current chat: $e');
    }
  }

  // Then update your _handleDirectMessage to use this method:
  void _handleDirectMessage(Map<String, dynamic> data) {
    try {
      log('🔍 DEBUGGING MESSAGE MATCHING:');
      log('📱 Current state: userId=${currentChatUserId.value}, deptId=${currentChatDepartmentId.value}');

      final newMessage = ChatModel.fromJson(data);

      // Enhanced logging
      log('📨 Message details:');
      log('   - Message ID: ${newMessage.id}');
      log('   - Sender: ${newMessage.sender?.user} (${newMessage.sender?.id})');
      log('   - Receiver: ${newMessage.receiver?.user} (${newMessage.receiver?.id})');
      log('   - Department: ${newMessage.department?.name} (${newMessage.department?.id})');
      log('   - Message: "${newMessage.message}"');

      // Determine message type and if it belongs to current chat
      bool isForCurrentChat = false;

      // Check for department message first
      if (newMessage.department != null) {
        log('🏢 Department message detected');
        isForCurrentChat =
            currentChatDepartmentId.value == newMessage.department!.id;
      }
      // Check for user message
      else if (newMessage.receiver != null) {
        log('👤 User message detected');
        isForCurrentChat = _isMessageForCurrentUserChat(newMessage);
      }
      // Handle potential department message without department field (workaround)
      else if (currentChatDepartmentId.value > 0) {
        log('⚠️ Potential department message without department field');
        isForCurrentChat = true; // Assuming it's for current department
      }

      log('🎯 Message belongs to current chat: $isForCurrentChat');

      if (isForCurrentChat) {
        log('✅ ADDING MESSAGE TO CURRENT CHAT!');
        _addMessageToCurrentChat(newMessage);
      } else {
        log('❌ Message not for current chat - updating list only');
      }

      _updateChatsList(newMessage);
    } catch (e, stackTrace) {
      log('💥 Error in _handleDirectMessage: $e\n$stackTrace');
    }
  }

  void replaceTemporaryMessage(int tempId, ChatModel realMessage) {
    final tempIndex = currentChatMessages.indexWhere((msg) => msg.id == tempId);
    if (tempIndex != -1) {
      currentChatMessages[tempIndex] = realMessage;
      currentChatMessages.refresh();
    }
  }

  void _updateChatsList(ChatModel newMessage) {
    try {
      log('🔄 Updating chats list');

      final chatIndex = chats.indexWhere((chat) {
        // For department messages
        if (newMessage.department != null) {
          return chat.department?.id == newMessage.department?.id;
        }
        // For user messages
        else if (newMessage.receiver != null) {
          final currentUserId = profilecontroller.profile.value!.id;
          return (chat.sender?.id == newMessage.sender?.id &&
                  chat.receiver?.id == currentUserId) ||
              (chat.sender?.id == currentUserId &&
                  chat.receiver?.id == newMessage.sender?.id);
        }
        // For potential department messages without department field
        else {
          return chat.department?.id == currentChatDepartmentId.value;
        }
      });

      if (chatIndex != -1) {
        log('   - Updating existing chat at index $chatIndex');
        final updatedChat = chats[chatIndex].copyWith(
          message: newMessage.message,
          timestamp: newMessage.timestamp,
          hasRead: newMessage.hasRead,
        );
        chats[chatIndex] = updatedChat;
      } else {
        log('   - Adding new chat to list');
        chats.insert(0, newMessage);
      }

      // Sort by timestamp (newest first)
      chats.sort((a, b) => b.timestamp!.compareTo(a.timestamp!));
      chats.refresh();
    } catch (e) {
      log('Error updating chats list: $e');
    }
  }

  // Handle new chat message from WebSocket (structured format)
  void _handleNewChatMessage(Map<String, dynamic> data) {
    try {
      if (!data.containsKey('message')) {
        log('Chat message data missing message field');
        return;
      }

      final messageData = data['message'];
      final newMessage = ChatModel.fromJson(messageData);

      // Check if this message belongs to current chat
      final isForCurrentUserChat = _isMessageForCurrentUserChat(newMessage);
      final isForCurrentDepartmentChat =
          _isMessageForCurrentDepartmentChat(newMessage);

      if (isForCurrentUserChat || isForCurrentDepartmentChat) {
        currentChatMessages.insert(0, newMessage);

        // Force UI update
        currentChatMessages.refresh();
      }

      getAllChats();
    } catch (e) {
      log('Error handling new chat message: $e');
    }
  }

  bool _isMessageForCurrentUserChat(ChatModel message) {
    if (currentChatUserId.value <= 0) {
      log('🔍 No current user chat active');
      return false;
    }

    final currentUserId = profilecontroller.profile.value!.id;
    final isFromCurrentUser = message.sender?.id == currentUserId;
    final isToCurrentUser = message.receiver?.id == currentUserId;
    final isFromCurrentChatUser = message.sender?.id == currentChatUserId.value;
    final isToCurrentChatUser = message.receiver?.id == currentChatUserId.value;

    // Message is between current user and current chat user
    final isMatch = (isFromCurrentUser && isToCurrentChatUser) ||
        (isToCurrentUser && isFromCurrentChatUser);

    log('👤 User message check:');
    log('   - Current user ID: $currentUserId');
    log('   - Current chat user ID: ${currentChatUserId.value}');
    log('   - From current user: $isFromCurrentUser');
    log('   - To current user: $isToCurrentUser');
    log('   - From chat user: $isFromCurrentChatUser');
    log('   - To chat user: $isToCurrentChatUser');
    log('   - Match: $isMatch');

    return isMatch;
  }

  bool _isDepartmentMessageBasedOnUsers(ChatModel message) {
    try {
      // This is a workaround method since your backend sends department: null
      // You need to implement logic based on your business requirements

      final currentUserId = profilecontroller.profile.value!.id;
      final departmentID = currentChatDepartmentId.value;

      log('🔍 Inferring department message:');
      log('   - Current user ID: $currentUserId');
      log('   - Current dept ID: ${currentChatDepartmentId.value}');
      log('   - Message sender ID: ${message.sender?.id}');
      log('   - Message receiver ID: ${message.receiver?.id}');

      // Example logic - adjust based on your needs:
      // If the receiver is the current user and we're in a department chat,
      // assume this message belongs to the current department
      if (message.receiver?.id == currentUserId &&
          currentChatDepartmentId.value > 0) {
        log('   - Message is for current user in dept chat context');
        return true;
      }
      if (message.receiver?.id == departmentID &&
          currentChatDepartmentId.value > 0) {
        log('   - Message is for current department in dept chat context');
        return true;
      }

      // If the sender is the current user and we're in a department chat,
      // assume this message belongs to the current department
      if (message.sender?.id == currentUserId &&
          currentChatDepartmentId.value > 0) {
        log('   - Message is from current user in dept chat context');
        return true;
      }

      // 🔥 IMPORTANT: You should work with your backend team to fix this
      // The proper solution is to have the WebSocket send the correct department field

      return false;
    } catch (e) {
      log('Error in _isDepartmentMessageBasedOnUsers: $e');
      return false;
    }
  }

// Enhanced department chat matching with debugging
  bool _isMessageForCurrentDepartmentChat(ChatModel message) {
    if (currentChatDepartmentId.value <= 0) {
      log('🔍 Dept chat check: No current department chat (currentChatDepartmentId: ${currentChatDepartmentId.value})');
      return false;
    }

    if (message.department == null) {
      log('🔍 Dept chat check: Message has no department - using inference');
      return _isDepartmentMessageBasedOnUsers(message);
    }

    log('🔍 Department chat matching:');
    log('   - Current dept ID: ${currentChatDepartmentId.value}');
    log('   - Message dept ID: ${message.department?.id}');

    final isMatch = message.department!.id == currentChatDepartmentId.value;
    log('   - Final result: $isMatch');

    return isMatch;
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

  // Get messages for user chat (admin messages) - updated to use ChatModel
  Future<void> getChatMessagesForUser(int userId, {int? departmentId}) async {
    isLoading(true);
    errorMessage('');
    currentChatMessages.clear();

    try {
      ApiResponse response;

      if (departmentId != null && departmentId > 0) {
        // Department chat
        response = await chatRepo.getDepartmentMessages(departmentId);

        // 🔥 FIX: Set the current chat IDs properly
        currentChatDepartmentId.value = departmentId;
        currentChatUserId.value = 0; // Clear user chat ID
        log('✅ SET current department chat ID: $departmentId');
      } else {
        // User chat
        response = await chatRepo.getUserMessages(userId);

        // 🔥 FIX: Set the current chat IDs properly
        currentChatUserId.value = userId;
        currentChatDepartmentId.value = 0; // Clear department chat ID
        log('✅ SET current user chat ID: $userId');
      }

      if (response.status == ApiStatus.SUCCESS && response.response != null) {
        List<dynamic> messageData = response.response;
        currentChatMessages.value =
            messageData.map((json) => ChatModel.fromJson(json)).toList();

        currentChatMessages.sort((a, b) {
          if (a.timestamp == null && b.timestamp == null) return 0;
          if (a.timestamp == null) return 1;
          if (b.timestamp == null) return -1;
          return b.timestamp!.compareTo(a.timestamp!);
        });

        log('Loaded ${currentChatMessages.length} messages for ${departmentId != null ? 'department $departmentId' : 'user $userId'}');
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

  void setCurrentChat({int? userId, int? departmentId}) {
    if (departmentId != null && departmentId > 0) {
      currentChatDepartmentId.value = departmentId;
      currentChatUserId.value = 0;
      log('✅ Switched to department chat: $departmentId');
    } else if (userId != null && userId > 0) {
      currentChatUserId.value = userId;
      currentChatDepartmentId.value = 0;
      log('✅ Switched to user chat: $userId');
    } else {
      // Clear both if neither is provided
      currentChatUserId.value = 0;
      currentChatDepartmentId.value = 0;
      log('✅ Cleared current chat context');
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
        // Message sent successfully
        log('Message sent successfully');

        // Optionally update the temporary message with server response
        if (response.response is Map<String, dynamic>) {
          final serverMessage = ChatModel.fromJson(response.response);
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
        // File sent successfully
        log('File sent successfully');
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
    await getChatMessagesForUser(1, departmentId: departmentId);
  }

  // Separate method specifically for user messages
  Future<void> getUserMessages(int userId) async {
    await getChatMessagesForUser(userId);
  }

  void addMessageToCurrentChat(ChatModel message) {
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
