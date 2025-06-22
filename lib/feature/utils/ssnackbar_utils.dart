import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SSnackbarUtil {
  SSnackbarUtil._();

  static showSnackbar(String title, String message, SnackbarType? type,
      {int? duration}) {
    Color color = Colors.grey.shade300;
    switch (type ?? SnackbarType.info) {
      case SnackbarType.info:
        color = Colors.grey.shade300;
        break;
      case SnackbarType.warning:
        color = Colors.red.shade300;
        break;
      case SnackbarType.error:
        color = Colors.red.shade300;
        break;
      case SnackbarType.success:
        color = Colors.green.shade300;
        break;
    }
    var newMessage = message.replaceAll(RegExp(r"^Exception:"), "");

    if (Get.context != null) {
      Get.rawSnackbar(
        // title,
        // message,
        borderRadius: 1,
        borderWidth: 1,
        snackPosition: SnackPosition.TOP,
        snackStyle: SnackStyle.FLOATING,
        animationDuration: const Duration(milliseconds: 200),
        forwardAnimationCurve: Curves.elasticIn,
        reverseAnimationCurve: Curves.elasticIn,
        isDismissible: true,
        dismissDirection: DismissDirection.horizontal,
        message: newMessage,
        duration: Duration(seconds: duration ?? 3),
        title: title,
        messageText: Text(
          newMessage,
          maxLines: 4,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),

        borderColor: color.withOpacity(0.8),
        barBlur: 1,

        backgroundColor: color,
      );
    } else {}
  }
}

enum SnackbarType { info, warning, error, success }
