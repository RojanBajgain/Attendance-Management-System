import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:ams/feature/data/datasource/remote/api_urls.dart';
import 'package:ams/feature/presentation/pages/profile/controller/profile_controller.dart';
import 'package:get/get.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class WebSocketService {
  WebSocketChannel? _channel;
  String? _token;
  String? _organization;
  StreamController<dynamic>? _messageController;

  // Make this reactive
  final RxBool _isConnected = false.obs;
  bool _isConnecting = false;
  StreamSubscription? _streamSubscription;
  Timer? _reconnectTimer;

  final profilecontroller = Get.find<ProfileController>();

  // Singleton pattern
  static final WebSocketService _instance = WebSocketService._internal();
  factory WebSocketService() => _instance;
  WebSocketService._internal() {
    _messageController = StreamController<dynamic>.broadcast();
  }

  // Getters - make isConnected reactive
  RxBool get isConnected => _isConnected;
  bool get isConnecting => _isConnecting;
  Stream<dynamic>? get stream => _messageController?.stream;

  // Connect to WebSocket
  Future<void> connect({
    required String token,
    required String organization,
    int retryCount = 0,
  }) async {
    if (_isConnecting) return;

    _isConnecting = true;
    _token = token;
    _organization = organization;

    try {
      // Close existing connection if any
      await disconnect();

      // Construct WebSocket URL
      final baseUrl = ApiUrls.wsUrl
          .replaceAll('http://', 'ws://')
          .replaceAll('https://', 'wss://');
      final userId = profilecontroller.profile.value!.id;
      final wsUrl = '${baseUrl}chat/${userId}_$organization/';

      // log('Attempting WebSocket connection to: $wsUrl');

      // Create WebSocket connection
      _channel = WebSocketChannel.connect(
        Uri.parse(wsUrl),
        protocols: ['chat'],
      );

      // Set up listeners
      _streamSubscription = _channel?.stream.listen(
        (message) {
          // log('Raw WebSocket message: $message');
          _handleIncomingMessage(message);
          // Forward message to our broadcast stream
          _messageController?.add(message);
        },
        onError: _handleConnectionError,
        onDone: _handleConnectionClosed,
      );

      // Send authentication
      final authMessage = jsonEncode({
        'type': 'auth',
        'token': token,
        'organization': organization,
        'user_id': userId,
        'department': profilecontroller.profile.value!.organization!.id,
      });
      _channel?.sink.add(authMessage);

      // Update connection status reactively
      _isConnected.value = true;
      // log('WebSocket connected successfully');

      // Cancel any pending reconnection attempts
      _reconnectTimer?.cancel();
      _reconnectTimer = null;
    } catch (e) {
      // log('WebSocket connection failed: $e');
      _isConnected.value = false;

      // Schedule reconnection if this wasn't already a retry
      if (retryCount < 3) {
        _scheduleReconnect(retryCount + 1);
      }
    } finally {
      _isConnecting = false;
    }
  }

  void _handleIncomingMessage(dynamic message) {
    try {
      // log('=== RAW WEBSOCKET MESSAGE ===');
      // log('Message type: ${message.runtimeType}');

      Map<String, dynamic> data;

      if (message is String) {
        try {
          data = jsonDecode(message);
        } catch (e) {
          // log('Failed to parse message as JSON: $e');
          return;
        }
      } else if (message is Map<String, dynamic>) {
        data = message;
      } else {
        // log('Unknown message format: $message');
        return;
      }

      // Enhanced logging
      // log('=== PARSED MESSAGE DATA ===');
      // log('Full message: $data');

      // Check for department field and warn if missing for what appears to be a department message
      if (data['receiver'] == null && data['department'] == null) {
        // log('⚠️ WARNING: Potential department message missing department field!');
      }

      // Process the message
      _processMessage(data);
    } catch (e) {
      // log('Error processing WebSocket message: $e');
    }
  }

  void _processMessage(Map<String, dynamic> data) {
    if (data.containsKey('type')) {
      switch (data['type']) {
        case 'auth_response':
          if (data['status'] == 'success') {
            // log('WebSocket authenticated successfully');
            _isConnected.value = true;
          } else {
            // log('WebSocket authentication failed: ${data['message']}');
            disconnect();
          }
          break;
        case 'chat_message':
          // log('Received chat message via WebSocket');
          break;
        default:
        // log('Unknown message type: ${data['type']}');
      }
    } else {
      // Handle direct message format (like your log shows)
      if (data.containsKey('id') && data.containsKey('message')) {
        // log('Received direct message format via WebSocket');
      }
    }
  }

  void _handleConnectionError(dynamic error) {
    // log('WebSocket error: $error');
    _isConnected.value = false;
    _scheduleReconnect();
  }

  void _handleConnectionClosed() {
    // log('WebSocket connection closed');
    _isConnected.value = false;
    _scheduleReconnect();
  }

  void _scheduleReconnect([int retryCount = 0]) {
    if (_reconnectTimer != null || _isConnecting) return;

    // Exponential backoff for reconnection
    final delay = Duration(seconds: 2 * (retryCount + 1));
    // log('Scheduling WebSocket reconnection in ${delay.inSeconds} seconds...');

    _reconnectTimer = Timer(delay, () {
      if (_token != null && _organization != null) {
        connect(
          token: _token!,
          organization: _organization!,
          retryCount: retryCount,
        );
      }
    });
  }

  // Send message via WebSocket
  void sendMessage(Map<String, dynamic> message) {
    if (!_isConnected.value || _channel == null) {
      // log('Cannot send message - WebSocket not connected');
      return;
    }

    try {
      final fullMessage = {
        'type': 'chat_message',
        'timestamp': DateTime.now().toIso8601String(),
        ...message,
      };
      _channel?.sink.add(jsonEncode(fullMessage));
      // log('WebSocket message sent: $fullMessage');
    } catch (e) {
      // log('Error sending WebSocket message: $e');
    }
  }

  // Disconnect WebSocket
  Future<void> disconnect() async {
    _reconnectTimer?.cancel();
    _reconnectTimer = null;

    try {
      await _streamSubscription?.cancel();
      await _channel?.sink.close(status.goingAway);
      // log('WebSocket disconnected');
    } catch (e) {
      // log('Error disconnecting WebSocket: $e');
    } finally {
      _channel = null;
      _streamSubscription = null;
      _isConnected.value = false;
      _isConnecting = false;
    }
  }

  // Clean up resources
  void dispose() {
    disconnect();
    _messageController?.close();
    _messageController = null;
  }
}
