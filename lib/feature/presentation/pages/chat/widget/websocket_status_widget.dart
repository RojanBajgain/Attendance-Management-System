import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ams/feature/presentation/pages/chat/controller/chat_controller.dart';

class WebSocketStatusWidget extends StatelessWidget {
  const WebSocketStatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final chatController = Get.find<ChatController>();

    return Obx(() => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: chatController.isWebSocketConnected.value ? 0 : 30,
          child: chatController.isWebSocketConnected.value
              ? const SizedBox.shrink()
              : Container(
                  color: Colors.orange.shade100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.wifi_off,
                        size: 16,
                        color: Colors.orange.shade800,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Connecting to live chat...',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.orange.shade800,
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.orange.shade800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ));
  }
}
