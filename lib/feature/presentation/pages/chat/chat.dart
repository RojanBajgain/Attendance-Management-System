import 'package:ams/config/resources/styles.dart';
import 'package:ams/feature/presentation/pages/chat/controller/chat_controller.dart';
import 'package:ams/feature/presentation/pages/chat/model/chat_model.dart';
import 'package:ams/feature/presentation/pages/chat/sub_view_chat/chat_card.dart';
import 'package:ams/feature/presentation/pages/chat/sub_view_chat/message_page.dart';
import 'package:ams/feature/presentation/pages/login/controller/login_controller.dart';
import 'package:ams/feature/presentation/pages/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final chatController = Get.find<ChatController>();

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey.shade900 : Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          'Messages',
          style: normalStyle.copyWith(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: chatController.getAllChats,
        child: Obx(() {
          if (chatController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (chatController.errorMessage.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    chatController.errorMessage.value,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: chatController.getAllChats,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (chatController.chats.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 64,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No messages yet',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Start a conversation to see your messages here',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          }

          // Group chats by user/department to avoid duplicates
          Map<String, ChatModel> groupedChats = {};

          for (var chat in chatController.chats) {
            final profileController = Get.find<ProfileController>();
            final currentUserId = profileController.profile.first.id ?? 0;

            String key;
            if (chat.department != null) {
              key = 'dept_${chat.department!.id}';
            } else {
              final isCurrentUserSender = chat.sender?.id == currentUserId;
              final otherUser =
                  isCurrentUserSender ? chat.receiver : chat.sender;
              key = 'user_${otherUser?.id ?? 0}';
            }

            // Keep the most recent message for each conversation
            if (!groupedChats.containsKey(key) ||
                (chat.timestamp != null &&
                    groupedChats[key]!.timestamp != null &&
                    chat.timestamp!.isAfter(groupedChats[key]!.timestamp!))) {
              groupedChats[key] = chat;
            }
          }

          // Convert to list and sort by timestamp
          List<ChatModel> sortedChats = groupedChats.values.toList();

          return ListView.builder(
            itemCount: sortedChats.length,
            itemBuilder: (context, index) {
              final chat = sortedChats[index];
              return ChatCard(
                chat: chat,
                onTap: () {
                  // Optional: Add any additional logic when chat is tapped
                  print('Chat tapped: ${chat.id}');
                },
              );
            },
          );
        }),
      ),
    );
  }
}
