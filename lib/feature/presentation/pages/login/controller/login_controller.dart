import 'dart:convert';
import 'dart:developer';

import 'package:ams/feature/data/datasource/remote/api_response.dart';
import 'package:ams/feature/data/repository/auth_repository_impl.dart';
import 'package:ams/feature/presentation/pages/organization/pages/organization_page.dart';
import 'package:ams/feature/presentation/pages/bottom_nav/bottom_nav_page.dart';
import 'package:ams/feature/presentation/pages/login/login_page.dart';
import 'package:ams/feature/presentation/pages/login/model/login_model.dart';
import 'package:ams/feature/presentation/widget/loading_animation_widget.dart';
import 'package:ams/feature/utils/ssnackbar_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../../data/datasource/remote/api_client.dart';

class AuthController extends GetxController {
  final AuthRepositoryImpl authRepo;
  final ApiClient apiClient = Get.find<ApiClient>();
  var authIsLoading = false.obs;
  var alluserData = LoginModel(access: "", refresh: "", organization: []).obs;

  AuthController({required this.authRepo});

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  Future<void> loginMethod(
      String email, String password, String role, bool keepMeLoggedIn) async {
    if (authIsLoading.value) return;

    authIsLoading.value = true;

    try {
      ApiResponse<LoginModel> response =
          await authRepo.login(email, password, role);
      if (response.status == ApiStatus.SUCCESS && response.response != null) {
        log("Successfully logged in. User Data: ${response.response}");

        // Clear previous user data
        alluserData.value = LoginModel(access: "", refresh: "");

        // Set new user data
        alluserData.value = response.response!;

        // Save tokens using ApiClient's secure storage
        final tokens = response.response;
        if (tokens != null) {
          // Save tokens (apiKey will be set after organization selection)
          await apiClient.saveTokens(tokens.access, tokens.refresh, '');
        }

        SharedPreferences prefs = await SharedPreferences.getInstance();

        // Store user info in shared preferences for persistence
        if (alluserData.value.user != null) {
          await prefs.setString(
              'userData', json.encode(alluserData.value.toJson()));
        }

        // Handle keepMeLoggedIn
        await prefs.setBool('isLoggedIn', keepMeLoggedIn);

        // Check number of organizations
        final organizations = alluserData.value.organization ?? [];
        await Future.delayed(const Duration(milliseconds: 50));

        if (organizations.isEmpty) {
          Get.back();
          SSnackbarUtil.showFadeSnackbar(
            Get.context!,
            'No departments found for this user. Please contact your Admin.',
            SnackbarType.error,
          );
          return;
        }

        // Pass organizations to OrganizationPage
        Get.offAll(
          () => const OrganizationPage(),
          arguments: organizations.map((org) => org.toJson()).toList(),
          transition: Transition.rightToLeft,
        );
      } else {
        Get.back();
        SSnackbarUtil.showFadeSnackbar(
          Get.context!,
          'Invalid Email or Password.',
          SnackbarType.error,
        );
      }
    } catch (e) {
      Get.back();
      log("Exception occurred: $e");
      SSnackbarUtil.showFadeSnackbar(
        Get.context!,
        'An error occurred. Please try again.',
        SnackbarType.error,
      );
    } finally {
      if (Get.isDialogOpen == true) {
        Get.back(); // Ensure the dialog is closed
      }
      authIsLoading.value = false;
    }
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (!isLoggedIn) {
      // Clear any existing tokens if user is not logged in
      await apiClient.clearTokens();
      return;
    }

    String? userDataJson = prefs.getString('userData');
    if (userDataJson != null && userDataJson.isNotEmpty) {
      try {
        Map<String, dynamic> userDataMap = json.decode(userDataJson);
        alluserData.value = LoginModel.fromJson(userDataMap);

        // Tokens are now automatically retrieved from secure storage by ApiClient
        // No need to manually restore them here

        // Restore user_id
        GetStorage box = GetStorage();
        if (alluserData.value.user != null) {
          log("Restoring user_id: ${alluserData.value.user}");
          box.write('user_id', alluserData.value.user);
        }

        // Clear stale profile_id or profileId
        box.remove('profile_id');
        box.remove('profileId');
      } catch (e) {
        log("Error restoring user data: $e");
        // Clear tokens if there's an error
        await apiClient.clearTokens();
        return;
      }
    } else {
      // No user data found, clear tokens
      await apiClient.clearTokens();
      return;
    }

    await Future.delayed(const Duration(milliseconds: 300));
    Get.offAll(() => BottomNavPage());
  }

