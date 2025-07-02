import 'package:ams/config/resources/images.dart';
import 'package:ams/config/widget/close_app_dialog.dart';
import 'package:ams/feature/presentation/pages/bottom_nav/controller/bottom_nav_controller.dart';
import 'package:ams/feature/presentation/pages/dashboard/dashboard.dart';
import 'package:ams/feature/presentation/pages/payroll/payroll_page.dart';
import 'package:ams/feature/presentation/pages/profile/pages/profile.dart';
import 'package:ams/feature/presentation/pages/timeoff/time_off_page.dart';
import 'package:ams/feature/presentation/pages/timesheet/time_sheet_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:flutter/services.dart';

class BottomNavPage extends StatelessWidget {
  BottomNavPage({
    super.key,
  });
  final bottomNavController = Get.put(BottomNavController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    List<Widget> pages = [
      const DashboardPage(),
      TimeOffPage(),
      TimeSheetPage(),
      PayrollPage(),
      const ProfilePage(),
    ];

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          Get.dialog(
            CloseApp(
              title: 'Close app',
              subtitle: 'Are you sure you want to close this app?',
              onButtonPressed: () {
                Get.back();
                Future.delayed(
                  const Duration(milliseconds: 300),
                  () {
                    if (Platform.isAndroid) {
                      SystemNavigator.pop();
                    } else if (Platform.isIOS) {
                      exit(0);
                    }
                  },
                );
              },
              buttonText: 'Yes',
            ),
          );
        }
      },
      child: Scaffold(
        body: Obx(() {
          return pages[bottomNavController.selectedTab.value];
        }),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            boxShadow: [
              BoxShadow(
                color: isDarkMode
                    ? Colors.black.withOpacity(0.3)
                    : Colors.grey.withOpacity(0.1),
                spreadRadius: 0,
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
            border: isDarkMode
                ? Border(
                    top: BorderSide(
                      color: Colors.grey.withOpacity(0.2),
                      width: 0.5,
                    ),
                  )
                : null,
          ),
          child: SafeArea(
            child: Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Obx(() {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(
                      iconPath: AppIcons.home,
                      index: 0,
                      isSelected: bottomNavController.selectedTab.value == 0,
                      theme: theme,
                    ),
                    _buildNavItem(
                      iconPath: AppIcons.timeoff,
                      index: 1,
                      isSelected: bottomNavController.selectedTab.value == 1,
                      theme: theme,
                    ),
                    _buildNavItem(
                      iconPath: AppIcons.timesheet,
                      index: 2,
                      isSelected: bottomNavController.selectedTab.value == 2,
                      theme: theme,
                    ),
                    _buildNavItem(
                      iconPath: AppIcons.payroll,
                      index: 3,
                      isSelected: bottomNavController.selectedTab.value == 3,
                      theme: theme,
                    ),
                    _buildNavItem(
                      iconPath: AppIcons.profile,
                      index: 4,
                      isSelected: bottomNavController.selectedTab.value == 4,
                      theme: theme,
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required String iconPath,
    required int index,
    required bool isSelected,
    required ThemeData theme,
  }) {
    final isDarkMode = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => bottomNavController.changeTab(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDarkMode
                  ? Colors.white.withOpacity(0.1)
                  : Colors.black.withOpacity(0.1))
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: SvgPicture.asset(
            iconPath,
            key: ValueKey(isSelected),
            color: isSelected
                ? (isDarkMode ? Colors.white : Colors.black)
                : (isDarkMode ? Colors.white60 : Colors.grey),
            height: 26,
            width: 26,
          ),
        ),
      ),
    );
  }
}
