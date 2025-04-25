// import 'package:ams/config/resources/styles.dart';
// import 'package:ams/feature/presentation/pages/chat/controller/chat_controller.dart';
// import 'package:ams/feature/presentation/pages/chat/model/chat_model.dart';
// import 'package:ams/feature/presentation/pages/chat/sub_view_chat/chat_input_field.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class MessagesScreen extends StatefulWidget {
//   final int receiverId;
//   final String receiverName;
//   final String receiverImage;
//   final bool isReceiverActive;

//   const MessagesScreen({
//     Key? key,
//     required this.receiverId,
//     required this.receiverName,
//     required this.receiverImage,
//     this.isReceiverActive = false,
//   }) : super(key: key);

//   @override
//   State<MessagesScreen> createState() => _MessagesScreenState();
// }

// class _MessagesScreenState extends State<MessagesScreen> {
//   final ChatController _chatController = Get.find<ChatController>();
//   final TextEditingController _textController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     // Load chat history when screen opens
//     _chatController.getChatHistory(widget.receiverId);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;

//     return Scaffold(
//       backgroundColor: isDarkMode ? Colors.grey.shade300 : Colors.white,
//       appBar: AppBar(
//         centerTitle: false,
//         elevation: 0,
//         backgroundColor: isDarkMode ? Colors.black : Colors.greenAccent,
//         foregroundColor: Colors.white,
//         automaticallyImplyLeading: false,
//         title: Row(
//           children: [
//             const BackButton(),
//             CircleAvatar(
//               backgroundImage: NetworkImage(widget.receiverImage),
//             ),
//             const SizedBox(width: 16.0 * 0.75),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   widget.receiverName,
//                   style: smallStyle.copyWith(color: Colors.white),
//                 ),
//                 if (widget.isReceiverActive)
//                   Text(
//                     "Online",
//                     style: TextStyle(
//                       fontSize: 12,
//                       color: Colors.white.withOpacity(0.8),
//                     ),
//                   ),
//               ],
//             )
//           ],
//         ),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               child: Obx(() {
//                 if (_chatController.isLoading.value) {
//                   return const Center(child: CircularProgressIndicator());
//                 } else if (_chatController.errorMessage.value.isNotEmpty) {
//                   return Center(
//                     child: Text(_chatController.errorMessage.value),
//                   );
//                 } else {
//                   return ListView.builder(
//                     itemCount: _chatController.chatHistory.length,
//                     itemBuilder: (context, index) {
//                       final message = _chatController.chatHistory[index];
//                       final bool isSender =
//                           message.sender?.id == _chatController.getUserId();
//                       return MessageBubble(
//                         message: message,
//                         isSender: isSender,
//                       );
//                     },
//                   );
//                 }
//               }),
//             ),
//           ),
//           ChatInputField(
//             onSendMessage: (message) {
//               _chatController.sendMessage(message, widget.receiverId);
//               _textController.clear();
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

// class MessageBubble extends StatelessWidget {
//   final ChatModel message;
//   final bool isSender;

//   const MessageBubble({
//     Key? key,
//     required this.message,
//     required this.isSender,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;

//     return Padding(
//       padding: const EdgeInsets.only(top: 16.0),
//       child: Row(
//         mainAxisAlignment:
//             isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
//         children: [
//           if (!isSender) ...[
//             CircleAvatar(
//               radius: 12,
//               backgroundImage: NetworkImage(
//                 message.sender?.profileImage ??
//                     "https://i.postimg.cc/cCsYDjvj/user-2.png",
//               ),
//             ),
//             const SizedBox(width: 16.0 / 2),
//           ],
//           Container(
//             padding: const EdgeInsets.symmetric(
//               horizontal: 16.0 * 0.75,
//               vertical: 16.0 / 2,
//             ),
//             decoration: BoxDecoration(
//               color: const Color(0xFF00BF6D).withOpacity(isSender ? 1 : 0.1),
//               borderRadius: BorderRadius.circular(30),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   message.message ?? "",
//                   style: normalStyle.copyWith(
//                     color: isSender
//                         ? Colors.white
//                         : isDarkMode
//                             ? Colors.black
//                             : const Color(0xFF1D1D35),
//                   ),
//                 ),
//                 const SizedBox(height: 2),
//                 Text(
//                   _formatTimestamp(message.timestamp),
//                   style: TextStyle(
//                     fontSize: 10,
//                     color: isSender
//                         ? Colors.white.withOpacity(0.7)
//                         : Colors.black.withOpacity(0.5),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           if (isSender)
//             Padding(
//               padding: const EdgeInsets.only(left: 8.0),
//               child: Icon(
//                 message.hasRead == true ? Icons.done_all : Icons.done,
//                 size: 16,
//                 color: message.hasRead == true ? Colors.blue : Colors.grey,
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   String _formatTimestamp(DateTime? timestamp) {
//     if (timestamp == null) return "";

//     // Today's date formatting - just show time
//     final now = DateTime.now();
//     if (timestamp.year == now.year &&
//         timestamp.month == now.month &&
//         timestamp.day == now.day) {
//       return "${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}";
//     }

//     // Yesterday
//     final yesterday = now.subtract(const Duration(days: 1));
//     if (timestamp.year == yesterday.year &&
//         timestamp.month == yesterday.month &&
//         timestamp.day == yesterday.day) {
//       return "Yesterday ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}";
//     }

//     // Older messages
//     return "${timestamp.day}/${timestamp.month}/${timestamp.year} ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}";
//   }
// }
