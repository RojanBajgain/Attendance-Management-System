import 'dart:developer';

import 'package:ams/feature/data/datasource/remote/api_response.dart';
import 'package:ams/feature/data/repository/reset_password_repo.dart';
import 'package:ams/feature/presentation/pages/login/login_page.dart';
import 'package:ams/feature/utils/ssnackbar_utils.dart';
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

        SSnackbarUtil.showFadeSnackbar(
          Get.context!,
          'Password reset email sent',
          SnackbarType.success,
        );
        Get.off(() => const LoginPage());
      } else {
        log("Error: ${response.message}");
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
