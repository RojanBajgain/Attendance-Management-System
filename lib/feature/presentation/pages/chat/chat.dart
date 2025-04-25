// import 'package:ams/config/resources/styles.dart';
// import 'package:ams/feature/presentation/pages/chat/sub_view_chat/chat_card.dart';
// import 'package:ams/feature/presentation/pages/chat/sub_view_chat/chat_inbox_card.dart';
// import 'package:flutter/material.dart';

// class ChatsScreen extends StatelessWidget {
//   const ChatsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;

//     return Scaffold(
//       backgroundColor: isDarkMode ? Colors.grey.shade300 : Colors.white,
//       appBar: AppBar(
//         centerTitle: false,
//         elevation: 0,
//         backgroundColor: isDarkMode ? Colors.black : const Color(0xFF00BF6D),
//         foregroundColor: Colors.white,
//         automaticallyImplyLeading: true,
//         title: Text(
//           "Chats",
//           style: normalStyle.copyWith(
//             color: Colors.white,
//           ),
//         ),
//         // actions: [
//         //   IconButton(
//         //     icon: const Icon(Icons.search),
//         //     onPressed: () {},
//         //   ),
//         // ],
//       ),
//       body: Column(
//         children: [
//           //     Container(
//           //       padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
//           //       color: const Color(0xFF00BF6D),
//           //       child: Row(
//           //         children: [
//           //           FillOutlineButton(press: () {}, text: "Recent Message"),
//           //           const SizedBox(width: 16.0),
//           //           FillOutlineButton(
//           //             press: () {},
//           //             text: "Active",
//           //             isFilled: false,
//           //           ),
//           //         ],
//           //       ),
//           //     ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: chatsData.length,
//               itemBuilder: (context, index) => ChatCard(
//                 chat: chatsData[index],
//                 press: () {},
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
