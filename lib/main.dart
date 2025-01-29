import 'package:ams/app.dart';
import 'package:ams/feature/presentation/pages/dashboard/widget/time_manager.dart';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ams/services/dependency.dart' as depp;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await depp.init();
  await TimerManager().loadState();

  runApp(const App());
}
