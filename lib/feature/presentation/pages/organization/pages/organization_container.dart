import 'package:flutter/material.dart';
import 'package:ams/config/resources/styles.dart';

class OrganizationContainer extends StatelessWidget {
  final String title;
  final String? imagePath;

  const OrganizationContainer({
    super.key,
    required this.title,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 120,
      height: 100,
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[700] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          imagePath != null
              ? Image.asset(
                  imagePath!,
                  width: 40,
                  height: 40,
                  fit: BoxFit.contain,
                )
              : Icon(
                  Icons.business,
                  size: 40,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: smallNStyle.copyWith(
              fontWeight: FontWeight.w500,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
