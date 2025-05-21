import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  var currentThemeMode = ThemeMode.system.obs;
  final _storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    _loadThemeMode();
  }

  void _loadThemeMode() {
    final themeString = _storage.read('themeMode') ?? 'system';
    ThemeMode mode;
    switch (themeString) {
      case 'light':
        mode = ThemeMode.light;
        break;
      case 'dark':
        mode = ThemeMode.dark;
        break;
      case 'system':
      default:
        mode = ThemeMode.system;
        break;
    }
    currentThemeMode.value = mode;
    Get.changeThemeMode(mode);
  }

  void changeThemeMode(ThemeMode mode) {
    currentThemeMode.value = mode;
    Get.changeThemeMode(mode);
    String themeString;
    switch (mode) {
      case ThemeMode.light:
        themeString = 'light';
        break;
      case ThemeMode.dark:
        themeString = 'dark';
        break;
      case ThemeMode.system:
      default:
        themeString = 'system';
        break;
    }
    _storage.write('themeMode', themeString);
  }
}
