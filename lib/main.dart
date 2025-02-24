import 'package:ams/app.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ams/services/dependency.dart' as depp;
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await depp.init();
  // AppSettings.openAppSettings();

  // Check login status before starting the app
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(App(isLoggedIn: isLoggedIn));
}
