import 'dart:io';
import 'package:ams/config/resources/styles.dart';
import 'package:ams/feature/presentation/pages/chat/controller/chat_controller.dart';
import 'package:ams/feature/presentation/pages/chat/model/chat_model.dart';
import 'package:ams/feature/presentation/pages/login/controller/login_controller.dart';
import 'package:ams/feature/presentation/pages/profile/controller/profile_controller.dart';
import 'package:ams/feature/utils/ssnackbar_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

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
  final ImagePicker _imagePicker = ImagePicker();

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
      return;
    }

    try {
      _messageController.clear();

      final isDepartmentChat = widget.department != null;

      // Send the message
      await chatController.sendMessage(
        message: messageText,
        receiverId: isDepartmentChat ? null : widget.otherUser.id,
        departmentId: isDepartmentChat ? widget.department?.id : null,
      );

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
      SSnackbarUtil.showSnackbar(
        'Error',
        "Failed to send message",
        SnackbarType.error,
      );

      // Restore the message text if sending failed
      _messageController.text = messageText;
    }
  }

  void _sendImageOrDocument(File file, {String? message}) async {
    try {
      // Determine if we're sending to a user or department
      final isDepartmentChat = widget.department != null;

      // Send the file
      await chatController.sendMessageWithFile(
        file: file,
        message: message ?? '',
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
      SSnackbarUtil.showSnackbar(
        'Error',
        "Failed to send message",
        SnackbarType.error,
      );
    }
  }

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;

        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: Text(
                  'Camera',
                  style: smallStyle.copyWith(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromCamera();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text(
                  'Gallery',
                  style: smallStyle.copyWith(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromGallery();
                },
              ),
              ListTile(
                leading: const Icon(Icons.attach_file),
                title: Text(
                  'Document',
                  style: smallStyle.copyWith(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickDocument();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _pickImageFromCamera() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (image != null) {
        final file = File(image.path);
        _sendImageOrDocument(file);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image from camera: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _pickImageFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        final file = File(image.path);
        _sendImageOrDocument(file);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image from gallery: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _pickDocument() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        _sendImageOrDocument(file);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick document: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Helper method to check if a URL is an image
  bool _isImageUrl(String? url) {
    if (url == null || url.isEmpty) return false;
    final imageExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp'];
    return imageExtensions.any((ext) => url.toLowerCase().endsWith(ext));
  }

  // Widget to display image with error handling
  Widget _buildImageWidget(String imageUrl, bool isCurrentUser) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 250,
        maxHeight: 200,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              height: 100,
              width: 200,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              height: 100,
              width: 200,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.broken_image, size: 30, color: Colors.grey),
                  Text('Failed to load image', style: TextStyle(fontSize: 12)),
                ],
              ),
            );
          },
        ),
      ),
    );
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
                  final hasImage =
                      message.document != null && message.document!.isNotEmpty;
                  final hasTextMessage =
                      message.message != null && message.message!.isNotEmpty;

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
                                // Display image if present
                                if (hasImage &&
                                    _isImageUrl(message.document)) ...[
                                  _buildImageWidget(
                                      message.document!, isCurrentUser),
                                  if (hasTextMessage) const SizedBox(height: 8),
                                ],
                                // Display document link if it's not an image
                                if (hasImage &&
                                    !_isImageUrl(message.document)) ...[
                                  GestureDetector(
                                    onTap: () {
                                      // Handle document tap - you might want to open it in a browser
                                      // or download it
                                      print(
                                          'Document tapped: ${message.document}');
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.attach_file,
                                            size: 16,
                                            color: Colors.white70,
                                          ),
                                          const SizedBox(width: 4),
                                          Flexible(
                                            child: Text(
                                              'Document',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: isCurrentUser
                                                    ? Colors.white70
                                                    : (isDarkMode
                                                        ? Colors.grey.shade400
                                                        : Colors.grey.shade600),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (hasTextMessage) const SizedBox(height: 8),
                                ],
                                // Display text message if present
                                if (hasTextMessage)
                                  Text(
                                    message.message!,
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
                                      ? DateFormat('h:mm a').format(message
                                          .timestamp!
                                          .toLocal()) // Add toLocal() here
                                      : '',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: isCurrentUser
                                        ? Colors.white70
                                        : (isDarkMode
                                            ? Colors.grey.shade400
                                            : Colors.grey.shade600),
                                  ),
                                )
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
                // Attachment button
                IconButton(
                  icon: const Icon(Icons.attach_file),
                  onPressed: _showAttachmentOptions,
                ),
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
