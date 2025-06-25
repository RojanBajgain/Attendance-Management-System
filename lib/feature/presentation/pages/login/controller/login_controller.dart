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

import 'package:local_auth/local_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthController extends GetxController {
  final AuthRepositoryImpl authRepo;
  final LocalAuthentication localAuth = LocalAuthentication();
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  final ApiClient apiClient = Get.find<ApiClient>();
  var authIsLoading = false.obs;
  var alluserData = LoginModel(access: "", refresh: "", organization: []).obs;
  var biometricsEnabled = false.obs;

  AuthController({required this.authRepo});

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
    checkBiometricsStatus();
  }

  // Check if biometrics are enabled
  Future<void> checkBiometricsStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      bool prefsBiometrics = prefs.getBool('biometrics_enabled') ?? false;
      String? secureBiometrics =
          await secureStorage.read(key: 'biometrics_enabled');
      bool secureBiometricsEnabled = secureBiometrics == 'true';

      // Make sure both storage locations have the same value
      if (prefsBiometrics != secureBiometricsEnabled) {
        // Synchronize them - prefer the SharedPreferences value as the source of truth
        await secureStorage.write(
            key: 'biometrics_enabled',
            value: prefsBiometrics ? 'true' : 'false');
      }

      biometricsEnabled.value = prefsBiometrics;
    } catch (e) {
      log("Error checking biometrics status: $e");
      biometricsEnabled.value = false;
    }
  }

  // Enable or disable biometrics
  Future<void> toggleBiometrics(bool enabled) async {
    try {
      // Check if biometrics are available on the device
      bool canAuthenticate = await canUseBiometrics();
      if (!canAuthenticate) {
        SSnackbarUtil.showFadeSnackbar(
          Get.context!,
          'Your device does not support biometrics or it is not enabled.',
          SnackbarType.error,
        );
        return;
      }

      // If enabling, verify with biometrics first
      if (enabled) {
        bool authenticated = await authenticateWithBiometrics();
        if (!authenticated) {
          SSnackbarUtil.showFadeSnackbar(
              Get.context!,
              'Biometric authentication failed. Please try again.',
              SnackbarType.error);
          return;
        }

        // Check if we have credentials stored
        String? email = await secureStorage.read(key: 'user_email');
        String? password = await secureStorage.read(key: 'user_password');

        if (email == null ||
            email.isEmpty ||
            password == null ||
            password.isEmpty) {
          SSnackbarUtil.showFadeSnackbar(
            Get.context!,
            'Please log in with email and password first to enable biometric login.',
            SnackbarType.warning,
          );
          return;
        }
      }

      // Save the setting in BOTH locations
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('biometrics_enabled', enabled);
      await secureStorage.write(
          key: 'biometrics_enabled', value: enabled ? 'true' : 'false');
      biometricsEnabled.value = enabled;

      SSnackbarUtil.showSnackbar(
        'Biometrics ${enabled ? 'Enabled' : 'Disabled'}',
        enabled
            ? 'You can now log in using biometric authentication.'
            : 'Biometric authentication has been disabled.',
        SnackbarType.success,
      );
    } catch (e) {
      log("Error toggling biometrics: $e");
      SSnackbarUtil.showFadeSnackbar(
        Get.context!,
        'Failed to update biometric settings.',
        SnackbarType.error,
      );
    }
  }

  // Check if saved credentials exist for biometric login
  Future<bool> hasSavedCredentials() async {
    try {
      String? email = await secureStorage.read(key: 'user_email');
      String? password = await secureStorage.read(key: 'user_password');

      // Check if we have saved credentials, regardless of login status
      return email != null &&
          email.isNotEmpty &&
          password != null &&
          password.isNotEmpty;
    } catch (e) {
      log("Error checking saved credentials: $e");
      return false;
    }
  }

  // Check if biometric authentication is available
  Future<bool> canUseBiometrics() async {
    try {
      return await localAuth.canCheckBiometrics &&
          await localAuth.isDeviceSupported();
    } catch (e) {
      log("Error checking biometrics: $e");
      return false;
    }
  }

  // Authenticate using biometrics
  Future<bool> authenticateWithBiometrics() async {
    try {
      return await localAuth.authenticate(
        localizedReason: 'Scan your fingerprint to log in',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } catch (e) {
      log("Biometric authentication error: $e");
      return false;
    }
  }

  // Login with biometrics
  Future<void> loginWithBiometrics() async {
    authIsLoading.value = true;
    try {
      // Check if biometrics are available
      bool canAuthenticate = await canUseBiometrics();
      if (!canAuthenticate) {
        SSnackbarUtil.showFadeSnackbar(
          Get.context!,
          'Your device does not support biometrics or it is not enabled.',
          SnackbarType.error,
        );
        return;
      }

      // Authenticate with biometrics
      bool authenticated = await authenticateWithBiometrics();
      if (!authenticated) {
        SSnackbarUtil.showFadeSnackbar(
          Get.context!,
          'Biometric authentication failed. Please try again.',
          SnackbarType.error,
        );
        return;
      }

      // Retrieve stored credentials
      String? email = await secureStorage.read(key: 'user_email');
      String? password = await secureStorage.read(key: 'user_password');
      String? role =
          await secureStorage.read(key: 'user_role'); // Retrieve role

      if (email == null || password == null || role == null) {
        SSnackbarUtil.showFadeSnackbar(
          Get.context!,
          'Please log in with email, password, and role first to enable biometric login.',
          SnackbarType.error,
        );
        return;
      }

      // Perform login with retrieved credentials
      await loginMethod(email, password, role, true);
    } catch (e) {
      log("Biometric login error: $e");
      SSnackbarUtil.showFadeSnackbar(
        Get.context!,
        'An error occurred during biometric login.',
        SnackbarType.error,
      );
    } finally {
      authIsLoading.value = false;
    }
  }

  // Function to save credentials for biometric login
  Future<void> saveCredentialsForBiometricLogin(
      String email, String password, String role) async {
    try {
      // Save credentials securely
      await secureStorage.write(key: 'user_email', value: email);
      await secureStorage.write(key: 'user_password', value: password);
      await secureStorage.write(key: 'user_role', value: role); // Save role
      await secureStorage.write(key: 'biometrics_enabled', value: 'true');

      // Update preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('biometrics_enabled', true);
      biometricsEnabled.value = true;

      SSnackbarUtil.showFadeSnackbar(
        Get.context!,
        'You can now log in using biometric authentication.',
        SnackbarType.success,
      );
    } catch (e) {
      log("Error saving credentials for biometric login: $e");
      SSnackbarUtil.showFadeSnackbar(
        Get.context!,
        'Failed to save credentials for biometric login.',
        SnackbarType.error,
      );
    }
  }

  Future<void> loginMethod(
      String email, String password, String role, bool keepMeLoggedIn) async {
    if (authIsLoading.value) return;

    authIsLoading.value = true;
    // Get.dialog(
    //   const CombinedAnimatedDialog(),
    //   barrierDismissible: false,
    // );

    try {
      ApiResponse<LoginModel> response =
          await authRepo.login(email, password, role);
      if (response.status == ApiStatus.SUCCESS && response.response != null) {
        log("Successfully logged in. User Data: ${response.response}");

        // Clear previous user data
        alluserData.value = LoginModel(access: "", refresh: "");

        // Set new user data
        alluserData.value = response.response!;

        // Save tokens
        final tokens = response.response;
        if (tokens != null) {
          // Save tokens (apiKey will be set after organization selection)
          apiClient.saveTokens(tokens.access, tokens.refresh, '');
        }

        // Save credentials for biometric login
        await secureStorage.write(key: 'user_email', value: email);
        await secureStorage.write(key: 'user_password', value: password);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        // GetStorage box = GetStorage();

        // Store user info in shared preferences for persistence
        if (alluserData.value.user != null) {
          await prefs.setString(
              'userData', json.encode(alluserData.value.toJson()));
        }

        // Handle keepMeLoggedIn
        await prefs.setBool('isLoggedIn', keepMeLoggedIn);
        if (keepMeLoggedIn) {
          await prefs.setString('accessToken', tokens!.access);
          await prefs.setString('refreshToken', tokens.refresh);
        }

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

        // SSnackbarUtil.showFadeSnackbar(
        //   Get.context!,

        //   "Welcome",
        //   SnackbarType.success,
        //   // duration: 2,
        // );
      } else {
        Get.back();
        // log("Error: ${response.message ?? 'Login failed'}");
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

    if (isLoggedIn) {
      String? userDataJson = prefs.getString('userData');
      if (userDataJson != null && userDataJson.isNotEmpty) {
        try {
          Map<String, dynamic> userDataMap = json.decode(userDataJson);
          alluserData.value = LoginModel.fromJson(userDataMap);

          // Restore tokens to API client
          final accessToken = prefs.getString('accessToken');
          final refreshToken = prefs.getString('refreshToken');
          if (accessToken != null && refreshToken != null) {
            apiClient.saveTokens(
                accessToken, refreshToken, apiClient.organization);
          }

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
        }
      }

      await Future.delayed(const Duration(milliseconds: 300));
      Get.offAll(() => const BottomNavPage());
    }
  }

  // Logout
  Future<void> logoutmethod(String refreshToken, String accessToken) async {
    // Get the organization value from apiClient
    String organization = apiClient.organization;

    log("Organization API Key: $organization");

    // Call the updated logOut method with the organization parameter
    ApiResponse response =
        await authRepo.logOut(refreshToken, accessToken, organization);
    if (response.status == ApiStatus.SUCCESS) {
      log("Successfully logged out. Data: ${response.response}");
      apiClient.clearTokens();

      final prefs = await SharedPreferences.getInstance();
      // Save the biometrics setting before clearing
      bool biometricsEnabled = prefs.getBool('biometrics_enabled') ?? false;

      // Clear other preferences but exclude biometrics setting
      await prefs.remove('isLoggedIn');
      await prefs.remove('accessToken');
      await prefs.remove('refreshToken');
      await prefs.remove('userData');

      // Restore biometrics setting
      await prefs.setBool('biometrics_enabled', biometricsEnabled);

      GetStorage box = GetStorage();
      box.remove('selectedOrganization');
      box.remove('profile_id');
      box.remove('organization_name');
      box.remove('user_profile');

      // Clear user data from memory
      alluserData.value = LoginModel(access: "", refresh: "");

      await Future.delayed(const Duration(seconds: 2));
      Get.offAll(() => const LoginPage());
      SSnackbarUtil.showFadeSnackbar(
        Get.context!,
        response.message ?? 'You have successfully logged out.',
        SnackbarType.success,
      );
    } else {
      log("Error: ${response.message ?? 'logout failed'}");
      String errorMessage = response.message ?? 'An unexpected error occurred';
      if (response.message?.toLowerCase().contains('organization') ?? false) {
        errorMessage =
            'Organization information is missing. Please log in again.';
      }
      SSnackbarUtil.showFadeSnackbar(
        Get.context!,
        errorMessage,
        SnackbarType.error,
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
        // Success case
        apiClient.clearTokens();
        await secureStorage.delete(key: 'user_password');
        await secureStorage.write(key: 'biometrics_enabled', value: 'false');

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
