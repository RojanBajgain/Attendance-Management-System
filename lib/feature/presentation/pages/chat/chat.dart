// import 'package:ams/config/resources/styles.dart';
// import 'package:ams/feature/presentation/pages/chat/controller/chat_controller.dart';
// import 'package:ams/feature/presentation/pages/chat/sub_view_chat/chat_card.dart';
// import 'package:ams/feature/presentation/pages/chat/sub_view_chat/message_page.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class ChatsScreen extends StatelessWidget {
//   const ChatsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//     final chatController = Get.find<ChatController>();

//     return Scaffold(
//       backgroundColor: isDarkMode ? Colors.grey.shade300 : Colors.white,
//       appBar: AppBar(
//         centerTitle: false,
//         elevation: 0,
//         backgroundColor: isDarkMode ? Colors.black : Colors.blue,
//         foregroundColor: Colors.white,
//         automaticallyImplyLeading: true,
//         title: Text(
//           'Messages',
//           style: normalStyle.copyWith(color: Colors.white),
//         ),
//       ),
//       body: RefreshIndicator(
//         onRefresh: () async {
//           await chatController.getChats();
//         },
//         child: Obx(
//           () => chatController.isLoading.value
//               ? const Center(child: CircularProgressIndicator())
//               : chatController.errorMessage.isNotEmpty
//                   ? Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             chatController.errorMessage.value,
//                             style: normalStyle.copyWith(color: Colors.red),
//                           ),
//                           const SizedBox(height: 16),
//                           ElevatedButton(
//                             onPressed: chatController.getChats,
//                             child: const Text('Retry'),
//                           ),
//                         ],
//                       ),
//                     )
//                   : chatController.chatHistory.isEmpty
//                       ? Center(
//                           child: Text(
//                             'No messages yet',
//                             style: normalStyle.copyWith(
//                               color: isDarkMode ? Colors.black54 : Colors.grey,
//                             ),
//                           ),
//                         )
//                       : ListView.builder(
//                           itemCount: chatController.chatHistory.length,
//                           itemBuilder: (context, index) => ChatCard(
//                             chat: chatController.chatHistory[index],
//                             press: () {
//                               Get.to(() => ChatDetailScreen(
//                                     chat: chatController.chatHistory[index],
//                                   ));
//                             },
//                           ),
//                         ),
//         ),
//       ),
//     );
//   }
// }
