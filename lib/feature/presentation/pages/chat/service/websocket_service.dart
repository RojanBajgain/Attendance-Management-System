// import 'dart:async';
// import 'dart:convert';
// import 'package:web_socket_channel/web_socket_channel.dart';
// import 'package:web_socket_channel/status.dart' as status;
// import 'package:ams/feature/presentation/pages/chat/model/chat_model.dart';

// class WebSocketService {
//   // Singleton instance
//   static final WebSocketService _instance = WebSocketService._internal();
//   factory WebSocketService() => _instance;
//   WebSocketService._internal();

//   WebSocketChannel? _channel;
//   final _messageController = StreamController<ChatModel>.broadcast();
//   bool _isConnected = false;

//   // Expose stream of messages
//   Stream<ChatModel> get messageStream => _messageController.stream;
//   bool get isConnected => _isConnected;

//   // Connect to WebSocket with authentication token
//   void connect(String token, {int? userId}) {
//     final wsUrl = 'ws://backend.ams.ayata.com.np/ws/chat/';

//     // Add token as query parameter
//     final authenticatedUrl =
//         '$wsUrl?token=$token${userId != null ? '&user_id=$userId' : ''}';

//     try {
//       _channel = WebSocketChannel.connect(Uri.parse(authenticatedUrl));
//       _isConnected = true;

//       // Listen for incoming messages
//       _channel!.stream.listen(
//         (message) {
//           try {
//             final decodedMessage = json.decode(message);
//             final chatMessage = ChatModel.fromJson(decodedMessage);
//             _messageController.add(chatMessage);
//           } catch (e) {
//             print('Error processing WebSocket message: $e');
//           }
//         },
//         onDone: () {
//           _isConnected = false;
//           print('WebSocket connection closed');
//         },
//         onError: (error) {
//           _isConnected = false;
//           print('WebSocket error: $error');
//         },
//       );
//     } catch (e) {
//       print('Failed to connect to WebSocket: $e');
//       _isConnected = false;
//     }
//   }

//   // Send a message through WebSocket
//   void sendMessage(Map<String, dynamic> message) {
//     if (_isConnected && _channel != null) {
//       _channel!.sink.add(json.encode(message));
//     } else {
//       print('Cannot send message: WebSocket not connected');
//     }
//   }

//   // Close the WebSocket connection
//   void disconnect() {
//     if (_channel != null) {
//       _channel!.sink.close(status.goingAway);
//       _isConnected = false;
//     }
//   }

//   // Dispose resources
//   void dispose() {
//     disconnect();
//     _messageController.close();
//   }
// }
