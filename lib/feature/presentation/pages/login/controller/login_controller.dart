import 'dart:developer';

import 'package:ams/feature/data/datasource/remote/api_response.dart';
import 'package:ams/feature/data/repository/auth_repository_impl.dart';
import 'package:ams/feature/presentation/pages/bottom_nav/bottom_nav_page.dart';
import 'package:ams/feature/presentation/pages/login/login_page.dart';
import 'package:ams/feature/presentation/pages/login/model/login_model.dart';
import 'package:clock_loader/clock_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../data/datasource/remote/api_client.dart';

class AuthController extends GetxController {
  final AuthRepositoryImpl authRepo;

  AuthController({required this.authRepo});
  final apiClient = Get.find<ApiClient>();
  var authIsLoading = false.obs;
  var alluserData = LoginModel(access: "", refresh: "").obs;

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

//LOGIN
  Future<void> loginMethod(
      String email, String password, bool keepMeLoggedIn) async {
    authIsLoading.value = true;
    try {
      ApiResponse<LoginModel> response = await authRepo.login(email, password);

      if (response.status == ApiStatus.SUCCESS && response.response != null) {
        log("Successfully logged in. User Data: ${response.response}");
        alluserData.value = response.response!;

        // Save the token
        final tokens = response.response;
        if (tokens != null) {
          apiClient.saveTokens(tokens.access, tokens.refresh);
        }

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', keepMeLoggedIn);

        if (keepMeLoggedIn) {
          await prefs.setString('accessToken', tokens!.access);
          await prefs.setString('refreshToken', tokens.refresh);
        }

        // Show loading dialog before navigation
        Get.dialog(
          Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
                color: Colors.white, size: 80),
          ),
          barrierDismissible: false,
        );

        await Future.delayed(const Duration(seconds: 3));

        Get.offAll(() => const BottomNavPage());
      } else {
        log("Error: ${response.message ?? 'Login failed'}");
        Get.snackbar(
          'Login Failed',
          'Invalid Email or Password.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      log("Exception occurred: $e");
      Get.snackbar('Error', 'Fill login details',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      authIsLoading.value = false;
    }
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      await Future.delayed(const Duration(milliseconds: 300));
      Get.offAll(() => const BottomNavPage());
    }
  }

//REGISTER
  /* Future<void> registerMethod(String identity, String password,
      String confirmPassword, String collegeName) async {
    ApiResponse response = await authRepo.register(
        identity, password, confirmPassword, collegeName);

    if (response.status == ApiStatus.SUCCESS) {
      log("Successfully logged in. User Data: ${response.response}");
      Get.off(() => DashboardPage());
    } else {
      log("Error: ${response.message ?? 'register failed'}");
      Get.snackbar(
        'Login Failed',
        response.message ?? 'An unexpected error occurred',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  } */

//LOGOUT
  Future<void> logoutmethod(String refreshToken, String accessToken) async {
    ApiResponse response = await authRepo.logOut(refreshToken, accessToken);
    if (response.status == ApiStatus.SUCCESS) {
      log("Successfully logout.  Data: ${response.response}");
      // apiClient.clearTokens();

      // Clear tokens in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      log("Access Token: ${prefs.getString('access_token')}");
      log("Refresh Token: ${prefs.getString('refresh_token')}");
      await prefs.clear();

      // Clear tokens in app memory
      apiClient.clearTokens();

      // Get.dialog(
      //   Center(
      //     child: LoadingAnimationWidget.inkDrop(color: Colors.white, size: 50),
      //   ),
      //   barrierDismissible: false, // Prevent closing before transition,
      // );

      // Wait a bit for animation effect before navigation
      await Future.delayed(const Duration(seconds: 2));

      Get.offAll(() => const LoginPage());
      Get.snackbar(
        'Logout Successful',
        response.message ?? 'Thank you for using AYATA Attendence.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      log("Error: ${response.message ?? 'logout failed'}");
      Get.snackbar(
        'logout Failed',
        response.message ?? 'An unexpected error occurred',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

// Change Password
  Future<void> changePasswordmethod(
      String oldPassword, String newPassword, String confirmPassword) async {
    if (newPassword != confirmPassword) {
      Get.snackbar(
        "Password does not match",
        "Please check again",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
      );
      return;
    }
    if (newPassword != confirmPassword) {
      Get.snackbar(
        "Password does not match",
        "Please check again",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
      );
    }
    ApiResponse response = await authRepo.changePassword(
        oldPassword, newPassword, confirmPassword);
    if (response.status == ApiStatus.SUCCESS) {
      log("Successfully changed Password.  Data: ${response.response}");

      Get.offAll(() => const LoginPage());
      apiClient.clearTokens();

      Get.snackbar(
        'Password Changed Successful.',
        response.message ?? 'Please Login Again...',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      log("Error: ${response.message ?? 'failed to change password'}");
      if (response.message
              ?.toLowerCase()
              .contains("old password is incorrect") ??
          false) {
        Get.snackbar(
          'Old Password Incorrect',
          'Please enter the correct old password',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
        );
      } else {
        // Get.snackbar(
        //   'Failed to Change Password',
        //   response.message ?? 'An unexpected error occurred',
        //   snackPosition: SnackPosition.BOTTOM,
        //   backgroundColor: Colors.red,
        // );
      }
    }
  }
}
