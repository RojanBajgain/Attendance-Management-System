// import 'package:ams/config/resources/styles.dart';
// import 'package:ams/feature/presentation/pages/chat/controller/chat_controller.dart';
// import 'package:ams/feature/presentation/pages/chat/model/get_chat_by_id.dart';
// import 'package:ams/feature/presentation/pages/login/controller/login_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';

// class ChatDetailScreen extends StatelessWidget {
//   final ChatByIdModel chat;

//   const ChatDetailScreen({super.key, required this.chat});

//   @override
//   Widget build(BuildContext context) {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//     final chatController = Get.find<ChatController>();
//     final textController = TextEditingController();

//     // Fetch messages for the conversation
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final otherUserId =
//           chat.receiver?.id == Get.find<AuthController>().alluserData.value.user
//               ? chat.sender?.id
//               : chat.receiver?.id;
//       if (otherUserId != null) {
//         chatController.getChatMessages(userId: otherUserId);
//       }
//     });

//     return Scaffold(
//       backgroundColor: isDarkMode ? Colors.grey.shade300 : Colors.white,
//       appBar: AppBar(
//         centerTitle: false,
//         elevation: 0,
//         backgroundColor: isDarkMode ? Colors.black : Colors.blue,
//         foregroundColor: Colors.white,
//         title: Text(
//           chat.receiver?.user ?? chat.sender?.user ?? 'Chat',
//           style: normalStyle.copyWith(color: Colors.white),
//         ),
//       ),
//       body: Obx(
//         () => chatController.isLoading.value
//             ? const Center(child: CircularProgressIndicator())
//             : chatController.errorMessage.isNotEmpty
//                 ? Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           chatController.errorMessage.value,
//                           style: normalStyle.copyWith(color: Colors.red),
//                         ),
//                         const SizedBox(height: 16),
//                         ElevatedButton(
//                           onPressed: () {
//                             final otherUserId = chat.receiver?.id ==
//                                     Get.find<AuthController>()
//                                         .alluserData
//                                         .value
//                                         .user
//                                 ? chat.sender?.id
//                                 : chat.receiver?.id;
//                             if (otherUserId != null) {
//                               chatController.getChatMessages(
//                                   userId: otherUserId);
//                             }
//                           },
//                           child: const Text('Retry'),
//                         ),
//                       ],
//                     ),
//                   )
//                 : Column(
//                     children: [
//                       Expanded(
//                         child: ListView.builder(
//                           reverse: true, // Newest messages at the bottom
//                           itemCount: chatController.chatHistory.length,
//                           itemBuilder: (context, index) {
//                             final message = chatController
//                                 .chatHistory[index]; // Use index directly
//                             final currentUserId = Get.find<AuthController>()
//                                     .alluserData
//                                     .value
//                                     .user ??
//                                 0;
//                             final isCurrentUser = message.sender != null &&
//                                 message.sender!.id == currentUserId;
//                             return _buildMessageBubble(
//                               context,
//                               message,
//                               isCurrentUser,
//                               isDarkMode,
//                             );
//                           },
//                         ),
//                       ),
//                       _buildMessageInput(
//                           context, textController, chatController),
//                     ],
//                   ),
//       ),
//     );
//   }

//   Widget _buildMessageBubble(
//     BuildContext context,
//     ChatByIdModel message,
//     bool isCurrentUser,
//     bool isDarkMode,
//   ) {
//     final timestamp = message.timestamp?.toLocal();
//     final formattedTime =
//         timestamp != null ? DateFormat('h:mm a').format(timestamp) : '';

//     return Align(
//       alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: isCurrentUser
//               ? (isDarkMode ? Colors.blue.shade700 : Colors.blue)
//               : (isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200),
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Column(
//           crossAxisAlignment:
//               isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//           children: [
//             if (message.message != null)
//               Text(
//                 message.message!,
//                 style: normalStyle.copyWith(
//                   color: isCurrentUser ? Colors.white : Colors.black87,
//                 ),
//               ),
//             if (message.mediaUrl != null)
//               GestureDetector(
//                 onTap: () {
//                   // Open media (e.g., launch URL or show image)
//                   // Get.to(() => MediaViewer(url: message.mediaUrl!));
//                 },
//                 child: Text(
//                   'Media',
//                   style: normalStyle.copyWith(
//                     color: isCurrentUser ? Colors.white : Colors.blue,
//                     decoration: TextDecoration.underline,
//                   ),
//                 ),
//               ),
//             const SizedBox(height: 4),
//             Text(
//               formattedTime,
//               style: normalStyle.copyWith(
//                 fontSize: 10,
//                 color: isCurrentUser ? Colors.white70 : Colors.grey,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildMessageInput(
//     BuildContext context,
//     TextEditingController textController,
//     ChatController chatController,
//   ) {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//     return Container(
//       padding: const EdgeInsets.all(8),
//       color: isDarkMode ? Colors.grey.shade600 : Colors.grey.shade100,
//       child: Row(
//         children: [
//           Expanded(
//             child: TextField(
//               controller: textController,
//               decoration: InputDecoration(
//                 hintText: 'Type a message',
//                 hintStyle: smallStyle.copyWith(color: Colors.grey),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(20),
//                   borderSide: BorderSide.none,
//                 ),
//                 filled: true,
//                 fillColor: isDarkMode ? Colors.grey.shade800 : Colors.white,
//               ),
//               style: normalStyle.copyWith(
//                   color: isDarkMode ? Colors.white : Colors.black),
//             ),
//           ),
//           const SizedBox(width: 8),
//           IconButton(
//             icon: const Icon(Icons.send, color: Colors.blue),
//             onPressed: () {
//               if (textController.text.isNotEmpty) {
//                 final currentUserId =
//                     Get.find<AuthController>().alluserData.value.user ?? 0;
//                 final receiverId = chat.receiver?.id == currentUserId
//                     ? chat.sender?.id
//                     : chat.receiver?.id;
//                 final receiverName = chat.receiver?.id == currentUserId
//                     ? chat.sender?.user
//                     : chat.receiver?.user;
//                 chatController.sendMessage(
//                   textController.text,
//                   receiverId: receiverId,
//                   receiverName: receiverName,
//                   departmentId: null,
//                   departmentName: null,
//                 );
//                 textController.clear();
//               }
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
