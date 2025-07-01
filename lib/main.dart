import 'package:ams/app.dart';
import 'package:ams/feature/domain/model/environment.dart';
import 'package:ams/feature/presentation/pages/offline_page/controller/connectivity_services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ams/services/dependency.dart' as depp;
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  await dotenv.load(fileName: Environment.fileName);

  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await depp.init();

  final offlineController = Get.put(OfflineController());

  // Wait for initial connectivity check to complete
  await offlineController.initConnectivity();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(
    App(isLoggedIn: isLoggedIn),
  );

  // Handle initial navigation after app starts
  WidgetsBinding.instance.addPostFrameCallback((_) {
    offlineController.handleInitialNavigation();
  });

  await FilePicker.platform.clearTemporaryFiles();
}
