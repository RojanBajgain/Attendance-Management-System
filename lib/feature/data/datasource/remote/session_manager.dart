import 'dart:developer';

import 'package:ams/feature/presentation/pages/landing/landing_page.dart';
import 'package:ams/feature/presentation/pages/login/controller/login_controller.dart';
import 'package:ams/feature/presentation/pages/login/login_page.dart';
import 'package:ams/feature/utils/ssnackbar_utils.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static bool isLoggingOut = false;

  // static Future<void> handleSessionExpired() async {
  //   if (isLoggingOut) return;

  //   isLoggingOut = true;
  //   // Get.find<AuthController>().logoutmethod(true);
  //   await const FlutterSecureStorage().deleteAll();
  //   print('dsdsd');

  //   SSnackbarUtil.showFadeSnackbar(
  //     Get.context!,
  //     'Your session has expired. Please login again...',
  //     SnackbarType.warning,
  //   );

  //   Future.delayed(Duration(seconds: 3), () {
  //     isLoggingOut = false;
  //   });
  // }

  static Future<void> handleSessionExpired() async {
    if (isLoggingOut) return;

    isLoggingOut = true;

    try {
      await _clearAllUserData();

      SSnackbarUtil.showFadeSnackbar(
        Get.context!,
        'Your session has expired or the server is unreachable. Please login again.',
        SnackbarType.warning,
      );

      await Future.delayed(const Duration(milliseconds: 500));
      Get.offAll(
        () => const LoginPage(),
        transition: Transition.rightToLeft,
        // duration: const Duration(milliseconds: 300),
      );
    } catch (e) {
      log("Error handling session expiry: $e");
    } finally {
      Future.delayed(const Duration(seconds: 3), () {
        isLoggingOut = false;
      });
    }
  }

  // Method to handle logout (called from AuthController)
  // static Future<void> handleLogout() async {
  //   if (isLoggingOut) return;

  //   // log("Handling logout...");
  //   isLoggingOut = true;

  //   try {
  //     // Clear all stored data
  //     await _clearAllUserData();

  //     // Navigate to login page
  //     Get.offAll(
  //       () => const LoginPage(),
  //       transition: Transition.rightToLeft,
  //       duration: const Duration(milliseconds: 300),
  //     );
  //   } catch (e) {
  //     // log("Error handling logout: $e");
  //   } finally {
  //     isLoggingOut = false;
  //   }
  // }

  // Private method to clear all user data
  static Future<void> _clearAllUserData() async {
    try {
      const secureStorage = FlutterSecureStorage();
      final prefs = await SharedPreferences.getInstance();

      // Save biometrics setting before clearing (if needed)
      bool biometricsEnabled = prefs.getBool('biometrics_enabled') ?? false;

      // Clear SharedPreferences (except biometrics)
      await prefs.remove('isLoggedIn');
      await prefs.remove('accessToken');
      await prefs.remove('refreshToken');
      await prefs.remove('userData');

      // Clear FlutterSecureStorage tokens
      await secureStorage.delete(key: 'access_token');
      await secureStorage.delete(key: 'refresh_token');

      // Restore biometrics setting if it was enabled
      if (biometricsEnabled) {
        await prefs.setBool('biometrics_enabled', biometricsEnabled);
      }

      // Clear API client tokens if available
      try {
        // final apiClient = Get.find();
        // if (apiClient != null && apiClient.hasMethod('clearTokens')) {
        //   apiClient.clearTokens();
        // }
      } catch (e) {
        // log("API client not found or error clearing tokens: $e");
      }

      // log("All user data cleared successfully");
    } catch (e) {
      // log("Error clearing user data: $e");
    }
  }

  // Method to check if user should remain logged in
  // static Future<bool> shouldStayLoggedIn() async {
  //   try {
  //     const secureStorage = FlutterSecureStorage();
  //     final prefs = await SharedPreferences.getInstance();

  //     final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  //     final accessToken = await secureStorage.read(key: 'access_token');
  //     final refreshToken = await secureStorage.read(key: 'refresh_token');

  //     // Check backup location if secure storage is empty
  //     if (accessToken == null || refreshToken == null) {
  //       final backupAccess = prefs.getString('accessToken');
  //       final backupRefresh = prefs.getString('refreshToken');

  //       if (backupAccess != null && backupRefresh != null) {
  //         // Sync back to secure storage
  //         await secureStorage.write(key: 'access_token', value: backupAccess);
  //         await secureStorage.write(key: 'refresh_token', value: backupRefresh);
  //         return isLoggedIn;
  //       }
  //     }

  //     return isLoggedIn && accessToken != null && refreshToken != null;
  //   } catch (e) {
  //     // log("Error checking login status: $e");
  //     return false;
  //   }
  // }

  // // Method to validate tokens (you can add token validation logic here)
  // static Future<bool> validateTokens() async {
  //   try {
  //     // Add your token validation logic here
  //     // For example, check token expiry or make a test API call

  //     const secureStorage = FlutterSecureStorage();
  //     final accessToken = await secureStorage.read(key: 'access_token');

  //     if (accessToken == null || accessToken.isEmpty) {
  //       return false;
  //     }

  //     // Add JWT token validation logic here if needed
  //     // For now, just check if token exists
  //     return true;
  //   } catch (e) {
  //     // log("Error validating tokens: $e");
  //     return false;
  //   }
  // }
}
