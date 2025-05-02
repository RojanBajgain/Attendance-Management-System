import 'dart:developer';

import 'package:ams/feature/data/datasource/remote/api_response.dart';
import 'package:ams/feature/data/repository/auth_repository_impl.dart';
import 'package:ams/feature/presentation/pages/bottom_nav/bottom_nav_page.dart';
import 'package:ams/feature/presentation/pages/login/login_page.dart';
import 'package:ams/feature/presentation/pages/login/model/login_model.dart';
import 'package:ams/feature/utils/ssnackbar_utils.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../data/datasource/remote/api_client.dart';

import 'package:local_auth/local_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthController extends GetxController {
  final AuthRepositoryImpl authRepo;
  final LocalAuthentication localAuth = LocalAuthentication();
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  final ApiClient apiClient = Get.find<ApiClient>();
  var authIsLoading = false.obs;
  var alluserData = LoginModel(access: "", refresh: "").obs;
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
        SSnackbarUtil.showSnackbar(
          'Biometrics Unavailable',
          'Your device does not support biometrics or it is not enabled.',
          SnackbarType.error,
        );
        return;
      }

      // If enabling, verify with biometrics first
      if (enabled) {
        bool authenticated = await authenticateWithBiometrics();
        if (!authenticated) {
          SSnackbarUtil.showSnackbar(
              'Authentication Failed',
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
          SSnackbarUtil.showSnackbar(
            'No Credentials',
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
        'Biometrics ' + (enabled ? 'Enabled' : 'Disabled'),
        enabled
            ? 'You can now log in using biometric authentication.'
            : 'Biometric authentication has been disabled.',
        SnackbarType.success,
      );
    } catch (e) {
      log("Error toggling biometrics: $e");
      SSnackbarUtil.showSnackbar(
        'Error',
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
        SSnackbarUtil.showSnackbar(
          'Biometrics Unavailable',
          'Your device does not support biometrics or it is not enabled.',
          SnackbarType.error,
        );
        return;
      }

      // Authenticate with biometrics
      bool authenticated = await authenticateWithBiometrics();
      if (!authenticated) {
        SSnackbarUtil.showSnackbar(
          'Authentication Failed',
          'Biometric authentication failed. Please try again.',
          SnackbarType.error,
        );
        return;
      }

      // Retrieve stored credentials
      String? email = await secureStorage.read(key: 'user_email');
      String? password = await secureStorage.read(key: 'user_password');

      if (email == null || password == null) {
        SSnackbarUtil.showSnackbar(
          'No Credentials',
          'Please log in with email and password first to enable biometric login.',
          SnackbarType.error,
        );
        return;
      }

      // Perform login with retrieved credentials
      // Remove keepMeLoggedIn parameter - always set to false
      await loginMethod(email, password, false);
    } catch (e) {
      log("Biometric login error: $e");
      SSnackbarUtil.showSnackbar(
        'Error',
        'An error occurred during biometric login.',
        SnackbarType.error,
      );
    } finally {
      authIsLoading.value = false;
    }
  }

  // Function to save credentials for biometric login
  Future<void> saveCredentialsForBiometricLogin(
      String email, String password) async {
    try {
      // Save credentials securely
      await secureStorage.write(key: 'user_email', value: email);
      await secureStorage.write(key: 'user_password', value: password);
      await secureStorage.write(key: 'biometrics_enabled', value: 'true');

      // Update preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('biometrics_enabled', true);
      biometricsEnabled.value = true;

      SSnackbarUtil.showSnackbar(
        'Biometrics Enabled',
        'You can now log in using biometric authentication.',
        SnackbarType.success,
      );
    } catch (e) {
      log("Error saving credentials for biometric login: $e");
      SSnackbarUtil.showSnackbar(
        'Error',
        'Failed to save credentials for biometric login.',
        SnackbarType.error,
      );
    }
  }

// Function to update the login method to save credentials for biometric login
  Future<void> loginMethod(
      String email, String password, bool keepMeLoggedIn) async {
    authIsLoading.value = true;
    try {
      ApiResponse<LoginModel> response = await authRepo.login(email, password);
      if (response.status == ApiStatus.SUCCESS && response.response != null) {
        log("Successfully logged in. User Data: ${response.response}");
        alluserData.value = response.response!;

        // Save tokens
        final tokens = response.response;
        if (tokens != null) {
          apiClient.saveTokens(tokens.access, tokens.refresh);
        }

        // Always save credentials for biometric login if login is successful
        // This ensures we have credentials available when biometrics are enabled later
        await secureStorage.write(key: 'user_email', value: email);
        await secureStorage.write(key: 'user_password', value: password);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        GetStorage box = GetStorage();
        box.write('profileId', alluserData.value.user?.profileId);
        await prefs.setBool('isLoggedIn', keepMeLoggedIn);

        if (keepMeLoggedIn) {
          await prefs.setString('accessToken', tokens!.access);
          await prefs.setString('refreshToken', tokens.refresh);
        }

        Get.offAll(() => const BottomNavPage());
      } else {
        log("Error: ${response.message ?? 'Login failed'}");
        SSnackbarUtil.showSnackbar(
          'Login Failed',
          'Invalid Email or Password.',
          SnackbarType.error,
        );
      }
    } catch (e) {
      log("Exception occurred: $e");
      SSnackbarUtil.showSnackbar(
        'Error',
        'Fill login details',
        SnackbarType.error,
      );
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

  // Logout
  Future<void> logoutmethod(String refreshToken, String accessToken) async {
    ApiResponse response = await authRepo.logOut(refreshToken, accessToken);
    if (response.status == ApiStatus.SUCCESS) {
      log("Successfully logout. Data: ${response.response}");
      apiClient.clearTokens();

      // Don't clear email/password credentials on logout and biometrics

      final prefs = await SharedPreferences.getInstance();
      // Save the biometrics setting before clearing
      bool biometricsEnabled = prefs.getBool('biometrics_enabled') ?? false;

      // Clear other preferences but exclude biometrics setting
      await prefs.remove('isLoggedIn');
      await prefs.remove('accessToken');
      await prefs.remove('refreshToken');
      // DO NOT use prefs.clear() as it would erase all settings

      // Restore biometrics setting
      await prefs.setBool('biometrics_enabled', biometricsEnabled);

      await Future.delayed(const Duration(seconds: 2));
      Get.offAll(() => const LoginPage());
      SSnackbarUtil.showSnackbar(
        'Logout Successful',
        response.message ?? 'Thank you for using AYATA Attendance.',
        SnackbarType.success,
      );
    } else {
      log("Error: ${response.message ?? 'logout failed'}");
      SSnackbarUtil.showSnackbar(
        'Logout Failed',
        response.message ?? 'An unexpected error occurred',
        SnackbarType.error,
      );
    }
  }

  // Change Password
  Future<void> changePasswordMethod(
      String oldPassword, String newPassword, String confirmPassword) async {
    if (newPassword != confirmPassword) {
      SSnackbarUtil.showSnackbar(
        "Password does not match",
        "Please check again",
        SnackbarType.error,
      );
      return;
    }

    String? passwordValidationMessage = _validatePassword(newPassword);
    if (passwordValidationMessage != null) {
      SSnackbarUtil.showSnackbar(
        "Invalid Password",
        passwordValidationMessage,
        SnackbarType.error,
      );

      return;
    }

    ApiResponse response = await authRepo.changePassword(
        oldPassword, newPassword, confirmPassword);

    if (response.status == ApiStatus.SUCCESS) {
      log("Successfully changed Password. Data: ${response.response}");
      Get.offAll(() => const LoginPage());
      apiClient.clearTokens();

      // Clear secure storage since password changed
      await secureStorage.delete(key: 'user_password');
      // Keep email for convenience
      // await secureStorage.delete(key: 'user_email');
      await secureStorage.write(key: 'biometrics_enabled', value: 'false');

      SSnackbarUtil.showSnackbar(
        'Password Changed Successful.',
        response.message ?? 'Please Login Again...',
        SnackbarType.success,
      );
    } else {
      log("Error: ${response.message ?? 'failed to change password'}");
      if (response.message
              ?.toLowerCase()
              .contains("old password is incorrect") ??
          false) {
        SSnackbarUtil.showSnackbar(
          'Incorrect Old Password',
          'Please enter the correct old password',
          SnackbarType.error,
        );
      } else {
        SSnackbarUtil.showSnackbar(
          'Failed to Change Password',
          'The password is too short \nPassword is similar to the email',
          SnackbarType.error,
        );
      }
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
