// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:ams/feature/presentation/pages/chat/model/get_chat_by_id.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:ams/config/resources/styles.dart';
import 'package:ams/feature/presentation/pages/login/controller/login_controller.dart';

class ChatCard extends StatelessWidget {
  final ChatByIdModel chat;
  final VoidCallback press;

  const ChatCard({
    super.key,
    required this.chat,
    required this.press,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final timestamp = chat.timestamp?.toLocal();
    final formattedTime =
        timestamp != null ? DateFormat('h:mm a').format(timestamp) : '';

    final currentUserId =
        Get.find<AuthController>().alluserData.value.user ?? 0;
    final displayName = chat.receiver?.id == currentUserId
        ? chat.sender?.user ?? 'Unknown'
        : chat.receiver?.user ?? 'Unknown';

    return InkWell(
      onTap: press,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: chat.sender?.profileImage != null
                  ? NetworkImage(chat.sender!.profileImage!)
                  : null,
              child: chat.sender?.profileImage == null
                  ? Text(displayName[0].toUpperCase())
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName,
                    style: normalStyle.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.black : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    chat.message ??
                        (chat.mediaUrl != null ? 'Media' : 'No message'),
                    style: normalStyle.copyWith(
                      color: isDarkMode ? Colors.black54 : Colors.grey,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Text(
                  formattedTime,
                  style: normalStyle.copyWith(
                    fontSize: 12,
                    color: isDarkMode ? Colors.black54 : Colors.grey,
                  ),
                ),
                if (chat.hasRead == false)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
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
    );
  }
}
