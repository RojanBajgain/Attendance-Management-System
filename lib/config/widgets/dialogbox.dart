import 'package:ams/config/resources/colors.dart';
import 'package:ams/config/resources/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final String subtitle;
  final String message;
  final String buttonText;
  final VoidCallback onButtonPressed;
  final bool islogout;
  final bool istest;
  final bool isquit;

  const CustomDialog({
    super.key,
    required this.title,
    required this.subtitle,
    required this.message,
    this.buttonText = "Okay",
    this.islogout = true,
    this.istest = true,
    this.isquit = true,
    required this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.75,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: normalStyle.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            if (istest) ...[
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.schedule_rounded,
                    color: Colors.black,
                    size: 14,
                  ),
                  const SizedBox(width: 4.0),
                  Flexible(
                    child: Text(
                      message,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: miniStyle,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                maxLines: 5,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: miniStyle,
              ),
            ] else if (isquit) ...[
              const SizedBox(height: 8),
              Column(
                children: [
                  Text(
                    subtitle,
                    maxLines: 5,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: miniStyle,
                  ),
                ],
              ),
            ] else
              Text(
                subtitle,
                maxLines: 5,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: miniStyle,
              ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (islogout)
                  _buildButton(
                    text: islogout ? 'Cancel' : 'Yes',
                    color: AppColors.cardRed,
                    textColor: AppColors.primary,
                    onTap: () => Get.back(),
                  ),
                _buildButton(
                  text: buttonText,
                  color: AppColors.primary,
                  textColor: AppColors.white,
                  onTap: onButtonPressed,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton({
    required String text,
    required Color color,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          style: smallStyle.copyWith(color: textColor),
        ),
      ),
    );
  }
}
