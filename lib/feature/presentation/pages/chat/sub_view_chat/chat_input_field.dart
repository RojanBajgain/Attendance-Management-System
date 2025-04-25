import 'package:ams/config/resources/styles.dart';
import 'package:flutter/material.dart';

class ChatInputField extends StatefulWidget {
  final Function(String) onSendMessage;

  const ChatInputField({
    Key? key,
    required this.onSendMessage,
  }) : super(key: key);

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  final TextEditingController _textController = TextEditingController();
  bool _showAttachment = false;

  void _updateAttachmentState() {
    setState(() {
      _showAttachment = !_showAttachment;
    });
  }

  void _handleSend() {
    final message = _textController.text.trim();
    if (message.isNotEmpty) {
      widget.onSendMessage(message);
      _textController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 10.0 / 2,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -4),
            blurRadius: 32,
            color: const Color(0xFF087949).withOpacity(0.08),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                const SizedBox(width: 6.0),
                Expanded(
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.attach_file,
                          color: _showAttachment
                              ? const Color(0xFF00BF6D)
                              : isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                        ),
                        onPressed: _updateAttachmentState,
                      ),
                      const SizedBox(width: 16.0 / 4),
                      Expanded(
                        child: TextField(
                          controller: _textController,
                          decoration: InputDecoration(
                            hintText: "Type message",
                            hintStyle: smallStyle.copyWith(
                                color:
                                    isDarkMode ? Colors.white : Colors.black),
                            filled: true,
                            fillColor:
                                const Color(0xFF00BF6D).withOpacity(0.08),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 6.0),
                            border: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                            ),
                          ),
                          style: smallNStyle.copyWith(
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                          onSubmitted: (_) => _handleSend(),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.send,
                          color: Color(0xFF00BF6D),
                        ),
                        onPressed: _handleSend,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (_showAttachment) _buildAttachmentOptions(),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentOptions() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildAttachmentButton(Icons.image, "Image", () {
            // Add image handling
          }),
          _buildAttachmentButton(Icons.camera_alt, "Camera", () {
            // Add camera handling
          }),
          _buildAttachmentButton(Icons.insert_drive_file, "Document", () {
            // Add document handling
          }),
        ],
      ),
    );
  }

  Widget _buildAttachmentButton(
      IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF00BF6D).withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF00BF6D),
              size: 24,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
