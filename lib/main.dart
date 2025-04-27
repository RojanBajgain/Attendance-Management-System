import 'package:ams/app.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ams/services/dependency.dart' as depp;
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await depp.init();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(App(isLoggedIn: isLoggedIn));

  await FilePicker.platform.clearTemporaryFiles();
}

/* 
  import 'package:ams/app.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ams/services/dependency.dart' as depp;
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await depp.init();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  bool keepMeLoggedIn = prefs.getBool('keepMeLoggedIn') ?? false;

  // Only consider user as logged in if both flags are true AND we have tokens
  bool hasValidSession = isLoggedIn &&
      (keepMeLoggedIn &&
          prefs.getString('access_token')?.isNotEmpty == true &&
          prefs.getString('refresh_token')?.isNotEmpty == true);

  runApp(App(isLoggedIn: hasValidSession));

  await FilePicker.platform.clearTemporaryFiles();
}

 */
