import 'package:ams/config/resources/app_theme.dart';
import 'package:ams/feature/presentation/pages/landing/landing_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (context, orientation, screemType) {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Attendence Management System",
        themeMode: ThemeMode.system,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        home: const LandingPage(),
      );
    });
  }
}
