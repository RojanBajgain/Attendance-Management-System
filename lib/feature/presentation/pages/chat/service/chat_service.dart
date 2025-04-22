import 'dart:async';
import 'dart:convert';
import 'package:ams/feature/presentation/pages/chat/model/chat_model.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;

class ChatService {
  // Singleton pattern
  static final ChatService _instance = ChatService._internal();
  factory ChatService() => _instance;
  ChatService._internal();

  WebSocketChannel? _channel;
  final _messageController = StreamController<ChatModel>.broadcast();
  Stream<ChatModel> get messageStream => _messageController.stream;
  bool _isConnected = false;

  // Connect to WebSocket
  void connectToWebSocket(int chatId) {
    if (_isConnected) return;

    final wsUrl = Uri.parse('ws://192.168.254.48:8000/ws/chat/$chatId/');

    _channel = WebSocketChannel.connect(Uri.parse(wsUrl.toString()));
    _isConnected = true;

    // Listen to incoming messages
    _channel!.stream.listen(
      (message) {
        try {
          final data = json.decode(message);
          if (data['type'] == 'chat_message') {
            final chatMessage = ChatModel.fromJson(data['message']);
            _messageController.add(chatMessage);
          }
        } catch (e) {
          print('Error parsing WebSocket message: $e');
        }
      },
      onDone: () {
        _isConnected = false;
        print('WebSocket connection closed');
      },
      onError: (error) {
        _isConnected = false;
        print('WebSocket error: $error');
      },
    );
  }

  // Send message through WebSocket
  void sendMessage(String message, int senderId, int receiverId) {
    if (!_isConnected || _channel == null) return;

    final payload = {
      'type': 'chat_message',
      'message': message,
      'sender_id': senderId,
      'receiver_id': receiverId,
    };

    _channel!.sink.add(json.encode(payload));
  }

  // Send message through HTTP API
  Future<ChatModel?> sendMessageViaApi(
      String message, int senderId, int receiverId) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.254.48:8000/api/message/chat/'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'message': message,
          'sender': senderId,
          'receiver': receiverId,
        }),
      );

      if (response.statusCode == 201) {
        return ChatModel.fromJson(json.decode(response.body));
      } else {
        print('Failed to send message: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error sending message: $e');
      return null;
    }
  }

  // Fetch chat history
  Future<List<ChatModel>> fetchChatHistory(int chatId) async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://192.168.254.48:8000/api/message/chat/?chat_id=$chatId'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => ChatModel.fromJson(json)).toList();
      } else {
        print('Failed to fetch chat history: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching chat history: $e');
      return [];
    }
  }

  // Close WebSocket connection
  void disconnect() {
    if (_channel != null) {
      _channel!.sink.close();
      _isConnected = false;
    }
  }

  // Dispose resources
  void dispose() {
    disconnect();
    _messageController.close();
  }
}
