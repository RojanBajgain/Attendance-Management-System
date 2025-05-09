/* import 'dart:developer';
import 'package:ams/feature/presentation/pages/dashboard/controller/clock_in_out_controller.dart';
import 'package:ams/feature/presentation/pages/dashboard/controller/has_clockedIn_controller.dart';
import 'package:ams/feature/presentation/pages/dashboard/controller/timer_controller.dart';
import 'package:ams/feature/presentation/pages/profile/controller/profile_controller.dart';
import 'package:ams/feature/utils/ssnackbar_utils.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClockTimeController extends GetxController {
  final ProfileController profileController = Get.find<ProfileController>();
  final ClockInOutController clockInOutController =
      Get.find<ClockInOutController>();
  final TimerController timerController = Get.find<TimerController>();
  final HasClockedinController hasClockedinController =
      Get.find<HasClockedinController>();

  var isClockedInToday = false.obs;
  var isClockedOut = false.obs;
  var isOnBreak = false.obs;
  var officeLocation = Rxn<Location>();
  var isLoading = true.obs;
  var officeLocationError = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadState();
  }

  Future<void> loadState() async {
    isLoading.value = true;
    log('ClockTimeController: Starting loadState');

    // Retry fetching data up to 3 times if initial fetch fails
    for (int attempt = 1; attempt <= 3; attempt++) {
      try {
        await Future.wait([
          hasClockedinController.getClockData(),
          loadOfficeLocation(),
        ]);
        log('ClockTimeController: Successfully fetched clock data and office location on attempt $attempt');
        break;
      } catch (e) {
        log('ClockTimeController: Failed to fetch data on attempt $attempt: $e');
        if (attempt == 3) {
          SSnackbarUtil.showSnackbar(
            'Error',
            'Failed to load initial data. Please try again.',
            SnackbarType.error,
          );
          officeLocationError.value = 'Failed to load initial data.';
        }
        await Future.delayed(Duration(seconds: attempt));
      }
    }

    await loadClockInState();
    await loadBreakState();

    isLoading.value = false;
    log('ClockTimeController: Completed loadState, isLoading=${isLoading.value}, isClockedInToday=${isClockedInToday.value}');
  }

  Future<void> loadOfficeLocation() async {
    final prefs = await SharedPreferences.getInstance();
    double? cachedLat = prefs.getDouble('officeLatitude');
    double? cachedLon = prefs.getDouble('officeLongitude');
    if (cachedLat != null && cachedLon != null) {
      officeLocation.value =
          Location(latitude: cachedLat, longitude: cachedLon);
      officeLocationError.value = '';
      log('ClockTimeController: Loaded cached officeLocation: lat=$cachedLat, lon=$cachedLon');
      return;
    }

    Location? location = await clockInOutController.getOfficeLocation();
    if (location != null) {
      officeLocation.value = location;
      officeLocationError.value = '';
      await prefs.setDouble('officeLatitude', location.latitude);
      await prefs.setDouble('officeLongitude', location.longitude);
      log('ClockTimeController: Fetched officeLocation: lat=${location.latitude}, lon=${location.longitude}');
    } else if (clockInOutController.officeLocationError.isNotEmpty) {
      officeLocationError.value =
          clockInOutController.officeLocationError.value;
      SSnackbarUtil.showSnackbar(
        'Error',
        clockInOutController.officeLocationError.value,
        SnackbarType.error,
      );
      log('ClockTimeController: Office location error: ${clockInOutController.officeLocationError.value}');
    }
  }

  Future<void> loadClockInState() async {
    final prefs = await SharedPreferences.getInstance();
    DateTime now = DateTime.now();
    String todayDate = DateFormat('yyyy-MM-dd').format(now);

    // Prioritize API clock-in time from HasClockedinController
    DateTime? apiClockInTime = hasClockedinController.clockedInTime.value;
    log('ClockTimeController: apiClockInTime=$apiClockInTime');

    if (apiClockInTime != null) {
      String clockInDate = DateFormat('yyyy-MM-dd').format(apiClockInTime);
      if (clockInDate == todayDate) {
        isClockedInToday.value = true;
        isClockedOut.value = false;
        // Sync timer with API clock-in time
        await timerController.syncWithApiClockIn();
        log('ClockTimeController: Clocked in today, synced timer');
      } else {
        isClockedInToday.value = false;
        isClockedOut.value = false;
        await timerController.stopTimer();
        log('ClockTimeController: Clock-in from different day, resetting timer');
      }
    } else {
      // Fallback to stored clock-in time if API data is unavailable
      String? storedClockInTime = timerController.clockInTime;
      if (storedClockInTime != null) {
        DateTime clockInDateTime = DateTime.parse(storedClockInTime);
        String clockInDate = DateFormat('yyyy-MM-dd').format(clockInDateTime);
        if (clockInDate == todayDate &&
            (prefs.getBool('isTimerRunning') ?? false)) {
          isClockedInToday.value = true;
          isClockedOut.value = false;
          log('ClockTimeController: Clocked in today from stored data');
        } else {
          isClockedInToday.value = false;
          isClockedOut.value = false;
          await timerController.stopTimer();
          log('ClockTimeController: Invalid or outdated stored clock-in, resetting timer');
        }
      } else {
        isClockedInToday.value = false;
        isClockedOut.value = false;
        await timerController.stopTimer();
        log('ClockTimeController: No clock-in data, resetting timer');
      }
    }

    // Handle clock-out time
    String? storedClockOutTime = prefs.getString('clockOutTime');
    if (storedClockOutTime != null) {
      DateTime parsedClockOutTime = DateTime.parse(storedClockOutTime);
      if (DateFormat('yyyy-MM-dd').format(parsedClockOutTime) == todayDate) {
        isClockedOut.value = true;
        isClockedInToday.value = false;
        await timerController.stopTimer();
        log('ClockTimeController: Clocked out today');
      } else {
        await prefs.remove('clockOutTime');
        log('ClockTimeController: Wiping outdated clockOutTime');
      }
    }
  }

  Future<void> loadBreakState() async {
    final prefs = await SharedPreferences.getInstance();
    isOnBreak.value = prefs.getBool('isOnBreak') ?? false;
    if (isOnBreak.value && !(prefs.getBool('isStopwatchRunning') ?? false)) {
      await timerController.startStopwatch();
      log('ClockTimeController: Resumed stopwatch for break');
    }
    log('ClockTimeController: isOnBreak=${isOnBreak.value}');
  }

  Future<void> handleClockInOut() async {
    if (!await _checkLocationPermission()) return;

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    int? deviceId = profileController.profile.first.device?.deviceUserId;
    if (deviceId == null) {
      SSnackbarUtil.showSnackbar("Error",
          "Device info not found. Please log in again.", SnackbarType.error);
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    DateTime now = DateTime.now();
    String todayDate = DateFormat('yyyy-MM-dd').format(now);

    if (!isClockedInToday.value) {
      bool success = await clockInOutController.postClockin(
        deviceId: deviceId,
        latitude: position.latitude.toString(),
        longitude: position.longitude.toString(),
      );
      if (success) {
        isClockedInToday.value = true;
        isClockedOut.value = false;
        await prefs.setString('lastActiveDate', todayDate);
        await timerController.startTimer(initialSeconds: 0);
        log('ClockTimeController: Clocked in successfully');
      }
    } else {
      bool success = await clockInOutController.postClockout(
        deviceId: deviceId,
        latitude: position.latitude.toString(),
        longitude: position.longitude.toString(),
      );
      if (success) {
        isClockedInToday.value = false;
        isClockedOut.value = true;
        await prefs.setString('clockOutTime', DateTime.now().toIso8601String());
        await timerController.stopTimer();
        log('ClockTimeController: Clocked out successfully');
      }
    }

    await hasClockedinController.getClockData();
    await loadClockInState();
  }

  Future<void> handleBreak() async {
    final prefs = await SharedPreferences.getInstance();
    if (!await _checkLocationPermission()) return;

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    int? employeeId = profileController.profile.first.device?.deviceUserId;
    if (employeeId == null) {
      SSnackbarUtil.showSnackbar("Error",
          "Employee info not found. Please log in again.", SnackbarType.error);
      return;
    }

    DateTime now = DateTime.now();
    String todayDate = DateFormat('yyyy-MM-dd').format(now);

    if (!isOnBreak.value) {
      bool success =
          await clockInOutController.postOnBreak(employeeId: employeeId);
      if (success) {
        isOnBreak.value = true;
        await prefs.setString(
            'breakStartTime', DateTime.now().toIso8601String());
        await prefs.setBool('isOnBreak', true);
        await prefs.setString('lastActiveDate', todayDate);
        await timerController.pauseTimer();
        await timerController.startStopwatch();
        log('ClockTimeController: Started break');
      }
    } else {
      bool success = await clockInOutController.postResume(
        employeeId: employeeId,
        latitude: position.latitude.toString(),
        longitude: position.longitude.toString(),
      );
      if (success) {
        isOnBreak.value = false;
        await prefs.remove('breakStartTime');
        await prefs.setBool('isOnBreak', false);
        await timerController.stopStopwatch();
        await timerController.resumeTimer();
        log('ClockTimeController: Resumed from break');
      }
    }

    await hasClockedinController.getClockData();
  }

  Future<bool> _checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      SSnackbarUtil.showSnackbar(
          "Error", "Enable Location permission in setting", SnackbarType.error);
      return false;
    }
    return permission != LocationPermission.denied;
  }
}

class Location {
  final double latitude;
  final double longitude;

  Location({required this.latitude, required this.longitude});
}
 */
