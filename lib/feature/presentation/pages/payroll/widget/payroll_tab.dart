import 'package:ams/config/resources/styles.dart';
import 'package:flutter/material.dart';

class TabButton extends StatelessWidget {
  final String tabType;
  final String activeTabType;
  final bool isDarkMode;
  final VoidCallback onTap;

  const TabButton({
    Key? key,
    required this.tabType,
    required this.activeTabType,
    required this.isDarkMode,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isActive = activeTabType.toUpperCase() == tabType.toUpperCase();
    final String label = getTabName(tabType);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: smallNStyle.copyWith(
                color: isActive
                    ? Colors.black
                    : (isDarkMode ? Colors.white70 : Colors.black54),
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                fontSize: 12.0,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String getTabName(String type) {
    switch (type.toUpperCase()) {
      case "PROFILE":
        return 'Profile';
      case "PAYSLIP":
        return 'Payslip';
      case "TAX":
        return 'Tax Details';
      case "COMPENSATION":
        return 'Compensation & Plan';
      case "ACCOUNTS":
        return 'Accounts & Taxes';
      case "INVESTMENT":
        return 'Investment & Tax Planning';
      default:
        return 'Profile';
    }
  }
}
