import 'package:ams/config/resources/styles.dart';
import 'package:ams/feature/presentation/pages/chat/controller/chat_controller.dart';
import 'package:ams/feature/presentation/pages/chat/model/chat_model.dart';
import 'package:ams/feature/presentation/pages/login/controller/login_controller.dart';
import 'package:ams/feature/presentation/pages/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ChatDetailScreen extends StatefulWidget {
  final Sender otherUser;
  final Department? department;

  const ChatDetailScreen({
    super.key,
    required this.otherUser,
    this.department,
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ChatController chatController = Get.find<ChatController>();
  final AuthController authController = Get.find<AuthController>();
  final ProfileController profileController = Get.find<ProfileController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadMessages();
    });
  }

  void _loadMessages() {
    chatController.getChatMessagesForUser(
      widget.otherUser.id!,
      departmentId: widget.department?.id,
    );
  }

  void _sendMessage() async {
    final messageText = _messageController.text.trim();

    if (messageText.isEmpty) {
      return; // Don't send empty messages
    }

    try {
      // Clear the input field immediately for better UX
      _messageController.clear();

      // Determine if we're sending to a user or department
      final isDepartmentChat = widget.department != null;

      // Send the message
      await chatController.sendMessage(
        message: messageText,
        receiverId: isDepartmentChat ? null : widget.otherUser.id,
        departmentId: isDepartmentChat ? widget.department?.id : null,
      );

      // Reload messages to show the new message
      _loadMessages();

      // Scroll to bottom to show the new message
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    } catch (e) {
      // Handle error - you might want to show a snackbar or toast
      Get.snackbar(
        'Error',
        'Failed to send message: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );

      // Restore the message text if sending failed
      _messageController.text = messageText;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final currentUserId = profileController.profile.first.id ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              widget.department?.name ?? widget.otherUser.user ?? 'Unknown',
              style: smallStyle.copyWith(
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (chatController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              return ListView.builder(
                controller: _scrollController,
                reverse: true,
                itemCount: chatController.currentChatMessages.length,
                itemBuilder: (context, index) {
                  final message = chatController.currentChatMessages[index];
                  final isCurrentUser = message.sender?.id == currentUserId;

                  return Container(
                    alignment: isCurrentUser
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Row(
                      mainAxisAlignment: isCurrentUser
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (!isCurrentUser) ...[
                          CircleAvatar(
                            radius: 14,
                            backgroundImage: message.sender?.profileImage !=
                                    null
                                ? NetworkImage(message.sender!.profileImage!)
                                : null,
                            child: message.sender?.profileImage == null
                                ? const Icon(Icons.person, size: 14)
                                : null,
                          ),
                          const SizedBox(width: 6),
                        ],
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isCurrentUser
                                  ? Colors.blue
                                  : (isDarkMode
                                      ? Colors.grey.shade800
                                      : Colors.grey.shade200),
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(12),
                                topRight: const Radius.circular(12),
                                bottomLeft:
                                    Radius.circular(isCurrentUser ? 12 : 0),
                                bottomRight:
                                    Radius.circular(isCurrentUser ? 0 : 12),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  message.message ?? '',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: isCurrentUser
                                        ? Colors.white
                                        : (isDarkMode
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  message.timestamp != null
                                      ? DateFormat('h:mm a')
                                          .format(message.timestamp!)
                                      : '',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: isCurrentUser
                                        ? Colors.white70
                                        : (isDarkMode
                                            ? Colors.grey.shade400
                                            : Colors.grey.shade600),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (isCurrentUser) const SizedBox(width: 6),
                      ],
                    ),
                  );
                },
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    style: TextStyle(
                      fontSize: 15,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onSubmitted: (value) =>
                        _sendMessage(), // Allow sending with Enter key
                  ),
                ),
                Obx(() => IconButton(
                      icon: chatController.isSending.value
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.send),
                      onPressed:
                          chatController.isSending.value ? null : _sendMessage,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
