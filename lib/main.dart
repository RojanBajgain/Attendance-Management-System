import 'package:ams/landing/landing_page.dart';
import 'package:ams/utils/constants.dart';
import 'package:ams/utils/providers.dart';
import 'package:ams/view_models/theme/theme_view_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: Consumer<ThemeProvider>(
        builder: (context, ThemeProvider notifier, Widget? child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: Constants.appName,
            theme: themeData(
              notifier.dark ? Constants.darkTheme : Constants.lightTheme,
            ),
            home: const LandingPage(),
          );
        },
      ),
    );
  }
}

ThemeData themeData(ThemeData theme) {
  return theme.copyWith(
    textTheme: GoogleFonts.nunitoTextTheme(
      theme.textTheme,
    ),
  );
}
