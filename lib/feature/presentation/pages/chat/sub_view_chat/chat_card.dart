import 'package:ams/feature/presentation/pages/chat/controller/chat_controller.dart';
import 'package:ams/feature/presentation/pages/chat/sub_view_chat/message_page.dart';
import 'package:ams/feature/presentation/pages/login/controller/login_controller.dart';
import 'package:ams/feature/presentation/pages/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ams/config/resources/styles.dart';
import '../model/chat_model.dart';

class ChatCard extends StatelessWidget {
  final ChatModel chat;
  final VoidCallback? onTap;

  const ChatCard({
    super.key,
    required this.chat,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final profileController = Get.find<ProfileController>();
    final currentUserId = profileController.profile.first.id ?? 0;

    // Determine who is the other user (not the current user)
    final isCurrentUserSender = chat.sender?.id == currentUserId;
    final otherUser = isCurrentUserSender ? chat.receiver : chat.sender;

    // Get display name
    String displayName = '';
    if (chat.department != null) {
      displayName = chat.department!.name ?? 'Department Chat';
    } else if (otherUser != null) {
      displayName = otherUser.user ?? 'Unknown User';
    } else {
      displayName = 'Unknown';
    }

    return InkWell(
      onTap: () {
        final chatController = Get.find<ChatController>();

        if (chat.department != null && chat.department!.id != null) {
          // Department chat
          chatController.getDepartmentMessages(chat.department!.id!);
          Get.to(() => ChatDetailScreen(
                otherUser: Sender(
                  id: 0,
                  user: chat.department!.name ?? 'Department',
                  isActive: true,
                ),
                department: chat.department,
              ));
        } else if (otherUser?.id != null && otherUser!.id! > 0) {
          // User chat
          chatController.getUserMessages(otherUser.id!);
          Get.to(() => ChatDetailScreen(
                otherUser: otherUser,
                department: null,
              ));
        } else {
          Get.snackbar(
            'Error',
            'Unable to open chat. Invalid user or department.',
            snackPosition: SnackPosition.BOTTOM,
          );
        }

        // Call the optional onTap callback
        onTap?.call();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey.shade800 : Colors.white,
          border: Border(
            bottom: BorderSide(
              color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade200,
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            // Profile Avatar
            Stack(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.blue.shade100,
                  backgroundImage: otherUser?.profileImage != null
                      ? NetworkImage(otherUser!.profileImage!)
                      : null,
                  child: otherUser?.profileImage == null
                      ? Text(
                          _getInitials(displayName),
                          style: TextStyle(
                            color: Colors.blue.shade800,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        )
                      : null,
                ),
                // Online indicator
                if (otherUser?.isActive == true)
                  Positioned(
                    bottom: 2,
                    right: 2,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color:
                              isDarkMode ? Colors.grey.shade800 : Colors.white,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),

            // Message content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          displayName,
                          style: normalStyle.copyWith(
                            fontWeight: chat.hasRead == false
                                ? FontWeight.bold
                                : FontWeight.w600,
                            color: isDarkMode ? Colors.white : Colors.black87,
                            fontSize: 16,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Time display
                      if (chat.timestamp != null)
                        Text(
                          _getFormattedTime(chat.timestamp!),
                          style: normalStyle.copyWith(
                            fontSize: 12,
                            color: chat.hasRead == false
                                ? Colors.blue
                                : (isDarkMode
                                    ? Colors.grey.shade400
                                    : Colors.grey.shade600),
                            fontWeight: chat.hasRead == false
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          chat.message ?? 'No message',
                          style: normalStyle.copyWith(
                            color: chat.hasRead == false
                                ? (isDarkMode ? Colors.white : Colors.black87)
                                : (isDarkMode
                                    ? Colors.grey.shade400
                                    : Colors.grey.shade600),
                            fontSize: 14,
                            fontWeight: chat.hasRead == false
                                ? FontWeight.w500
                                : FontWeight.normal,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      // Unread indicator
                      if (chat.hasRead == false)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getInitials(String name) {
    if (name.isEmpty) return '?';
    List<String> words = name.split(' ');
    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }

  String _getFormattedTime(DateTime timestamp) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate =
        DateTime(timestamp.year, timestamp.month, timestamp.day);

    if (messageDate == today) {
      // Today - show time
      return DateFormat('h:mm a').format(timestamp);
    } else if (messageDate == today.subtract(const Duration(days: 1))) {
      // Yesterday
      return 'Yesterday';
    } else if (now.difference(timestamp).inDays < 7) {
      // This week - show day name
      return DateFormat('EEEE').format(timestamp);
    } else if (timestamp.year == now.year) {
      // This year - show month and day
      return DateFormat('MMM d').format(timestamp);
    } else {
      // Different year - show month, day, and year
      return DateFormat('MMM d, y').format(timestamp);
    }
  }
}
