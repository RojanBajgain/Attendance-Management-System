import 'package:ams/config/resources/styles.dart';
import 'package:flutter/material.dart';

class ProfileMenu extends StatefulWidget {
  const ProfileMenu({
    Key? key,
    required this.text,
    required this.icon,
    this.press,
    this.showIcon = true,
    this.expandedContent,
  }) : super(key: key);

  final String text;
  final IconData icon;
  final VoidCallback? press;
  final bool showIcon;
  final Widget? expandedContent; // Widget to show when expanded

  @override
  _ProfileMenuState createState() => _ProfileMenuState();
}

class _ProfileMenuState extends State<ProfileMenu> {
  bool _isExpanded = false; // Tracks expanded state

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

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
              backgroundColor:
                  isDarkMode ? Colors.grey.shade700 : Colors.grey.shade200,
            ),
            onPressed: () {
              _toggleExpand();
              if (widget.press != null) {
                widget.press!();
              }
            },
            child: Row(
              children: [
                Icon(
                  widget.icon,
                  size: 30,
                  color: isDarkMode ? Colors.black : Colors.black,
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Text(widget.text,
                      style: smallStyle.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isDarkMode ? Colors.white : Colors.black,
                      )),
                ),
                if (widget.showIcon)
                  GestureDetector(
                    onTap: _toggleExpand,
                    child: Icon(
                      _isExpanded ? Icons.expand_less : Icons.expand_more,
                      size: 30.0,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
              ],
            ),
          ),
          // Expanded content shown conditionally
          if (_isExpanded && widget.expandedContent != null)
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: widget.expandedContent,
            ),
        ],
      ),
    );
  }
}
