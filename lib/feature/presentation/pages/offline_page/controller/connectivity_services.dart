import 'dart:async';

import 'package:ams/feature/presentation/pages/bottom_nav/bottom_nav_page.dart';
import 'package:ams/feature/presentation/pages/login/login_page.dart';
import 'package:ams/feature/presentation/pages/offline_page/page/offline_page.dart';
import 'package:ams/feature/presentation/pages/organization/pages/organization_page.dart';
import 'package:ams/feature/utils/ssnackbar_utils.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OfflineController extends GetxController {
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  var isConnected = true.obs;
  var isChecking = false.obs;
  final storage = GetStorage();

  Timer? _debounce;
  bool _isInitialized = false;

  @override
  void onInit() {
    super.onInit();
    // Don't auto-initialize here since we'll do it manually in main()
  }

  Future<void> initConnectivity() async {
    if (_isInitialized) return; // Prevent multiple initializations

    isChecking.value = true;
    try {
      final result = await _connectivity.checkConnectivity();
      _connectionStatus = result;
      // Check if the list contains ConnectivityResult.none
      isConnected.value = !result.contains(ConnectivityResult.none);

      print('Initial connectivity status: ${isConnected.value}');

      // Start listening for connectivity changes
      _connectivitySubscription = _connectivity.onConnectivityChanged
          .listen((List<ConnectivityResult> results) {
        _handleConnectivityChange(results);
      });

      _isInitialized = true;
    } catch (e) {
      print('Error initializing connectivity: $e');
      isConnected.value = false;
    } finally {
      isChecking.value = false;
    }
  }

  void _handleConnectivityChange(List<ConnectivityResult> results) {
    _connectionStatus = results;
    bool wasConnected = isConnected.value;
    isConnected.value = !results.contains(ConnectivityResult.none);

    print(
        'Connectivity changed: wasConnected=$wasConnected, isConnected=${isConnected.value}');

    // Only show notifications and navigate if we have a valid context
    // and the app is in the foreground
    if (!isConnected.value && wasConnected) {
      _handleDisconnection();
    } else if (isConnected.value && !wasConnected) {
      _handleReconnection();
    }
  }

  void _handleDisconnection() {
    print('Handling disconnection - current route: ${Get.currentRoute}');
    // Navigate to offline page if not already there
    if (Get.currentRoute != '/nointernet' && Get.context != null) {
      Get.offAll(() => OfflineView());

      // Show snackbar if context is available
      if (Get.context != null) {
        SSnackbarUtil.showFadeSnackbar(
          Get.context!,
          "Please check your internet connection",
          SnackbarType.warning,
        );
      }
    }
  }

  void _handleReconnection() {
    print('Handling reconnection - current route: ${Get.currentRoute}');
    // Show success message and navigate back
    if (Get.context != null) {
      SSnackbarUtil.showFadeSnackbar(
        Get.context!,
        "Internet Restored",
        SnackbarType.success,
      );
    }

    // Check if we're currently on the offline page before navigating
    if (Get.currentRoute == '/nointernet') {
      checkLoginAndNavigate();
    }
  }

  // Method to manually check connectivity (for refresh button)
  Future<void> refreshConnectivity() async {
    isChecking.value = true;
    try {
      final results = await _connectivity.checkConnectivity();
      _connectionStatus = results;

      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 500), () {
        isConnected.value = !results.contains(ConnectivityResult.none);

        if (Get.context != null) {
          if (!isConnected.value) {
            SSnackbarUtil.showFadeSnackbar(
              Get.context!,
              "No internet connection detected",
              SnackbarType.warning,
            );
          } else {
            SSnackbarUtil.showFadeSnackbar(
              Get.context!,
              "Internet Restored",
              SnackbarType.success,
            );
            if (Get.currentRoute == '/nointernet') {
              checkLoginAndNavigate();
            }
          }
        }
      });
    } catch (e) {
      print('Error refreshing connectivity: $e');
    } finally {
      isChecking.value = false;
    }
  }

  // Remove the old checkConnectivity method and replace with this
  void checkConnectivity(BuildContext context) async {
    // This method can be simplified since we're already monitoring
    // connectivity changes in the background
    await refreshConnectivity();
  }

  // Keep the existing refreshPage method but update it to use refreshConnectivity
  Future<void> refreshPage(BuildContext context) async {
    await refreshConnectivity();
  }

  void checkLoginAndNavigate() async {
    try {
      // Check SharedPreferences first
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

      // Check GetStorage for user and organization data
      final userId = storage.read('user_id');
      final selectedOrganization = storage.read('selectedOrganization');

      print('Checking login status:');
      print('isLoggedIn: $isLoggedIn');
      print('userId: $userId');
      print('selectedOrganization: $selectedOrganization');

      if (isLoggedIn && userId != null) {
        // User is logged in, now check if organization is selected
        if (selectedOrganization != null && selectedOrganization.isNotEmpty) {
          // User is logged in and has selected an organization
          print(
              'Navigating to BottomNavPage - user logged in with organization');
          Get.offAll(() => const BottomNavPage(), arguments: 0);
        } else {
          // User is logged in but hasn't selected an organization
          // Check if user data exists in SharedPreferences to determine next step
          final userData = prefs.getString('userData');
          if (userData != null && userData.isNotEmpty) {
            print(
                'Navigating to OrganizationPage - user logged in but no organization selected');
            // Parse user data to get organizations if needed
            // For now, navigate to organization page
            Get.offAll(() => const OrganizationPage());
          } else {
            print('Navigating to LoginPage - user data incomplete');
            Get.offAll(() => const LoginPage());
          }
        }
      } else {
        // User is not logged in
        print('Navigating to LoginPage - user not logged in');
        Get.offAll(() => const LoginPage());
      }
    } catch (e) {
      print('Error in checkLoginAndNavigate: $e');
      // In case of error, navigate to login page as fallback
      Get.offAll(() => const LoginPage());
    }
  }

  // Add a method to check initial navigation
  void handleInitialNavigation() {
    print('Handling initial navigation - isConnected: ${isConnected.value}');
    if (!isConnected.value) {
      // If offline initially, go to offline page
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAll(() => OfflineView());
      });
    } else {
      // If online, proceed with normal login flow
      checkLoginAndNavigate();
    }
  }

  @override
  void onClose() {
    _debounce?.cancel();
    _connectivitySubscription.cancel();
    super.onClose();
  }
}
