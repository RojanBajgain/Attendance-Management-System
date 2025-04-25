// import 'package:ams/config/resources/styles.dart';
// import 'package:ams/feature/presentation/pages/chat/sub_view_chat/chat_inbox_card.dart';
// import 'package:ams/feature/presentation/pages/chat/sub_view_chat/message_page.dart';
// import 'package:flutter/material.dart';

// class ChatCard extends StatelessWidget {
//   const ChatCard({
//     super.key,
//     required this.chat,
//     required this.press,
//   });

//   final Chat chat;
//   final VoidCallback? press;

//   @override
//   Widget build(BuildContext context) {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;

//     return InkWell(
//       onTap: () {
//         // Extract user ID from the chat object - you'll need to determine how to get this
//         // For example, if you have a userId field in your Chat class:
//         final int receiverId =
//             0; // Replace with chat.userId or appropriate field

//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => MessagesScreen(
//               receiverId: receiverId, // The ID of the user you're chatting with
//               receiverName: chat.name,
//               receiverImage: chat.image,
//               isReceiverActive: chat.isActive,
//             ),
//           ),
//         );
//       },
//       child: Padding(
//         padding:
//             const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0 * 0.75),
//         child: Row(
//           children: [
//             CircleAvatarWithActiveIndicator(
//               image: chat.image,
//               isActive: chat.isActive,
//             ),
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       chat.name,
//                       style: smallNStyle.copyWith(
//                         color:
//                             isDarkMode ? Colors.black : const Color(0xFF212121),
//                       ),
//                     ),
//                     const SizedBox(height: 10.0),
//                     Opacity(
//                       opacity: 0.64,
//                       child: Text(
//                         chat.lastMessage,
//                         style: smallNStyle.copyWith(
//                           color: isDarkMode
//                               ? Colors.black
//                               : const Color(0xFF212121),
//                         ),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
