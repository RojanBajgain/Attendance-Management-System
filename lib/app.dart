import 'package:ams/config/resources/app_theme.dart';
import 'package:ams/config/routes/app_pages.dart';
import 'package:ams/config/routes/route_helper.dart';
import 'package:ams/feature/presentation/pages/theme/controller/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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
        SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(
            systemNavigationBarIconBrightness: Brightness.dark,
            systemNavigationBarColor: Colors.transparent,
            statusBarBrightness: Brightness.light,
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
          ),
        );
        return GetMaterialApp(
          builder: (context, child) {
            final mediaQuery = MediaQuery.of(context);
            return MediaQuery(
              data:
                  mediaQuery.copyWith(textScaler: const TextScaler.linear(1.0)),
              child: child ?? const SizedBox(),
            );
          },
          debugShowCheckedModeBanner: false,
          title: "Attendance Management System",
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeController.currentThemeMode.value,
          initialRoute:
              isLoggedIn ? RouteHelper.bottomnav : RouteHelper.landingpage,
          getPages: AppPages.routes,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''),
          ],
        );
      },
    );
  }
}
