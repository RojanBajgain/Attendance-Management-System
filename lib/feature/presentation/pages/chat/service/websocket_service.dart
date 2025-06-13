import 'dart:convert';
import 'dart:developer';
import 'package:ams/feature/data/datasource/remote/api_urls.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class WebSocketService {
  WebSocketChannel? _channel;
  String? _token;
  String? _organization;
  bool _isConnected = false;

  // Singleton pattern
  static final WebSocketService _instance = WebSocketService._internal();
  factory WebSocketService() => _instance;
  WebSocketService._internal();

  // Getters
  bool get isConnected => _isConnected;
  Stream? get stream => _channel?.stream;

  // Connect to WebSocket
  Future<void> connect({
    required String token,
    required String organization,
  }) async {
    try {
      _token = token;
      _organization = organization;

      // Close existing connection if any
      await disconnect();

      const wsUrl = ApiUrls.chatmessage;

      // Create WebSocket connection
      _channel = WebSocketChannel.connect(
        Uri.parse(wsUrl),
        protocols: null,
      );

      // Send authentication after connection
      _channel?.sink.add(jsonEncode({
        // 'type': 'auth',
        'token': token,
        'organization': organization,
      }));

      _isConnected = true;
      log('WebSocket connected successfully');

      // Listen for connection close
      _channel?.stream.listen(
        (data) {
          log('WebSocket received: $data');
        },
        onError: (error) {
          log('WebSocket error: $error');
          _isConnected = false;
        },
        onDone: () {
          log('WebSocket connection closed');
          _isConnected = false;
        },
      );
    } catch (e) {
      log('WebSocket connection failed: $e');
      _isConnected = false;
      rethrow;
    }
  }

  // Send message via WebSocket
  void sendMessage(Map<String, dynamic> message) {
    if (_isConnected && _channel != null) {
      try {
        final messageJson = jsonEncode(message);
        _channel?.sink.add(messageJson);
        log('WebSocket message sent: $messageJson');
      } catch (e) {
        log('Error sending WebSocket message: $e');
      }
    } else {
      log('WebSocket not connected, cannot send message');
    }
  }

  // Disconnect WebSocket
  Future<void> disconnect() async {
    if (_channel != null) {
      try {
        await _channel?.sink.close(status.goingAway);
        _isConnected = false;
        log('WebSocket disconnected');
      } catch (e) {
        log('Error disconnecting WebSocket: $e');
      }
    }
  }

  // Reconnect WebSocket
  Future<void> reconnect() async {
    if (_token != null && _organization != null) {
      await connect(token: _token!, organization: _organization!);
    }
  }
}
