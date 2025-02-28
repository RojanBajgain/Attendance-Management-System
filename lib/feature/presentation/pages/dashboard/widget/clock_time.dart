import 'dart:developer';

import 'package:ams/config/resources/styles.dart';
import 'package:ams/feature/data/datasource/remote/api_response.dart';
import 'package:ams/feature/data/repository/clock_in_out_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ams/feature/presentation/pages/dashboard/controller/clock_in_out_controller.dart';
import 'package:ams/feature/presentation/pages/dashboard/controller/has_clockedIn_controller.dart';
import 'package:ams/feature/presentation/pages/dashboard/controller/timer_controller.dart';
import 'package:ams/feature/presentation/pages/profile/controller/profile_controller.dart';

class ClockTime extends StatefulWidget {
  const ClockTime({super.key});

  @override
  State<ClockTime> createState() => _ClockTimeState();
}

class _ClockTimeState extends State<ClockTime> {
  final ProfileController profileController =
      Get.put(ProfileController(profileRepo: Get.find()));

  final ClockInOutController clockInOutController =
      Get.put(ClockInOutController(clockinoutrepo: Get.find()));

  final TimerController timerController = Get.put(TimerController());

  final HasClockedinController hasClockedinController =
      Get.put(HasClockedinController(hasClockedIn: Get.find()));

