// import 'dart:async';

// import 'package:ams/config/routes/route_helper.dart';
// import 'package:ams/feature/presentation/pages/bottom_nav/bottom_nav_page.dart';
// import 'package:ams/feature/presentation/pages/calender_notification/sub_view_event/event_page.dart';
// import 'package:ams/feature/presentation/pages/chat/chat.dart';
// import 'package:ams/feature/presentation/pages/landing/landing_page.dart';
// import 'package:ams/feature/presentation/pages/login/login_page.dart';
// import 'package:ams/feature/presentation/pages/offline_page/page/offline_page.dart';
// import 'package:ams/feature/presentation/pages/organization/pages/organization_page.dart';
// import 'package:ams/feature/presentation/pages/payroll/payroll_page.dart';
// import 'package:ams/feature/presentation/pages/payroll/sub_view_payroll/payment_slip_view.dart';
// import 'package:ams/feature/presentation/pages/timesheet/time_sheet_page.dart';
// import 'package:ams/feature/utils/ssnackbar_utils.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class OfflineController extends GetxController {
//   List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
//   final Connectivity _connectivity = Connectivity();
//   late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
//   var isConnected = true.obs;
//   var isChecking = false.obs;
//   final storage = GetStorage();

//   Timer? _debounce;
//   bool _isInitialized = false;
//   String? _lastRoute;

//   bool _isNavigating = false;

//   Future<void> initConnectivity() async {
//     if (_isInitialized) return;

//     isChecking.value = true;
//     try {
//       final result = await _connectivity.checkConnectivity();
//       _connectionStatus = result;
//       isConnected.value = !result.contains(ConnectivityResult.none);

//       print('Initial connectivity status: ${isConnected.value}');

//       // Start listening for connectivity changes
//       _connectivitySubscription = _connectivity.onConnectivityChanged
//           .listen((List<ConnectivityResult> results) {
//         _handleConnectivityChange(results);
//       });

//       _isInitialized = true;
//     } catch (e) {
//       print('Error initializing connectivity: $e');
//       isConnected.value = false;
//     } finally {
//       isChecking.value = false;
//     }
//   }

//   void _handleConnectivityChange(List<ConnectivityResult> results) {
//     _connectionStatus = results;
//     bool wasConnected = isConnected.value;
//     bool newConnectionStatus = !results.contains(ConnectivityResult.none);

//     print(
//         'Connectivity changed: wasConnected=$wasConnected, newStatus=$newConnectionStatus');

//     if (wasConnected == newConnectionStatus) {
//       print('No actual connectivity change, ignoring');
//       return;
//     }

//     isConnected.value = newConnectionStatus;

//     if (_debounce?.isActive ?? false) _debounce!.cancel();
//     _debounce = Timer(const Duration(milliseconds: 1500), () {
//       // Double-check connectivity status before acting
//       _connectivity.checkConnectivity().then((currentResults) {
//         bool currentStatus = !currentResults.contains(ConnectivityResult.none);

//         if (currentStatus != isConnected.value) {
//           print('Connectivity status changed during debounce, updating');
//           isConnected.value = currentStatus;
//         }

//         if (!isConnected.value && wasConnected) {
//           _handleDisconnection();
//         } else if (isConnected.value && !wasConnected) {
//           _handleReconnection();
//         }
//       });
//     });
//   }

//   void _handleDisconnection() {
//     if (_isNavigating) return;

//     print('Handling disconnection - current route: ${Get.currentRoute}');

//     // Store the current route before navigating to offline page
//     if (Get.currentRoute != '/nointernet') {
//       _lastRoute = Get.currentRoute;
//       print('Stored last route: $_lastRoute');

//       _isNavigating = true;
//       Get.off(() => OfflineView())?.then((_) {
//         _isNavigating = false;
//       });

//       // Show snackbar if context is available
//       if (Get.context != null) {
//         SSnackbarUtil.showFadeSnackbar(
//           Get.context!,
//           "Please check your internet connection",
//           SnackbarType.error,
//         );
//       }
//     }
//   }

//   void _handleReconnection() {
//     if (_isNavigating) {
//       print('Already navigating, skipping reconnection handling');
//       return;
//     }

//     print('Handling reconnection - current route: ${Get.currentRoute}');
//     print('Last stored route: $_lastRoute');

//     // Check if we're currently on the offline page before proceeding
//     if (Get.currentRoute != '/nointernet' &&
//         Get.currentRoute != '/OfflineView') {
//       print('Not on offline page, skipping reconnection navigation');
//       return;
//     }

//     // Show success message
//     if (Get.context != null) {
//       SSnackbarUtil.showFadeSnackbar(
//         Get.context!,
//         "Internet Restored",
//         SnackbarType.success,
//       );
//     }

