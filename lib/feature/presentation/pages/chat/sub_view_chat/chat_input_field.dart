import 'package:ams/config/resources/styles.dart';
import 'package:flutter/material.dart';

class ChatInputField extends StatefulWidget {
  const ChatInputField({super.key});

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  bool _showAttachment = false;

  void _updateAttachmentState() {
    setState(() {
      _showAttachment = !_showAttachment;
    });
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
                        icon: Icon(Icons.assistant_navigation,
                            color: isDarkMode ? Colors.white : Colors.black),
                        onPressed: () {},
                      ),
                      const SizedBox(width: 16.0 / 4),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Type message",
                            hintStyle: smallStyle.copyWith(
                                color:
                                    isDarkMode ? Colors.white : Colors.black),
                            // suffixIcon: SizedBox(
                            //   width: 65,
                            //   child: Row(
                            //     children: [
                            //       InkWell(
                            //         onTap: _updateAttachmentState,
                            //         child: Icon(
                            //           Icons.attach_file,
                            //           color: _showAttachment
                            //               ? const Color(0xFF00BF6D)
                            //               : Theme.of(context)
                            //                   .textTheme
                            //                   .bodyLarge!
                            //                   .color!
                            //                   .withOpacity(0.64),
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
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
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // if (_showAttachment) const MessageAttachment(),
          ],
        ),
      ),
    );
  }
}
