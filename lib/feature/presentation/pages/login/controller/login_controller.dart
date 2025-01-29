import 'dart:developer';

import 'package:ams/feature/data/datasource/remote/api_response.dart';
import 'package:ams/feature/data/repository/auth_repository_impl.dart';
import 'package:ams/feature/presentation/pages/bottom_nav/bottom_nav_page.dart';
import 'package:ams/feature/presentation/pages/login/login_page.dart';
import 'package:ams/feature/presentation/pages/login/model/login_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../data/datasource/remote/api_client.dart';

class AuthController extends GetxController {
  final AuthRepositoryImpl authRepo;

  AuthController({required this.authRepo});
  final apiClient = Get.find<ApiClient>();
  var authIsLoading = false.obs;
  var alluserData = LoginModel(access: "", refresh: "").obs;

//LOGIN
  Future<void> loginMethod(String email, String password) async {
    authIsLoading.value = true;
    try {
      ApiResponse<LoginModel> response = await authRepo.login(email, password);

      if (response.status == ApiStatus.SUCCESS && response.response != null) {
        log("Successfully logged in. User Data: ${response.response}");
        alluserData.value = response.response!;

        // Save the token
        // final tokens = response.response;
        // if (tokens != null) {
        //   apiClient.saveTokens(tokens.access, tokens.refresh);
        // }

        final accessToken = response.response!.access;
        final refreshToken = response.response!.refresh;

        // Save both token
        apiClient.saveTokens(accessToken, refreshToken);

        Get.to(() => const BottomNavPage());
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

  // LOGOUT
/*   Future<void> logoutmethod() async {
    final prefs = await SharedPreferences.getInstance();

    // Retrieve the refresh token from storage
    final refreshToken = prefs.getString('refresh_token') ?? '';

    // Retrieve the access token from storage (to use in the Authorization header)
    final accessToken = prefs.getString('access_token') ?? '';

    // Check if tokens are available
    if (refreshToken.isEmpty || accessToken.isEmpty) {
      Get.snackbar(
        'Logout Failed',
        'Tokens are missing. Please log in again.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Prepare the logout request
    final response =
        await authRepo.logOut(refreshToken, accessToken); // Pass both tokens

    if (response.status == ApiStatus.SUCCESS) {
      // Clear tokens after successful logout
      prefs.clear();
      Get.to(() => const LoginPage()); // Navigate to Login page
      Get.snackbar(
        'Logout Successful',
        response.message ?? 'Logged out successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      Get.snackbar(
        'Logout Failed',
        response.message ?? 'An error occurred during logout',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  } */
}