//     _isNavigating = true;

//     // Add delay to ensure WebSocket settles and UI is ready
//     Timer(const Duration(milliseconds: 1000), () {
//       if (isConnected.value) {
//         // Double-check connection is still active
//         navigateToLastRoute();
//       } else {
//         print('Connection lost again, canceling navigation');
//         _isNavigating = false;
//       }
//     });
//   }

//   // Method to manually check connectivity (for refresh button)
//   Future<void> refreshConnectivity() async {
//     if (_isNavigating) {
//       print('Navigation in progress, skipping refresh');
//       return;
//     }

//     isChecking.value = true;
//     try {
//       // Perform multiple checks to ensure stable connectivity
//       final results1 = await _connectivity.checkConnectivity();
//       await Future.delayed(const Duration(milliseconds: 200));
//       final results2 = await _connectivity.checkConnectivity();

//       bool isStableConnection = !results1.contains(ConnectivityResult.none) &&
//           !results2.contains(ConnectivityResult.none);

//       if (_debounce?.isActive ?? false) _debounce!.cancel();
//       _debounce = Timer(const Duration(milliseconds: 800), () {
//         bool wasConnected = isConnected.value;
//         isConnected.value = isStableConnection;

//         if (Get.context != null) {
//           if (!isConnected.value) {
//             SSnackbarUtil.showFadeSnackbar(
//               Get.context!,
//               "No internet connection detected",
//               SnackbarType.error,
//             );
//           } else if (wasConnected != isConnected.value) {
//             SSnackbarUtil.showFadeSnackbar(
//               Get.context!,
//               "Internet Restored",
//               SnackbarType.success,
//             );
//             if (Get.currentRoute == '/nointernet' ||
//                 Get.currentRoute == '/OfflineView') {
//               _isNavigating = true;
//               Timer(const Duration(milliseconds: 800), () {
//                 if (isConnected.value) {
//                   // Double-check before navigating
//                   navigateToLastRoute();
//                 } else {
//                   _isNavigating = false;
//                 }
//               });
//             }
//           }
//         }
//       });
//     } catch (e) {
//       print('Error refreshing connectivity: $e');
//       isConnected.value = false;
//     } finally {
//       isChecking.value = false;
//     }
//   }

//   void checkConnectivity(BuildContext context) async {
//     await refreshConnectivity();
//   }

//   Future<void> refreshPage(BuildContext context) async {
//     await refreshConnectivity();
//   }

//   void checkLoginAndNavigate() async {
//     if (_isNavigating) return;

//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

//       // Check GetStorage for user and organization data
//       final userId = storage.read('user_id');
//       final selectedOrganization = storage.read('selectedOrganization');

//       print('Checking login status:');
//       print('isLoggedIn: $isLoggedIn');
//       print('userId: $userId');
//       print('selectedOrganization: $selectedOrganization');

//       if (isLoggedIn && userId != null) {
//         // User is logged in, now check if organization is selected
//         if (selectedOrganization != null && selectedOrganization.isNotEmpty) {
//           // User is logged in and has selected an organization
//           print(
//               'Navigating to BottomNavPage - user logged in with organization');
//           Get.offAllNamed(RouteHelper.bottomnav, arguments: 0);
//         } else {
//           // User is logged in but hasn't selected an organization
//           final userData = prefs.getString('userData');
//           if (userData != null && userData.isNotEmpty) {
//             Get.offAll(() => const OrganizationPage());
//           } else {
//             print('Navigating to LoginPage - user data incomplete');
//             Get.offAll(() => const LoginPage());
//           }
//         }
//       } else {
//         // User is not logged in - navigate to landing page
//         print('Navigating to LandingPage - user not logged in');
//         Get.offAll(() => const LandingPage());
//       }
//     } catch (e) {
//       print('Error in checkLoginAndNavigate: $e');
//       // In case of error, navigate to landing page as fallback
//       Get.offAll(() => const LandingPage());
//     } finally {
//       _isNavigating = false;
//     }
//   }

//   void navigateToLastRoute() async {
//     try {
//       print('Attempting to navigate to last route: $_lastRoute');

//       if (_lastRoute == null ||
//           _lastRoute == '/nointernet' ||
//           _lastRoute == '/OfflineView') {
//         print('No valid last route, doing normal navigation');
//         checkLoginAndNavigate();
//         return;
//       }

//       // Verify user is still authenticated before navigating to protected routes
//       final prefs = await SharedPreferences.getInstance();
//       final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
//       final userId = storage.read('user_id');
//       final selectedOrganization = storage.read('selectedOrganization');

//       print(
//           'Auth check - isLoggedIn: $isLoggedIn, userId: $userId, org: $selectedOrganization');

