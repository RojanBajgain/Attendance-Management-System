import 'dart:async';

import 'package:ams/feature/presentation/pages/bottom_nav/bottom_nav_page.dart';
import 'package:ams/feature/presentation/pages/login/login_page.dart';
import 'package:ams/feature/presentation/pages/offline_page/page/offline_page.dart';
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
  String? _previousRoute; // Store the previous route

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

    // Check if we're already on offline page (handle different possible route names)
    bool isOnOfflinePage = Get.currentRoute == '/nointernet' ||
        Get.currentRoute == '/offline' ||
        Get.currentRoute.contains('OfflineView');

    if (!isOnOfflinePage && Get.context != null) {
      // Store the current route before navigating to offline page
      _previousRoute = Get.currentRoute;
      print('Storing previous route: $_previousRoute');

      try {
        // Use direct widget navigation to avoid route configuration issues
        Get.to(() => OfflineView(), preventDuplicates: true);
      } catch (e) {
        print('Error navigating to offline page: $e');
        // Fallback: try named route
        try {
          Get.toNamed('/nointernet');
        } catch (e2) {
          print('Error with named route navigation: $e2');
        }
      }

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

    // Show success message
    if (Get.context != null) {
      SSnackbarUtil.showFadeSnackbar(
        Get.context!,
        "Internet Restored",
        SnackbarType.success,
      );
    }

    // Check if we're currently on the offline page before navigating
    bool isOnOfflinePage = Get.currentRoute == '/nointernet' ||
        Get.currentRoute == '/offline' ||
        Get.currentRoute.contains('OfflineView');

    if (isOnOfflinePage) {
      _restoreUserToOriginalRoute();
    }
  }

  void _restoreUserToOriginalRoute() {
    print('Restoring user to previous route');

    // Check if we're currently on any offline page variation
    bool isOnOfflinePage = Get.currentRoute == '/nointernet' ||
        Get.currentRoute == '/OfflineView' ||
        Get.currentRoute == '/offline';

    if (isOnOfflinePage) {
      if (_previousRoute != null) {
        _navigateToStoredRoute(); // Call this instead of just checking /nointernet
      } else {
        _navigateToAppropriateRoute();
      }
    }
  }

  void _navigateToStoredRoute() {
    if (_previousRoute == null || _previousRoute!.isEmpty) return;

    try {
      // Clear the stored route first
      String routeToNavigate = _previousRoute!;
      _previousRoute = null;

      // Handle different route patterns
      if (routeToNavigate.contains('BottomNavPage') ||
          routeToNavigate == '/bottomNav') {
        Get.offAllNamed('/bottomNav');
      } else if (routeToNavigate.contains('LoginPage') ||
          routeToNavigate == '/login') {
        Get.offAllNamed('/login');
      } else if (routeToNavigate.contains('OrganizationPage') ||
          routeToNavigate == '/organization') {
        Get.offAllNamed('/organization');
      } else if (routeToNavigate.contains('LandingPage') ||
          routeToNavigate == '/landingpage') {
        Get.offAllNamed('/landingpage');
      } else if (routeToNavigate.contains('ChatsScreen') ||
          routeToNavigate == '/chat') {
        Get.offAllNamed('/chat');
      } else {
        // Try to navigate to the exact route
        Get.offAllNamed(routeToNavigate);
      }

      print('Successfully navigated to stored route: $routeToNavigate');
    } catch (e) {
      print('Error navigating to stored route: $e');
      // Fallback to appropriate route based on login status
      _navigateToAppropriateRoute();
    }
  }

  void _navigateToAppropriateRoute() {
    final isLoggedIn = storage.read('isLoggedIn') ?? false;
    final userId = storage.read('userId');
    final organization = storage.read('selectedOrganization');

    if (isLoggedIn && userId != null && organization != null) {
      Get.offAllNamed('/bottomNav');
    } else {
      Get.offAllNamed('/login');
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
            if (Get.currentRoute == '/nointernet' ||
                Get.currentRoute == '/offline' ||
                Get.currentRoute.contains('OfflineView')) {
              _restoreUserToOriginalRoute();
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final userId = prefs.getString('userId');
    final organization = storage.read('selectedOrganization');

    print(
        'Checking login status: isLoggedIn=$isLoggedIn, userId=$userId, organization=$organization');

    if (isLoggedIn && userId != null && organization != null) {
      Get.offAll(() => BottomNavPage()); // Use direct widget navigation
    } else {
      Get.offAll(() => LoginPage()); // Use direct widget navigation
    }
  }

  // Add a method to check initial navigation
  void handleInitialNavigation() {
    print('Handling initial navigation - isConnected: ${isConnected.value}');
    if (!isConnected.value) {
      // If offline initially, go to offline page
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAllNamed('/nointernet');
      });
    } else {
      // If online, proceed with normal login flow
      checkLoginAndNavigate();
    }
  }

  // Method to clear stored route (call this when user logs out or app is closed)
  void clearStoredRoute() {
    _previousRoute = null;
    print('Stored route cleared');
  }

  @override
  void onClose() {
    _debounce?.cancel();
    _connectivitySubscription.cancel();
    super.onClose();
  }
}