  bool isClockedInToday = false;
  bool isClockedOut = false;
  bool isOnBreak = false;
  Location? officeLocation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await profileController.getProfile();
      await hasClockedinController.getClockData();
      await _loadClockInState();
      await _loadBreakState();
      await _fetchOfficeLocation();
    });
  }

  Future<void> _fetchOfficeLocation() async {
    Location? location = await clockInOutController.getOfficeLocation();

    if (location != null) {
      setState(() {
        officeLocation = location;
      });
    }
  }

  Future<void> _loadClockInState() async {
    await hasClockedinController.getClockData();
    DateTime now = DateTime.now();
    String todayDate = DateFormat('yyyy-MM-dd').format(now);

    DateTime? clockInTime = hasClockedinController.clockedInTime.value;
    log("Loaded Clock-In Time from API: $clockInTime");

    if (clockInTime != null &&
        DateFormat('yyyy-MM-dd').format(clockInTime) == todayDate) {
      setState(() {
        isClockedInToday = true;
        isClockedOut = false;
        isOnBreak = false;
      });

      timerController.clockInTime = clockInTime.toString();
      int elapsed = now.difference(clockInTime).inSeconds;
      timerController.elapsedSeconds.value = elapsed;
      timerController.startTimer();
    } else {
      setState(() {
        isClockedInToday = false;
        isClockedOut = false;
        isOnBreak = false;
      });
      timerController.stopTimer();
    }
  }

  Future<bool> _checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      Get.snackbar('Error', 'Enable location permissions in settings.',
          backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }
    return permission != LocationPermission.denied;
  }

  Future<void> _handleClockInOut() async {
    if (!await _checkLocationPermission()) return;

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);

    int? deviceId = profileController.profile.first.device?.deviceUserId;
    if (deviceId == null) {
      Get.snackbar("Error", "Device info not found. Please log in again.",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    if (!isClockedInToday) {
      await clockInOutController.postClockin(
          deviceId: deviceId,
          latitude: position.latitude.toString(),
          longitude: position.longitude.toString());
    } else {
      await clockInOutController.postClockout(
          deviceId: deviceId,
          latitude: position.latitude.toString(),
          longitude: position.longitude.toString());
    }

    await hasClockedinController.getClockData();
    await _loadClockInState();
  }

  Future<void> _loadBreakState() async {
    final prefs = await SharedPreferences.getInstance();
    bool isOnBreakValue = prefs.getBool('isOnBreak') ?? false;

    if (isOnBreakValue) {
      String? breakStartTimeStr = prefs.getString('breakStartTime');
      int? elapsedSeconds = prefs.getInt('stopwatchElapsedSeconds');

      if (breakStartTimeStr != null && elapsedSeconds != null) {
        DateTime breakStartTime = DateTime.parse(breakStartTimeStr);
        int additionalSeconds =
            DateTime.now().difference(breakStartTime).inSeconds;
        int totalElapsed = elapsedSeconds + additionalSeconds;

        timerController.startStopwatch(initialSeconds: totalElapsed);
      }
    }

    setState(() => isOnBreak = isOnBreakValue);
  }

  Future<void> _handleBreak() async {
    final prefs = await SharedPreferences.getInstance();
    if (!await _checkLocationPermission()) return;

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);

    if (profileController.profile.value.isEmpty) {
      Get.snackbar("Error", "Profile data not found. Please log in again.",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    int? employeeId = profileController.profile.first.device?.deviceUserId;
    if (employeeId == null) {
      Get.snackbar("Error", "Employee info not found. Please log in again.",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    if (!isOnBreak) {
      log("Calling postOnBreak API");
      await clockInOutController.postOnBreak(employeeId: employeeId);

      await prefs.setString('breakStartTime', DateTime.now().toIso8601String());
      await prefs.setInt('stopwatchElapsedSeconds', 0);

      timerController.pauseTimer();
      timerController.startStopwatch();
    } else {
      log("Calling postResume API");
      await clockInOutController.postResume(
          employeeId: employeeId,
          latitude: position.latitude.toString(),
          longitude: position.longitude.toString());

      int elapsedTime = timerController.stopwatchSeconds.value;
      await prefs.setInt('stopwatchElapsedSeconds', elapsedTime);
      await prefs.remove('breakStartTime');
      await prefs.remove('stopwatchElapsedSeconds');

      timerController.stopStopwatch();
      timerController.resumeTimer();
    }

    await hasClockedinController.getClockData();

    setState(() {
      isOnBreak = !isOnBreak;
    });

    await prefs.setBool('isOnBreak', isOnBreak);
  }

  getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      log("Location denied");
      LocationPermission ask = await Geolocator.requestPermission();
    } else {
      Position currentposition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      log("Latitude: ${currentposition.latitude.toString()}");
      log("Longitude: ${currentposition.longitude.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 250.0,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        color: isDarkMode ? Colors.grey.shade800 : Colors.grey[50],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildClockInTimeDisplay(isDarkMode),
            const SizedBox(width: 50.0),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildClockInOutButton(isDarkMode),
                const SizedBox(height: 10.0),
                if (isClockedInToday && !isClockedOut && !isOnBreak)
                  _buildBreakButton(isDarkMode),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClockInTimeDisplay(bool isDarkMode) {
    bool isClockingOut = isClockedInToday && !isClockedOut;

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: 150,
          width: 150,
          child: CircularProgressIndicator(
            value: 1.0,
            strokeWidth: 12.0,
            valueColor: AlwaysStoppedAnimation(
                (isClockingOut ? Colors.red[700] : Colors.green[600])),
            backgroundColor: Colors.grey[300],
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(isOnBreak ? "Break Time" : "Clock In Time",
                style: normalStyle.copyWith(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(height: 8),
            Obx(
              () => Text(
                isOnBreak
                    ? _formatStopwatchTime(
                        timerController.stopwatchSeconds.value)
                    : _formatTime(hasClockedinController.clockedInTime.value),
                style: normalStyle.copyWith(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildClockInOutButton(bool isDarkMode) {
    bool isClockingOut = isClockedInToday && !isClockedOut;

    return ElevatedButton(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
              isClockingOut ? Colors.red[700] : Colors.green[600])),
      onPressed: () {
        if (isOnBreak) {
          _handleBreak();
        } else {
          _handleClockInOut();
        }
      },
      child: Text(
          isClockedOut
              ? 'Clocked Out'
              : (isOnBreak
                  ? 'Resume'
                  : (isClockedInToday ? 'Clock Out' : 'Clock In')),
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildBreakButton(bool isDarkMode) {
    return ElevatedButton(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.orange[700])),
      onPressed: _handleBreak,
      child: const Text('Break',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
    );
  }

  String _formatTime(DateTime? dateTime) =>
      dateTime == null ? "--:--:--" : DateFormat("h:mm:ss a").format(dateTime);

  String _formatStopwatchTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int secs = seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${secs.toString().padLeft(2, '0')}';
  }
}

class Location {
  final double latitude;
  final double longitude;

  Location({required this.latitude, required this.longitude});
}