//       // Fix route matching - handle both route formats
//       String normalizedRoute = _lastRoute!;
//       if (_lastRoute == '/BottomNavPage') normalizedRoute = '/bottomNav';
//       if (_lastRoute == '/LoginPage') normalizedRoute = '/loginpage';
//       if (_lastRoute == '/LandingPage') normalizedRoute = '/landingpage';
//       if (_lastRoute == '/OrganizationPage') normalizedRoute = '/organization';
//       if (_lastRoute == '/ChatsScreen') normalizedRoute = '/chat';
//       if (_lastRoute == '/EventPage') normalizedRoute = '/EventPage';
//       if (_lastRoute == '/PaymentSlip') normalizedRoute = '/PaymentSlip';
//       if (_lastRoute == '/TimeSheetDetail') {
//         normalizedRoute = '/TimeSheetDetail';
//       }
//       if (_lastRoute == '/EditUserInfo') normalizedRoute = '/EditUserInfo';
//       if (_lastRoute == '/EditUserAddress') {
//         normalizedRoute = '/EditUserAddress';
//       }
//       if (_lastRoute == '/EditUserDocument') {
//         normalizedRoute = '/EditUserDocument';
//       }
//       if (_lastRoute == '/EditUserBank') {
//         normalizedRoute = '/EditUserBank';
//       }
//       if (_lastRoute == '/HRDetails') normalizedRoute = '/HRDetails';

//       // Check if the last route requires authentication
//       final protectedRoutes = [
//         '/bottomNav',
//         '/organization',
//         '/chat',
//         '/EventPage',
//         '/PaymentSlip',
//         '/TimeSheetDetail',
//         '/EditUserInfo',
//         '/EditUserAddress',
//         '/EditUserDocument',
//         '/EditUserBank',
//         '/HRDetails',
//       ];
//       bool isProtectedRoute = protectedRoutes.contains(normalizedRoute);

//       if (isProtectedRoute) {
//         if (!isLoggedIn || userId == null) {
//           print('User no longer authenticated, navigating to login');
//           Get.offAll(() => const LoginPage());
//           _isNavigating = false;
//           return;
//         }

//         // For bottom nav and chat routes, also check organization
//         if ((normalizedRoute == '/bottomNav' || normalizedRoute == '/chat') &&
//             (selectedOrganization == null || selectedOrganization.isEmpty)) {
//           print('Organization not selected, navigating to organization page');
//           Get.offAll(() => const OrganizationPage());
//           _isNavigating = false;
//           return;
//         }
//       }

//       // Navigate to the stored route
//       switch (normalizedRoute) {
//         case '/loginpage':
//           Get.offAll(() => const LoginPage());
//           break;
//         case '/landingpage':
//           Get.offAll(() => const LandingPage());
//           break;
//         case '/bottomNav':
//           Get.offAll(() => BottomNavPage(), arguments: 0);
//           break;
//         case '/organization':
//           Get.offAll(() => const OrganizationPage());
//           break;
//         case '/chat':
//           Get.offAll(() => BottomNavPage());
//           break;
//         case '/EventPage':
//           Get.offAll(() => const EventPage());
//           break;
//         case '/TimeSheetDetail':
//           Get.offAll(() => BottomNavPage());
//           break;
//         case '/PaymentSlip':
//           Get.offAll(() => BottomNavPage());
//           break;
//         case '/EditUserInfo':
//           Get.offAll(() => BottomNavPage());
//           break;
//         case '/EditUserAddress':
//           Get.offAll(() => BottomNavPage());
//           break;
//         case '/EditUserDocument':
//           Get.offAll(() => BottomNavPage());
//           break;
//         case '/EditUserBank':
//           Get.offAll(() => BottomNavPage());
//           break;
//         case '/HRDetails':
//           Get.offAll(() => BottomNavPage());
//           break;
//         default:
//           print(
//               'Unhandled route: $_lastRoute (normalized: $normalizedRoute), doing normal navigation');
//           checkLoginAndNavigate();
//           _isNavigating = false;
//           return;
//       }

//       // Clear the stored route after successful navigation
//       _lastRoute = null;
//       _isNavigating = false;
//     } catch (e) {
//       print('Error navigating to last route: $e');
//       // Fallback to normal navigation
//       checkLoginAndNavigate();
//     }
//   }

//   // Add a method to check initial navigation
//   void handleInitialNavigation() {
//     print('Handling initial navigation - isConnected: ${isConnected.value}');
//     if (!isConnected.value) {
//       // If offline initially, go to offline page
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         Get.offAll(() => OfflineView());
//       });
//     } else {
//       // If online, proceed with normal login flow
//       checkLoginAndNavigate();
//     }
//   }

//   @override
//   void onClose() {
//     _debounce?.cancel();
//     _connectivitySubscription.cancel();
//     super.onClose();
//   }
// }