  // Logout
  Future<void> localLogout() async {
    try {
      await apiClient.clearTokens();

      // Clear SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('isLoggedIn');
      await prefs.remove('userData');

      // Clear GetStorage
      GetStorage box = GetStorage();
      box.remove('selectedOrganization');
      box.remove('profile_id');
      box.remove('profileId');
      box.remove('organization_name');
      box.remove('user_profile');
      box.remove('user_id');

      alluserData.value = LoginModel(access: "", refresh: "", organization: []);

      Get.offAll(() => const LoginPage());

      // Show success message
      SSnackbarUtil.showFadeSnackbar(
        Get.context!,
        'You have been logged out successfully.',
        SnackbarType.success,
      );
    } catch (e) {
      log("Error during local logout: $e");

      // Even if there's an error, still navigate to login for security
      Get.offAll(() => const LoginPage());

      SSnackbarUtil.showFadeSnackbar(
        Get.context!,
        'Logged out with some cleanup issues.',
        SnackbarType.warning,
      );
    }
  }

  // Change Password
  Future<void> changePasswordMethod(
    String oldPassword,
    String newPassword,
    String confirmPassword,
  ) async {
    // Validate password match
    if (newPassword != confirmPassword) {
      SSnackbarUtil.showFadeSnackbar(
        Get.context!,
        "New password and confirmation doesnot match",
        SnackbarType.error,
      );
      return;
    }

    // Validate password strength
    final passwordValidation = _validatePassword(newPassword);
    if (passwordValidation != null) {
      SSnackbarUtil.showFadeSnackbar(
        Get.context!,
        passwordValidation,
        SnackbarType.error,
      );
      return;
    }

    // Show loading
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      final response = await authRepo.changePassword(
        oldPassword,
        newPassword,
        confirmPassword,
      );

      Get.back(); // Close loading

      if (response.status == ApiStatus.SUCCESS ||
          (response.status == ApiStatus.ERROR &&
              response.message
                      ?.contains('Unable to change password at this time') ==
                  true)) {
        // Success case - clear tokens and redirect to login
        await apiClient.clearTokens();

        SSnackbarUtil.showFadeSnackbar(
          Get.context!,
          'Password changed successfully. Please login again to continue.',
          SnackbarType.success,
        );

        Get.offAll(() => const LoginPage());
      } else {
        // Handle different error cases
        String errorMessage = response.message ?? 'Failed to change password';

        if (errorMessage.toLowerCase().contains('old password')) {
          errorMessage = 'Incorrect current password';
        } else if (errorMessage.toLowerCase().contains('too common')) {
          errorMessage = 'Password is too common';
        } else if (errorMessage.toLowerCase().contains('too short')) {
          errorMessage = 'Password must be at least 8 characters';
        }

        SSnackbarUtil.showFadeSnackbar(
          Get.context!,
          errorMessage,
          SnackbarType.error,
        );
      }
    } catch (e) {
      Get.back();
      SSnackbarUtil.showFadeSnackbar(
        Get.context!,
        'An unexpected error occurred: ${e.toString()}',
        SnackbarType.error,
      );
    }
  }

  String? _validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password cannot be empty.';
    }
    if (password.length < 8) {
      return 'Password must be at least 8 characters long.';
    }
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return 'Password must contain at least one uppercase letter.';
    }
    if (!RegExp(r'[0-9]').hasMatch(password)) {
      return 'Password must contain at least one number.';
    }
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
      return 'Password must contain at least one special character.';
    }
    return null;
  }
}
