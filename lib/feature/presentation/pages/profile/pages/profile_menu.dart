import 'package:ams/config/resources/styles.dart';
import 'package:flutter/material.dart';

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    Key? key,
    required this.text,
    required this.icon,
    this.press,
    this.showIcon = true,
    this.expandedContent,
    this.isExpanded = false,
    this.onExpandToggle,
    this.trailing,
  }) : super(key: key);

  final String text;
  final IconData icon;
  final VoidCallback? press;
  final bool showIcon;
  final Widget? expandedContent;
  final bool isExpanded;
  final VoidCallback? onExpandToggle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Column(
        children: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
              padding: const EdgeInsets.all(18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              backgroundColor: isDarkMode ? Colors.grey.shade700 : Colors.white,
            ),
            onPressed: () {
              if (onExpandToggle != null && showIcon) {
                onExpandToggle!();
              }
              if (press != null) {
                press!();
              }
            },
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 27,
                  color: isDarkMode ? Colors.grey.shade200 : Colors.black,
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Text(
                    text,
                    style: smallStyle.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                if (trailing != null) trailing!,
                if (showIcon && trailing == null)
                  GestureDetector(
                    onTap: onExpandToggle,
                    child: Icon(
                      isExpanded ? Icons.expand_less : Icons.expand_more,
                      size: 27.0,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
              ],
            ),
          ),
          // Expanded content shown conditionally
          if (isExpanded && expandedContent != null)
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
              child: expandedContent,
            ),
        ],
      ),
    );
  }
}
