import 'package:ams/config/resources/app_theme.dart';
import 'package:ams/config/resources/colors.dart';
import 'package:ams/config/routes/app_pages.dart';
import 'package:ams/config/routes/route_helper.dart';
import 'package:ams/feature/presentation/pages/app_image_brand/controller/app_brand_controller.dart';
import 'package:ams/feature/presentation/pages/theme/controller/theme_controller.dart';
import 'package:ams/feature/utils/helpers.dart';
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
        return Obx(() {
          final appBrandController = Get.find<AppBrandController>();
          final primaryColor = appBrandController.currentBrand != null
              ? hexToColor(appBrandController.currentBrand!.themeColor)
              : AppColors.blue;

          // Adjust surface color for dark mode (e.g., darken the primary color)
          final surfaceColorLight =
              primaryColor; // Use yellow (#F1B939) directly
          final surfaceColorDark =
              primaryColor.withOpacity(0.2); // Darken for contrast

          return GetMaterialApp(
            builder: (context, child) {
              final mediaQuery = MediaQuery.of(context);
              return MediaQuery(
                data: mediaQuery.copyWith(
                    textScaler: const TextScaler.linear(1.0)),
                child: child ?? const SizedBox(),
              );
            },
            debugShowCheckedModeBanner: false,
            title: "Attendance Management System",
            theme: ThemeData(
              primaryColor: primaryColor,
              colorScheme: ColorScheme.fromSeed(
                seedColor: primaryColor,
                primary: primaryColor,
                onPrimary: AppColors.onPrimary,
                secondary: AppColors.secondary,
                onSecondary: AppColors.onSecondary,
                error: AppColors.error,
                onError: AppColors.onError,
                background: AppColors.white,
                onBackground: AppColors.black,
                surface: surfaceColorLight, // Use server-provided color
                onSurface: AppColors.black,
              ),
              textSelectionTheme: const TextSelectionThemeData(
                cursorColor: AppColors.black,
                selectionColor: AppColors.grey,
                selectionHandleColor: AppColors.grey,
              ),
              scaffoldBackgroundColor: AppColors.white,
              appBarTheme: AppBarTheme(
                backgroundColor: primaryColor,
                foregroundColor: AppColors.onPrimary,
              ),
            ),
            darkTheme: ThemeData(
              primaryColor: primaryColor,
              colorScheme: ColorScheme.fromSeed(
                seedColor: primaryColor,
                brightness: Brightness.dark,
                primary: primaryColor,
                onPrimary: AppColors.onPrimary,
                secondary: AppColors.secondary,
                onSecondary: AppColors.onSecondary,
                error: AppColors.error,
                onError: AppColors.onError,
                background: Colors.grey[900]!,
                onBackground: AppColors.white,
                surface: surfaceColorDark, // Adjusted for dark mode
                onSurface: AppColors.white,
              ),
              textSelectionTheme: const TextSelectionThemeData(
                cursorColor: AppColors.white,
                selectionColor: AppColors.grey,
                selectionHandleColor: AppColors.grey,
              ),
              scaffoldBackgroundColor: Colors.grey[900]!,
              appBarTheme: AppBarTheme(
                backgroundColor: primaryColor,
                foregroundColor: AppColors.onPrimary,
              ),
            ),
            themeMode: ThemeMode.system,
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
        });
      },
    );
  }
}
