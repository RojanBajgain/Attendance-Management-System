import 'package:ams/config/resources/app_theme.dart';
import 'package:ams/feature/presentation/pages/chat/chat.dart';
import 'package:ams/feature/presentation/pages/organization/pages/organization_page.dart';
import 'package:ams/feature/presentation/pages/bottom_nav/bottom_nav_page.dart';
import 'package:ams/feature/presentation/pages/landing/landing_page.dart';
import 'package:ams/feature/presentation/pages/login/login_page.dart';
import 'package:ams/feature/presentation/pages/theme/controller/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class App extends StatelessWidget {
  final ThemeController themeController = Get.put(ThemeController());
  final bool isLoggedIn;

  App({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Attendance Management System",
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeController.currentThemeMode.value,
          initialRoute: isLoggedIn ? '/bottom-nav' : '/landing',
          getPages: [
            GetPage(name: '/landing', page: () => const LandingPage()),
            GetPage(name: '/bottom-nav', page: () => const BottomNavPage()),
            GetPage(
                name: '/organization', page: () => const OrganizationPage()),
            GetPage(name: '/chat', page: () => const ChatsScreen()),
            GetPage(name: '/login', page: () => const LoginPage()),
          ],
          builder: (context, child) {
            final mediaQuery = MediaQuery.of(context);
            return MediaQuery(
              data:
                  mediaQuery.copyWith(textScaler: const TextScaler.linear(1.0)),
              child: child ?? const SizedBox(),
            );
          },
        );
      },
    );
  }
}
