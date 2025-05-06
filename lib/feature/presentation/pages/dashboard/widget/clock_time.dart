import 'package:ams/feature/presentation/pages/dashboard/widget/skeleton_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ams/config/resources/styles.dart';
import 'package:ams/feature/utils/ssnackbar_utils.dart';
import 'package:ams/feature/presentation/pages/dashboard/controller/clock_in_out_controller.dart';
import 'package:ams/feature/presentation/pages/dashboard/controller/has_clockedIn_controller.dart';
import 'package:ams/feature/presentation/pages/dashboard/controller/timer_controller.dart';
import 'package:ams/feature/presentation/pages/profile/controller/profile_controller.dart';
import 'dart:developer';

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

  RxBool isClockedInToday = false.obs;
  RxBool isClockedOut = false.obs;
  RxBool isOnBreak = false.obs;
  Location? officeLocation;
  DateTime? clockInTime;
  DateTime? clockOutTime;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        isLoading = true;
      });
      await profileController.getProfile();
      await hasClockedinController.getClockData();
      await _loadClockInState();
      await _loadBreakState();
      await _fetchOfficeLocation();
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  Future<void> _fetchOfficeLocation() async {
    Location? location = await clockInOutController.getOfficeLocation();
    if (location != null && mounted) {
      setState(() {
        officeLocation = location;
      });
    }
  }

  Future<void> _loadClockInState() async {
    await hasClockedinController.getClockData();
    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    DateTime now = DateTime.now();
    String todayDate = DateFormat('yyyy-MM-dd').format(now);

    // Check if the last active date is different from today
    String? lastActiveDate = prefs.getString('lastActiveDate');
    if (lastActiveDate != null && lastActiveDate != todayDate) {
      // Day has changed, reset clock data
      isClockedInToday.value = false;
      isClockedOut.value = false;
      isOnBreak.value = false;
      setState(() {
        clockInTime = null;
        clockOutTime = null; // Reset clockOutTime
      });
      timerController.stopTimer();
      timerController.resetTimer();
      await prefs.remove('clockInTime');
      await prefs.remove('clockOutTime'); // Clear clockOutTime from storage
      await prefs.setBool('isTimerRunning', false);
      await prefs.setBool('isOnBreak', false);
      await prefs.remove('breakStartTime');
      await prefs.remove('stopwatchElapsedSeconds');
    }

    // Update the last active date
    await prefs.setString('lastActiveDate', todayDate);

    DateTime? apiClockInTime = hasClockedinController.clockedInTime.value;
    log("Loaded Clock-In Time from API: $apiClockInTime");

    if (apiClockInTime != null &&
        DateFormat('yyyy-MM-dd').format(apiClockInTime) == todayDate) {
      DateTime clockInMinute = DateTime(
        apiClockInTime.year,
        apiClockInTime.month,
        apiClockInTime.day,
        apiClockInTime.hour,
        apiClockInTime.minute,
      );

      isClockedInToday.value = true;
      isClockedOut.value = false;
      isOnBreak.value = prefs.getBool('isOnBreak') ?? false;
      setState(() {
        clockInTime = apiClockInTime;
      });

      timerController.clockInTime = clockInMinute.toIso8601String();

      if (!timerController.isRunning.value && !isOnBreak.value) {
        int elapsed = now.difference(clockInMinute).inSeconds;
        if (elapsed < 0) elapsed = 0;

        await prefs.setString('clockInTime', clockInMinute.toIso8601String());
        await prefs.setBool('isTimerRunning', true);
        timerController.resetTimer();
        timerController.startTimer(initialSeconds: elapsed);
      }
    } else {
      isClockedInToday.value = false;
      isClockedOut.value = false;
      isOnBreak.value = false;
      setState(() {
        clockInTime = null;
        clockOutTime = null; // Ensure clockOutTime is reset
      });
      timerController.stopTimer();
      timerController.resetTimer();
      await prefs.remove('clockInTime');
      await prefs.remove('clockOutTime'); // Clear clockOutTime from storage
      await prefs.setBool('isTimerRunning', false);
    }

    // Handle clock out time
    String? storedClockOutTime = prefs.getString('clockOutTime');
    if (storedClockOutTime != null) {
      DateTime parsedClockOutTime = DateTime.parse(storedClockOutTime);
      if (DateFormat('yyyy-MM-dd').format(parsedClockOutTime) == todayDate) {
        setState(() {
          clockOutTime = parsedClockOutTime;
        });
      } else {
        // If clock out time is from a different day, clear it
        await prefs.remove('clockOutTime');
        setState(() {
          clockOutTime = null;
        });
      }
    }
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

  Future<void> _handleClockInOut() async {
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

    // Check if the day has changed since last activity
    DateTime now = DateTime.now();
    String todayDate = DateFormat('yyyy-MM-dd').format(now);
    String? lastActiveDate = prefs.getString('lastActiveDate');

    if (lastActiveDate != null && lastActiveDate != todayDate) {
      // Day has changed, reset all clock state
      isClockedInToday.value = false;
      isClockedOut.value = false;
      isOnBreak.value = false;
      setState(() {
        clockInTime = null;
        clockOutTime = null; // Reset clockOutTime
      });
      timerController.stopTimer();
      timerController.resetTimer();
      await prefs.remove('clockInTime');
      await prefs.remove('clockOutTime'); // Clear clockOutTime from storage
      await prefs.setBool('isTimerRunning', false);
      await prefs.setBool('isOnBreak', false);
      await prefs.setString('lastActiveDate', todayDate);
    }

    if (!isClockedInToday.value) {
      await clockInOutController.postClockin(
        deviceId: deviceId,
        latitude: position.latitude.toString(),
        longitude: position.longitude.toString(),
      );
      DateTime now = DateTime.now();
      DateTime clockInMinute = DateTime(
        now.year,
        now.month,
        now.day,
        now.hour,
        now.minute,
      );
      setState(() {
        clockInTime = now;
        clockOutTime = null; // Ensure clockOutTime is reset on new clock-in
      });
      isClockedInToday.value = true;
      isClockedOut.value = false;
      await prefs.setString('clockInTime', clockInMinute.toIso8601String());
      await prefs.remove('clockOutTime'); // Clear any previous clockOutTime
      await prefs.setString('lastActiveDate', todayDate);
      timerController.clockInTime = clockInMinute.toIso8601String();
      timerController.resetTimer();
      timerController.startTimer(initialSeconds: 0);
    } else {
      await clockInOutController.postClockout(
        deviceId: deviceId,
        latitude: position.latitude.toString(),
        longitude: position.longitude.toString(),
      );
      setState(() {
        clockOutTime = DateTime.now();
      });
      isClockedInToday.value = false;
      isClockedOut.value = true;
      await prefs.setString('clockOutTime', clockOutTime!.toIso8601String());
      await prefs.remove('clockInTime');
      timerController.stopTimer();
      timerController.resetTimer();
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
    if (!mounted) return;

    isOnBreak.value = isOnBreakValue;
  }

  Future<void> _handleBreak() async {
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

    // Check if the day has changed since last activity
    DateTime now = DateTime.now();
    String todayDate = DateFormat('yyyy-MM-dd').format(now);
    String? lastActiveDate = prefs.getString('lastActiveDate');

    if (lastActiveDate != null && lastActiveDate != todayDate) {
      // Day has changed, reset break state
      isOnBreak.value = false;
      await prefs.setBool('isOnBreak', false);
      await prefs.remove('breakStartTime');
      await prefs.remove('stopwatchElapsedSeconds');
      await prefs.setString('lastActiveDate', todayDate);

      // Also make sure to reset clock in state since it's a new day
      await _loadClockInState();
      return;
    }

    if (!isOnBreak.value) {
      await clockInOutController.postOnBreak(employeeId: employeeId);
      await prefs.setString('breakStartTime', DateTime.now().toIso8601String());
      await prefs.setInt('stopwatchElapsedSeconds', 0);
      await prefs.setBool('isOnBreak', true);
      await prefs.setString('lastActiveDate', todayDate);
      timerController.pauseTimer();
      timerController.startStopwatch();
      isOnBreak.value = true;
    } else {
      await clockInOutController.postResume(
        employeeId: employeeId,
        latitude: position.latitude.toString(),
        longitude: position.longitude.toString(),
      );
      int elapsedTime = timerController.stopwatchSeconds.value;
      await prefs.setInt('stopwatchElapsedSeconds', elapsedTime);
      await prefs.remove('breakStartTime');
      await prefs.remove('stopwatchElapsedSeconds');
      await prefs.setBool('isOnBreak', false);
      timerController.stopStopwatch();
      timerController.resumeTimer();
      isOnBreak.value = false;
    }

    await hasClockedinController.getClockData();
  }

  getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      log("Location denied");
      await Geolocator.requestPermission();
    } else {
      Position currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      log("Latitude: ${currentPosition.latitude}");
      log("Longitude: ${currentPosition.longitude}");
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 225.0,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: isDarkMode ? Colors.grey.shade800 : Colors.grey[100],
      ),
      child: isLoading
          ? _buildSkeletonUI(isDarkMode)
          : Stack(
              children: [
                Positioned(
                  top: 10.0,
                  left: 26.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Clock In at",
                        style: smallStyle.copyWith(
                          color: isDarkMode ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _formatTime(clockInTime),
                        style: smallStyle.copyWith(
                          color: isDarkMode ? Colors.white70 : Colors.black87,
                          // fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 10.0,
                  right: 26.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Clock Out at",
                        style: smallStyle.copyWith(
                          color: isDarkMode ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _formatTime(clockOutTime),
                        style: smallStyle.copyWith(
                          color: isDarkMode ? Colors.white70 : Colors.black87,
                          // fontSize: 10.0,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(26.0, 70.0, 26.0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildClockInTimeDisplay(isDarkMode),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildClockInOutButton(isDarkMode),
                          const SizedBox(height: 6.0),
                          Obx(() => isClockedInToday.value &&
                                  !isClockedOut.value &&
                                  !isOnBreak.value
                              ? _buildBreakButton(isDarkMode)
                              : const SizedBox.shrink()),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildSkeletonUI(bool isDarkMode) {
    return const Stack(
      children: [
        // Clock In Text
        Positioned(
          top: 10.0,
          left: 26.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonBox(height: 16, width: 80, borderRadius: 4),
              SizedBox(height: 8),
              SkeletonBox(height: 14, width: 60, borderRadius: 4),
            ],
          ),
        ),
        // Clock Out Text
        Positioned(
          top: 10.0,
          right: 26.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SkeletonBox(height: 16, width: 80, borderRadius: 4),
              SizedBox(height: 8),
              SkeletonBox(height: 14, width: 60, borderRadius: 4),
            ],
          ),
        ),
        // Clock In Time Display and Buttons
        Padding(
          padding: EdgeInsets.fromLTRB(26.0, 70.0, 26.0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Circular Progress Indicator
              SkeletonBox(height: 130, width: 130, borderRadius: 65),
              // Buttons
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SkeletonBox(height: 40, width: 100, borderRadius: 6),
                  SizedBox(height: 6),
                  SkeletonBox(height: 40, width: 100, borderRadius: 6),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildClockInTimeDisplay(bool isDarkMode) {
    return Obx(() {
      bool isClockingOut = isClockedInToday.value && !isClockedOut.value;
      double progress = isClockingOut
          ? (timerController.elapsedSeconds.value % 28800) / 28800
          : 0.0;

      return Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: 130,
            width: 130,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 8.0,
              valueColor: AlwaysStoppedAnimation(
                  isClockingOut ? Colors.red[700] : Colors.green[600]),
              backgroundColor: Colors.grey[300],
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isOnBreak.value ? "Break Time" : "Clock In Time",
                style: smallStyle.copyWith(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                isOnBreak.value
                    ? _formatStopwatchTime(
                        timerController.stopwatchSeconds.value)
                    : _formatStopwatchTime(
                        timerController.elapsedSeconds.value),
                style: smallNStyle.copyWith(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      );
    });
  }

  Widget _buildClockInOutButton(bool isDarkMode) {
    return Obx(() {
      bool isClockingOut = isClockedInToday.value && !isClockedOut.value;

      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(6)),
          ),
          backgroundColor: isClockingOut ? Colors.red[700] : Colors.green[600],
        ),
        onPressed: () {
          if (isOnBreak.value) {
            _handleBreak();
          } else {
            _handleClockInOut();
          }
        },
        child: Text(
          isClockedOut.value
              ? 'Clocked Out'
              : (isOnBreak.value
                  ? 'Resume'
                  : (isClockedInToday.value ? 'Clock Out' : 'Clock In')),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    });
  }

  Widget _buildBreakButton(bool isDarkMode) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.orange[700]),
      ),
      onPressed: _handleBreak,
      child: const Text(
        'Break',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _formatTime(DateTime? dateTime) =>
      dateTime == null ? "--:--:--" : DateFormat("h:mm:ss a").format(dateTime);

  String _formatStopwatchTime(int seconds) {
    int positiveSeconds = seconds.abs();
    int hours = positiveSeconds ~/ 3600;
    int minutes = (positiveSeconds % 3600) ~/ 60;
    int secs = positiveSeconds % 60;

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
