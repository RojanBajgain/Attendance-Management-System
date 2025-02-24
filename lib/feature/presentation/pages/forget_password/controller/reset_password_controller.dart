import 'dart:developer';

import 'package:ams/feature/data/datasource/remote/api_response.dart';
import 'package:ams/feature/data/repository/reset_password_repo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPasswordController extends GetxController {
  final ResetPasswordRepo resetpasswordrepo;

  ResetPasswordController({required this.resetpasswordrepo});

  Future<void> resetpassword({
    required String email,
  }) async {
    try {
      ApiResponse response = await resetpasswordrepo.resetpassword(email);

      if (response.status == ApiStatus.SUCCESS && response.response != null) {
        log("Fetched reset password data: ${response.response}");

        Get.back();

        Get.snackbar(
          'Reset Password',
          response.message ??
              'Password Reset has been successfully posted, Please check yoyr mail',
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
          colorText: Colors.white,
          backgroundColor: Colors.green,
        );
      } else {
        log("Error: ${response.message}");
        Get.snackbar(
          'Server Error',
          'Failed to post password reset. Please try again later',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
          colorText: Colors.white,
          backgroundColor: Colors.redAccent,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching password reset data: $e");
      }
      Get.snackbar(
        'Error',
        'An unexpected error occurred: $e',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
    }
  }
}
