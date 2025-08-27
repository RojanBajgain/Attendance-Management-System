import 'dart:developer';

import 'package:ams/feature/data/datasource/remote/api_response.dart';
import 'package:ams/feature/data/repository/has_clockedIn_repo.dart';
import 'package:ams/feature/presentation/pages/dashboard/model/get_clock_model.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ams/feature/presentation/pages/dashboard/controller/timer_controller.dart';
import 'package:ams/feature/presentation/pages/profile/controller/profile_controller.dart';

class HasClockedinController extends GetxController {
  var clockedInTime = Rx<DateTime?>(null);
  var clockedOutTime = Rx<DateTime?>(null);
  var isLoading = false.obs;
  var lastUserId = Rx<int?>(null);

  final HasClockRepo hasClockedIn;

  HasClockedinController({required this.hasClockedIn});

  // @override
  // void onInit() {
  //   super.onInit();
  //   _loadLastUserId();
  //   getClockData();
  // }

  Future<void> _loadLastUserId() async {
    final prefs = await SharedPreferences.getInstance();
    lastUserId.value = prefs.getInt('lastLoggedInUserId');
    log("HasClockedinController initialized for last user ID: ${lastUserId.value}");
  }

  Future<void> _saveLastUserId(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('lastLoggedInUserId', userId);
    lastUserId.value = userId;
    log("Saved last logged in user ID: $userId");
  }

  // Check if user has changed
  Future<bool> _hasUserChanged() async {
    try {
      // Get current user ID from profile controller
      final profileController = Get.find<ProfileController>();
      if (profileController.profile == null ||
          profileController.profile.value!.userRecords?.first.employeeNo ==
              null) {
        return false;
      }

      int currentUserId =
          profileController.profile.value!.userRecords?.first.employeeNo ?? 0;

      if (lastUserId.value != null && lastUserId.value != currentUserId) {
        log("User has changed from ${lastUserId.value} to $currentUserId");
        await _saveLastUserId(currentUserId);
        return true;
      } else if (lastUserId.value == null) {
        await _saveLastUserId(currentUserId);
      }

      return false;
    } catch (e) {
      log("Error checking if user has changed: $e");
      return false;
    }
  }

  Future<void> getClockData() async {
    try {
      isLoading(true);

      // Check if user has changed
      bool userChanged = await _hasUserChanged();
      if (userChanged) {
        await _clearPreviousUserData();
      }

      ApiResponse response = await hasClockedIn.getClock();
      if (response.status == ApiStatus.SUCCESS && response.response != null) {
        GetClockModel clockData = response.response;

        // Handle clock in time
        if (clockData.clockedInData != null) {
          DateTime utcTime =
              DateTime.parse(clockData.clockedInData!.toString());
          DateTime localTime =
              utcTime.add(const Duration(hours: 5, minutes: 45));

          clockedInTime.value = localTime;

          // Store the clock in time with user ID
          if (lastUserId.value != null) {
            final prefs = await SharedPreferences.getInstance();
            String userKey = 'clockInTime_${lastUserId.value}';
            await prefs.setString(userKey, localTime.toIso8601String());
            log("Saved clock in time to $userKey");

            // Also update the general clockInTime for compatibility
            await prefs.setString('clockInTime', localTime.toIso8601String());
          }

          // Reset the timer controller if it exists
          if (Get.isRegistered<TimerController>()) {
            final timerController = Get.find<TimerController>();
            timerController.setClockInTime(localTime.toIso8601String());
          }
        } else {
          clockedInTime.value = null;
          log("No clock in data available from API");

          // Clear any stored clock in times
          if (lastUserId.value != null) {
            final prefs = await SharedPreferences.getInstance();
            await prefs.remove('clockInTime_${lastUserId.value}');
            await prefs.remove('clockInTime');
          }
        }

        // Handle clock out time - FIX: Move this inside the SUCCESS block
        if (clockData.clockedOutData != null) {
          DateTime utcTime =
              DateTime.parse(clockData.clockedOutData!.toString());
          DateTime localTime =
              utcTime.add(const Duration(hours: 5, minutes: 45));

          clockedOutTime.value = localTime;

          // Store clock out time
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('clockOutTime', localTime.toIso8601String());
          log("Saved clock out time: $localTime");
        } else {
          clockedOutTime.value = null;
          final prefs = await SharedPreferences.getInstance();
          await prefs.remove('clockOutTime');
          log("No clock out data available from API");
        }
      } else {
        // FIX: Only clear data if API call failed, not if clock-out is null
        clockedInTime.value = null;
        clockedOutTime.value = null;
        log("Error: ${response.message}");
      }
    } catch (e) {
      log("Error fetching clock data: $e");
      clockedInTime.value = null;
      clockedOutTime.value = null;
    } finally {
      isLoading(false);
    }
  }

  Future<void> _clearPreviousUserData() async {
    log("Clearing previous user data");
    final prefs = await SharedPreferences.getInstance();
    // Clear all timer related data
    await prefs.remove('clockInTime');
    await prefs.remove('clockOutTime');
    await prefs.remove('isTimerRunning');
    await prefs.remove('isOnBreak');
    await prefs.remove('breakStartTime');
    await prefs.remove('stopwatchElapsedSeconds');
    await prefs.remove('elapsedSeconds');

    // Specific to old user
    if (lastUserId.value != null) {
      await prefs.remove('clockInTime_${lastUserId.value}');
    }

    // Reset timer controller if it exists
    if (Get.isRegistered<TimerController>()) {
      final timerController = Get.find<TimerController>();
      timerController.forceReset();
    }

    // Reset our state
    clockedInTime.value = null;
  }

  // Public method to call when user logs in or changes
  Future<void> handleUserChanged() async {
    bool userChanged = await _hasUserChanged();
    if (userChanged) {
      await _clearPreviousUserData();
      await getClockData();
    }
  }
}
