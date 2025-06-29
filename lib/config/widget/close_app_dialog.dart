import 'package:ams/config/resources/colors.dart';
import 'package:ams/config/resources/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CloseApp extends StatelessWidget {
  final String title;
  final String subtitle;
  final String buttonText;
  final VoidCallback onButtonPressed;

  const CloseApp({
    super.key,
    required this.title,
    required this.subtitle,
    this.buttonText = "Yes",
    required this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.75,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: normalStyle.copyWith(
                fontWeight: FontWeight.bold,
                color: isDarkMode ? AppColors.white : Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              maxLines: 5,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: miniStyle.copyWith(
                color: isDarkMode ? AppColors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildButton(
                  text: 'No',
                  color: Colors.transparent,
                  textColor: Colors.black,
                  onTap: () => Get.back(),
                ),
                _buildButton(
                  text: buttonText,
                  color: AppColors.red,
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
