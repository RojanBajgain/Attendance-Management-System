import 'dart:io';
import 'package:ams/config/resources/styles.dart';
import 'package:ams/feature/presentation/pages/chat/controller/chat_controller.dart';
import 'package:ams/feature/presentation/pages/chat/model/chat_model.dart';
import 'package:ams/feature/presentation/pages/chat/widget/websocket_status_widget.dart';
import 'package:ams/feature/presentation/pages/login/controller/login_controller.dart';
import 'package:ams/feature/presentation/pages/profile/controller/profile_controller.dart';
import 'package:ams/feature/utils/ssnackbar_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';

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
    _loadMessages();
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
      final currentUserId = profileController.profile.first.id ?? 0;

      // Create a temporary message object using ChatModel
      final tempMessage = ChatModel(
        id: DateTime.now().millisecondsSinceEpoch, // Temporary ID
        message: messageText,
        timestamp: DateTime.now(),
        sender: Sender(
          id: currentUserId,
          // user: profileController.profile.first.user ?? 'You',
          profileImage: profileController.profile.first.profileImage,
        ),
        receiver: isDepartmentChat
            ? null
            : Sender(
                id: widget.otherUser.id,
                user: widget.otherUser.user,
                profileImage: widget.otherUser.profileImage,
              ),
        department: isDepartmentChat ? widget.department : null,
        document: null,
        mediaUrl: null,
        hasRead: false,
      );

      // Add message to UI immediately
      chatController.addMessageToCurrentChat(tempMessage);

      // Send the message via API/WebSocket
      await chatController.sendMessage(
        message: messageText,
        receiverId: isDepartmentChat ? null : widget.otherUser.id,
        departmentId: isDepartmentChat ? widget.department?.id : null,
      );

      // Scroll to bottom to show the new message
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    } catch (e) {
      // Remove the temporary message on error
      if (chatController.currentChatMessages.isNotEmpty) {
        chatController.currentChatMessages.removeAt(0);
      }

      SSnackbarUtil.showSnackbar(
        'Error',
        "Something went wrong, Failed to send message.",
        SnackbarType.error,
      );

      // Restore the message text if sending failed
      _messageController.text = messageText;
    }
  }

  void _sendImageOrDocument(File file, {String? message}) async {
    try {
      final isDepartmentChat = widget.department != null;
      final currentUserId = profileController.profile.first.id ?? 0;

      // Create a temporary message object using ChatModel
      final tempMessage = ChatModel(
        id: DateTime.now().millisecondsSinceEpoch, // Temporary ID
        message: message ?? '',
        timestamp: DateTime.now(),
        sender: Sender(
          id: currentUserId,
          // user: profileController.profile.first.user ?? 'You',
          profileImage: profileController.profile.first.profileImage,
        ),
        receiver: isDepartmentChat
            ? null
            : Sender(
                id: widget.otherUser.id,
                user: widget.otherUser.user,
                profileImage: widget.otherUser.profileImage,
              ),
        department: isDepartmentChat ? widget.department : null,
        document: file.path, // Show local file path temporarily
        mediaUrl: null,
        hasRead: false,
      );

      // Add message to UI immediately
      chatController.addMessageToCurrentChat(tempMessage);

      // Send the file
      await chatController.sendMessageWithFile(
        file: file,
        message: message ?? '',
        receiverId: isDepartmentChat ? null : widget.otherUser.id,
        departmentId: isDepartmentChat ? widget.department?.id : null,
      );

      // Scroll to bottom to show the new message
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    } catch (e) {
      // Remove the temporary message on error
      if (chatController.currentChatMessages.isNotEmpty) {
        chatController.currentChatMessages.removeAt(0);
      }

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
      SSnackbarUtil.showSnackbar(
        'Error',
        'Failed to capture image from camera. Please try again later',
        SnackbarType.error,
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
      SSnackbarUtil.showSnackbar(
        'Error',
        'Failed to pick an image. Please try again later',
        SnackbarType.error,
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
      SSnackbarUtil.showSnackbar(
        'Error',
        'Failed to pick an file. Please try again later',
        SnackbarType.error,
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
    return GestureDetector(
      onTap: () => _showFullScreenImage(imageUrl),
      child: Container(
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
                child: Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
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
                    Text('Failed to load image',
                        style: TextStyle(fontSize: 12)),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _showFullScreenImage(String imageUrl) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: Center(
            child: InteractiveViewer(
              panEnabled: true,
              minScale: 0.5,
              maxScale: 3.0,
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(Icons.error, color: Colors.white),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _openDocument(String documentUrl) async {
    try {
      // Normalize the URL if needed
      if (!documentUrl.startsWith('http://') &&
          !documentUrl.startsWith('https://') &&
          !documentUrl.startsWith('file://')) {
        documentUrl = 'https://$documentUrl';
      }

      final Uri uri = Uri.parse(documentUrl);

      // Check if it's a local file
      if (uri.scheme == 'file') {
        final file = File(uri.path);
        if (!await file.exists()) {
          throw Exception('File not found');
        }
      }

      // Try to launch externally first
      bool launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      // Fallback: in-app browser view if external app fails
      if (!launched) {
        launched = await launchUrl(
          uri,
          mode: LaunchMode.inAppWebView,
          webViewConfiguration: const WebViewConfiguration(
            enableJavaScript: true,
            enableDomStorage: true,
          ),
        );
      }

      if (!launched) {
        throw Exception('Could not launch $documentUrl');
      }
    } catch (e) {
      SSnackbarUtil.showSnackbar(
        'Error',
        'Could not open the document',
        SnackbarType.error,
      );
    }
  }

  String _getFileNameFromUrl(String url) {
    try {
      final uri = Uri.parse(url);
      final pathSegments = uri.pathSegments;
      if (pathSegments.isNotEmpty) {
        return pathSegments.last;
      }
      return 'Document';
    } catch (e) {
      return 'Document';
    }
  }

  IconData _getFileIcon(String url) {
    final uri = Uri.parse(url);
    final path = uri.path.toLowerCase();

    if (path.endsWith('.pdf')) return Icons.picture_as_pdf;
    if (path.endsWith('.doc') || path.endsWith('.docx')) {
      return Icons.description;
    }
    if (path.endsWith('.xls') || path.endsWith('.xlsx')) {
      return Icons.table_chart;
    }
    if (path.endsWith('.ppt') || path.endsWith('.pptx')) return Icons.slideshow;
    if (path.endsWith('.zip') || path.endsWith('.rar')) return Icons.archive;
    if (path.endsWith('.txt')) return Icons.text_snippet;

    return Icons.insert_drive_file;
  }

  String _getFileSizeAndType(String url) {
    try {
      final uri = Uri.parse(url);
      final path = uri.path.toLowerCase();
      final extension = path.split('.').last;

      // You could enhance this to show actual file size if you have that information
      return '${extension.toUpperCase()} file';
    } catch (e) {
      return 'Document';
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
          const WebSocketStatusWidget(),
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

                  // Check for media content - now using mediaUrl or document
                  final hasImage = (message.mediaUrl != null &&
                          message.mediaUrl!.isNotEmpty) ||
                      (message.document != null &&
                          message.document!.isNotEmpty &&
                          _isImageUrl(message.document));

                  final hasDocument = message.document != null &&
                      message.document!.isNotEmpty &&
                      !_isImageUrl(message.document);

                  final hasTextMessage =
                      message.message != null && message.message!.isNotEmpty;

                  // Determine which URL to use for media
                  final mediaUrl = message.mediaUrl ?? message.document;

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
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.7,
                            ),
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
                                  if (hasImage && mediaUrl != null) ...[
                                    _buildImageWidget(mediaUrl, isCurrentUser),
                                    if (hasTextMessage)
                                      const SizedBox(height: 8),
                                  ],
                                  // Display document link if it's not an image
                                  if (hasDocument &&
                                      message.document != null) ...[
                                    GestureDetector(
                                      onTap: () =>
                                          _openDocument(message.document!),
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: isCurrentUser
                                              ? Colors.blue.shade700
                                              : (isDarkMode
                                                  ? Colors.grey.shade700
                                                  : Colors.grey.shade300),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              _getFileIcon(message.document!),
                                              size: 24,
                                              color: isCurrentUser
                                                  ? Colors.white70
                                                  : Colors.blue,
                                            ),
                                            const SizedBox(width: 8),
                                            Flexible(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    _getFileNameFromUrl(
                                                        message.document!),
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: isCurrentUser
                                                          ? Colors.white
                                                          : Colors.black,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                  ),
                                                  Text(
                                                    _getFileSizeAndType(
                                                        message.document!),
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      color: isCurrentUser
                                                          ? Colors.white70
                                                          : Colors
                                                              .grey.shade600,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    if (hasTextMessage)
                                      const SizedBox(height: 8),
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
                                      softWrap: true,
                                      overflow: TextOverflow.clip,
                                    ),
                                  const SizedBox(height: 4),
                                  Text(
                                    message.timestamp != null
                                        ? DateFormat('h:mm a').format(
                                            message.timestamp!.toLocal())
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
                    onSubmitted: (value) => _sendMessage(),
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
