// import 'dart:convert';
// import 'dart:developer';
// import 'package:ams/feature/data/datasource/remote/api_urls.dart';
// import 'package:ams/feature/utils/ssnackbar_utils.dart';
// import 'package:get/get.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';

// class WebSocketController extends GetxController {
//   WebSocketChannel? _webSocketChannel;
//   var isWebSocketConnected = false.obs;
//   static const String _baseWsUrl = ApiUrls.chatmessage;
//   int? _userId;
//   String? _organizationApiKey;

//   Stream<dynamic>? get stream => _webSocketChannel?.stream;

//   @override
//   void onInit() {
//     super.onInit();
//     Get.put(this, permanent: true);
//   }

//   @override
//   void onClose() {
//     _disconnectWebSocket();
//     super.onClose();
//   }

//   Future<void> connectWebSocket(int userId, String organizationApiKey) async {
//     if (isWebSocketConnected.value &&
//         _userId == userId &&
//         _organizationApiKey == organizationApiKey) {
//       log('WebSocket already connected for user: $userId, organization: $organizationApiKey');
//       return;
//     }

//     _disconnectWebSocket();

//     _userId = userId;
//     _organizationApiKey = organizationApiKey;

//     try {
//       final wsUrl = '$_baseWsUrl${userId.toString()}_$organizationApiKey/';
//       _webSocketChannel = WebSocketChannel.connect(Uri.parse(wsUrl));
//       isWebSocketConnected.value = true;
//       log('WebSocket connected for user: $userId, organization: $organizationApiKey');

//       _webSocketChannel!.stream.listen(
//         (message) {
//           log('WebSocket message received: $message');
//           try {
//             final data = json.decode(message);
//             SSnackbarUtil.showSnackbar(
//               'WebSocket Message',
//               data.toString(),
//               SnackbarType.info,
//             );
//           } catch (e) {
//             log('Error parsing WebSocket message: $e');
//             SSnackbarUtil.showSnackbar(
//               'WebSocket Message',
//               message.toString(),
//               SnackbarType.info,
//             );
//           }
//         },
//         onError: (error) {
//           log('WebSocket error: $error');
//           isWebSocketConnected.value = false;
//           SSnackbarUtil.showSnackbar(
//             'WebSocket Error',
//             'Failed to connect to WebSocket server.',
//             SnackbarType.error,
//           );
//           _reconnectWebSocket();
//         },
//         onDone: () {
//           log('WebSocket connection closed');
//           isWebSocketConnected.value = false;
//           _reconnectWebSocket();
//         },
//       );
//     } catch (e) {
//       log('WebSocket connection failed: $e');
//       isWebSocketConnected.value = false;
//       SSnackbarUtil.showSnackbar(
//         'WebSocket Error',
//         'Failed to connect to WebSocket server.',
//         SnackbarType.error,
//       );
//       _reconnectWebSocket();
//     }
//   }

//   void disconnectWebSocket() {
//     _disconnectWebSocket();
//   }

//   // Private implementation
//   void _disconnectWebSocket() {
//     _webSocketChannel?.sink.close();
//     _webSocketChannel = null;
//     isWebSocketConnected.value = false;
//     _userId = null;
//     _organizationApiKey = null;
//     log('WebSocket disconnected');
//   }

//   void _reconnectWebSocket() async {
//     if (_userId == null || _organizationApiKey == null) {
//       log('Cannot reconnect WebSocket: userId or organizationApiKey is missing');
//       return;
//     }
//     const maxRetries = 3;
//     int retryCount = 0;
//     while (!isWebSocketConnected.value && retryCount < maxRetries) {
//       log('Attempting to reconnect WebSocket (attempt ${retryCount + 1})...');
//       await Future.delayed(const Duration(seconds: 5));
//       await connectWebSocket(_userId!, _organizationApiKey!);
//       retryCount++;
//     }
//     if (!isWebSocketConnected.value) {
//       SSnackbarUtil.showSnackbar(
//         'WebSocket Error',
//         'Failed to reconnect to WebSocket server after $maxRetries attempts.',
//         SnackbarType.error,
//       );
//     }
//   }

//   void sendWebSocketMessage(String message) {
//     if (isWebSocketConnected.value && _webSocketChannel != null) {
//       _webSocketChannel!.sink.add(message);
//       log('WebSocket message sent: $message');
//     } else {
//       log('Cannot send message: WebSocket is not connected');
//       SSnackbarUtil.showSnackbar(
//         'WebSocket Error',
//         'Not connected to WebSocket server.',
//         SnackbarType.error,
//       );
//     }
//   }
// }
