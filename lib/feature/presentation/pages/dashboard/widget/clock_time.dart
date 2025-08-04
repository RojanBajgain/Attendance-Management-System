import 'package:ams/feature/presentation/pages/dashboard/widget/skeleton_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ams/config/resources/styles.dart';
import 'package:ams/feature/utils/ssnackbar_utils.dart';
import 'package:ams/feature/presentation/pages/dashboard/controller/clock_in_out_controller.dart';
import 'package:ams/feature/presentation/pages/dashboard/controller/has_clockedIn_controller.dart';
import 'package:ams/feature/presentation/pages/dashboard/controller/timer_controller.dart';
import 'package:ams/feature/presentation/pages/profile/controller/profile_controller.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:developer';

import 'package:tap_debouncer/tap_debouncer.dart';

class ClockTime extends StatefulWidget {
  const ClockTime({super.key});

  @override
  State<ClockTime> createState() => _ClockTimeState();
}

class _ClockTimeState extends State<ClockTime> {
  final profileController = Get.put(ProfileController(profileRepo: Get.find()));

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
  RxBool isLoadingAction = false.obs;
  bool isMobileEnabled = true;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _fetchOfficeLocation();
    await _checkMobileEnabled();

    // FIXED: Check if profile exists and has valid user records
    if (profileController.profile.value != null &&
        profileController.profile.value!.userRecords.isNotEmpty &&
        profileController.profile.value!.userRecords.first.employeeNo != null) {
      await hasClockedinController.handleUserChanged();
    }

    await hasClockedinController.getClockData();
    await _loadClockInState();
    await _loadBreakState();

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _checkMobileEnabled() async {
    try {
      final GetStorage box = GetStorage();
      final selectedOrganization = box.read('selectedOrganization');
      if (selectedOrganization != null) {
        isMobileEnabled = selectedOrganization['mobile_enabled'] ?? true;
        log("Mobile enabled status: $isMobileEnabled");
      }
    } catch (e) {
      log("Error checking mobile enabled status: $e");
      isMobileEnabled = true;
    }
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
    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    DateTime now = DateTime.now();
    String todayDate = DateFormat('yyyy-MM-dd').format(now);

    // Check if the last active date is different from today
    String? lastActiveDate = prefs.getString('lastActiveDate');
    if (lastActiveDate != null && lastActiveDate != todayDate) {
      // Day has changed, reset clock data
      _resetClockData(prefs);
    }

    // Update the last active date
    await prefs.setString('lastActiveDate', todayDate);

    // Get clock-in time from the API controller
    DateTime? apiClockInTime = hasClockedinController.clockedInTime.value;
    log("Loaded Clock-In Time from API: $apiClockInTime");

    if (apiClockInTime != null &&
        DateFormat('yyyy-MM-dd').format(apiClockInTime) == todayDate) {
      // Create a DateTime with just hours and minutes for consistent calculations
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

      // Store the clock-in time in SharedPreferences to ensure consistency
      await prefs.setString('clockInTime', clockInMinute.toIso8601String());

      // Explicitly set the clockInTime in timerController
      timerController.clockInTime = clockInMinute.toIso8601String();

      // Only start timer if it's not already running and not on break
      if (!timerController.isRunning.value && !isOnBreak.value) {
        int elapsed = now.difference(clockInMinute).inSeconds;
        if (elapsed < 0) elapsed = 0;

        timerController.resetTimer();
        timerController.startTimer(initialSeconds: elapsed);
      }
    } else {
      // No valid clock-in from API, reset everything
      _resetClockData(prefs);
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

  void _resetClockData(SharedPreferences prefs) async {
    isClockedInToday.value = false;
    isClockedOut.value = false;
    isOnBreak.value = false;

    setState(() {
      clockInTime = null;
      clockOutTime = null;
    });

    timerController.stopTimer();
    timerController.resetTimer();

    await prefs.remove('clockInTime');
    await prefs.remove('clockOutTime');
    await prefs.setBool('isTimerRunning', false);
    await prefs.setBool('isOnBreak', false);
    await prefs.remove('breakStartTime');
    await prefs.remove('stopwatchElapsedSeconds');
  }

  Future<bool> _checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      SSnackbarUtil.showFadeSnackbar(
        Get.context!,
        "Enable Location permission in setting",
        SnackbarType.error,
      );
      return false;
    }
    return permission != LocationPermission.denied;
  }

  Future<void> _handleClockInOut() async {
    if (!await _checkLocationPermission()) return;

    await Get.showOverlay(
      asyncFunction: () async {
        try {
          Position position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.best);
          int? deviceId =
              profileController.profile.value?.userRecords.first.employeeNo;
          if (deviceId == null) {
            SSnackbarUtil.showFadeSnackbar(
              Get.context!,
              "Device info not found. Please log in again.",
              SnackbarType.error,
            );
            return;
          }

          final prefs = await SharedPreferences.getInstance();
          DateTime now = DateTime.now();
          String todayDate = DateFormat('yyyy-MM-dd').format(now);
          String? lastActiveDate = prefs.getString('lastActiveDate');

          if (lastActiveDate != null && lastActiveDate != todayDate) {
            _resetClockData(prefs);
            await prefs.setString('lastActiveDate', todayDate);
          }

          if (!isClockedInToday.value) {
            // Clocking in
            await clockInOutController.postClockin(
              deviceId: deviceId,
              latitude: position.latitude.toString(),
              longitude: position.longitude.toString(),
            );

            DateTime clockInMinute = DateTime(
              now.year,
              now.month,
              now.day,
              now.hour,
              now.minute,
            );

            setState(() {
              clockInTime = now;
              clockOutTime = null;
            });

            isClockedInToday.value = true;
            isClockedOut.value = false;

            await prefs.setString(
                'clockInTime', clockInMinute.toIso8601String());
            await prefs.remove('clockOutTime');
            await prefs.setString('lastActiveDate', todayDate);

            timerController.clockInTime = clockInMinute.toIso8601String();
            timerController.resetTimer();
            timerController.startTimer(initialSeconds: 0);
          } else {
            // Clocking out
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

            await prefs.setString(
                'clockOutTime', clockOutTime!.toIso8601String());
            await prefs.remove('clockInTime');

            timerController.stopTimer();
            timerController.resetTimer();
          }

          await hasClockedinController.getClockData();
          await _loadClockInState();
        } catch (e) {
          SSnackbarUtil.showFadeSnackbar(
            Get.context!,
            "Failed to complete action: ${e.toString()}",
            SnackbarType.error,
          );
          rethrow; // Important to let the overlay know there was an error
        }
      },
      loadingWidget: const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      ),
      opacity: 0.5,
      opacityColor: Colors.black,
    );
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
    await Get.showOverlay(
      asyncFunction: () async {
        try {
          final prefs = await SharedPreferences.getInstance();
          if (!await _checkLocationPermission()) return;

          Position position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.best);
          int? employeeId =
              profileController.profile.value?.userRecords.first.employeeNo;
          if (employeeId == null) {
            SSnackbarUtil.showFadeSnackbar(
              Get.context!,
              "Employee info not found. Please log in again.",
              SnackbarType.error,
            );
            return;
          }

          DateTime now = DateTime.now();
          String todayDate = DateFormat('yyyy-MM-dd').format(now);
          String? lastActiveDate = prefs.getString('lastActiveDate');

          if (lastActiveDate != null && lastActiveDate != todayDate) {
            isOnBreak.value = false;
            await prefs.setBool('isOnBreak', false);
            await prefs.remove('breakStartTime');
            await prefs.remove('stopwatchElapsedSeconds');
            await prefs.setString('lastActiveDate', todayDate);
            await _loadClockInState();
            if (mounted) {
              setState(() {});
            }
            return;
          }

          if (!isOnBreak.value) {
            await clockInOutController.postOnBreak(employeeId: employeeId);
            await prefs.setString(
                'breakStartTime', DateTime.now().toIso8601String());
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

          if (mounted) {
            setState(() {});
          }

          await hasClockedinController.getClockData();
          await _loadClockInState();
        } catch (e) {
          SSnackbarUtil.showFadeSnackbar(
            Get.context!,
            "Failed to complete break action: ${e.toString()}",
            SnackbarType.error,
          );
          rethrow; // Important to let the overlay know there was an error
        }
      },
      loadingWidget: const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      ),
      opacity: 0.5,
      opacityColor: Colors.black,
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      // height: 225.0,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: isDarkMode ? Colors.grey.shade800 : Colors.grey[100],
      ),
      child: isLoading
          ? _buildSkeletonUI(isDarkMode)
          : isMobileEnabled
              ? _buildNormalUI(isDarkMode)
              : _buildDisabledUI(isDarkMode),
    );
  }

  Widget _buildNormalUI(bool isDarkMode) {
    return Column(
      children: [
        // Check In/Out header row
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: Colors.blueGrey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Clock In Time
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Check In At",
                    style: smallStyle.copyWith(
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0,
                    ),
                  ),
                  Text(
                    _formatTime(clockInTime),
                    style: smallStyle.copyWith(
                      color: isDarkMode ? Colors.white70 : Colors.black87,
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),

              // Clock Out Time
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Check Out At",
                    style: smallStyle.copyWith(
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0,
                    ),
                  ),
                  Text(
                    _formatTime(clockOutTime),
                    style: smallStyle.copyWith(
                      color: isDarkMode ? Colors.white70 : Colors.black87,
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ).paddingOnly(left: 16, right: 16, bottom: 12),

        // Main content
        Padding(
          padding: const EdgeInsets.fromLTRB(26.0, 12.0, 26.0, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildClockInTimeDisplay(isDarkMode),
              const SizedBox(height: 20.0),
              ConstrainedBox(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.5),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildClockInOutButton(isDarkMode),
                    const SizedBox(width: 20.0),
                    Obx(() => isClockedInToday.value &&
                            !isClockedOut.value &&
                            !isOnBreak.value
                        ? _buildBreakButton(isDarkMode)
                        : const SizedBox.shrink()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDisabledUI(bool isDarkMode) {
    return Column(
      children: [
        // Clock In Time
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Clock In Time
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Check In At",
                    style: smallStyle.copyWith(
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0,
                    ),
                  ),
                  Text(
                    _formatTime(clockInTime),
                    style: smallStyle.copyWith(
                      color: isDarkMode ? Colors.white70 : Colors.black87,
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),

              // Clock Out Time
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Check Out At",
                    style: smallStyle.copyWith(
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0,
                    ),
                  ),
                  Text(
                    _formatTime(clockOutTime),
                    style: smallStyle.copyWith(
                      color: isDarkMode ? Colors.white70 : Colors.black87,
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Centered Clock-time circular indicator (no buttons)
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 22.0),
            child: _buildClockInTimeDisplay(isDarkMode),
          ),
        ),
      ],
    );
  }

  Widget _buildSkeletonUI(bool isDarkMode) {
    return Column(
      children: [
        // Header row skeleton
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Clock In skeleton
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonBox(
                    height: 16,
                    width: 80,
                    borderRadius: 4,
                    color: isDarkMode
                        ? Colors.grey.shade600
                        : Colors.grey.shade300,
                  ),
                  const SizedBox(height: 8),
                  SkeletonBox(
                    height: 14,
                    width: 60,
                    borderRadius: 4,
                    color: isDarkMode
                        ? Colors.grey.shade600
                        : Colors.grey.shade300,
                  ),
                ],
              ),
              // Clock Out skeleton
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SkeletonBox(
                    height: 16,
                    width: 80,
                    borderRadius: 4,
                    color: isDarkMode
                        ? Colors.grey.shade600
                        : Colors.grey.shade300,
                  ),
                  const SizedBox(height: 8),
                  SkeletonBox(
                    height: 14,
                    width: 60,
                    borderRadius: 4,
                    color: isDarkMode
                        ? Colors.grey.shade600
                        : Colors.grey.shade300,
                  ),
                ],
              ),
            ],
          ),
        ),

        // Main content skeleton
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26.0, vertical: 20.0),
          child: Column(
            children: [
              // Circular progress skeleton
              Center(
                child: Shimmer.fromColors(
                  baseColor:
                      isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
                  highlightColor:
                      isDarkMode ? Colors.grey.shade600 : Colors.grey.shade100,
                  child: Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDarkMode ? Colors.grey.shade800 : Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Buttons row skeleton
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SkeletonBox(
                    height: 40,
                    width: 100,
                    borderRadius: 8,
                    color: isDarkMode
                        ? Colors.grey.shade600
                        : Colors.grey.shade300,
                  ),
                  const SizedBox(width: 20),
                  SkeletonBox(
                    height: 40,
                    width: 40,
                    borderRadius: 20,
                    color: isDarkMode
                        ? Colors.grey.shade600
                        : Colors.grey.shade300,
                  ),
                ],
              ),

              // Time text skeleton
              // const SizedBox(height: 20),
              // Column(
              //   children: [
              //     SkeletonBox(
              //       height: 16,
              //       width: 100,
              //       borderRadius: 4,
              //       color: isDarkMode
              //           ? Colors.grey.shade600
              //           : Colors.grey.shade300,
              //     ),
              //     const SizedBox(height: 8),
              //     SkeletonBox(
              //       height: 20,
              //       width: 80,
              //       borderRadius: 4,
              //       color: isDarkMode
              //           ? Colors.grey.shade600
              //           : Colors.grey.shade300,
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildClockInTimeDisplay(bool isDarkMode) {
    return Obx(() {
      bool isClockingOut = isClockedInToday.value && !isClockedOut.value;
      // Standard 8-hour workday (28800 seconds)
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
              strokeWidth: 10.0,
              valueColor: AlwaysStoppedAnimation(
                  isClockingOut ? Colors.green : Colors.green[600]),
              backgroundColor: Colors.grey[300],
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isOnBreak.value ? "Break Time" : "Elapsed Time",
                style: smallStyle.copyWith(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 12.0,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "${isOnBreak.value ? _formatStopwatchTime(timerController.stopwatchSeconds.value) : _formatStopwatchTime(timerController.elapsedSeconds.value)} Hrs",
                style: smallNStyle.copyWith(
                  color: isDarkMode ? Colors.green : Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 12.0,
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

      // Define icon, text, and color based on state
      IconData buttonIcon;
      String buttonText;
      Color buttonColor;

      if (isOnBreak.value) {
        buttonIcon = Icons.play_arrow;
        buttonText = 'Resume';
        buttonColor = Colors.orange[700]!;
      } else if (isClockedOut.value) {
        buttonIcon = Icons.check_circle;
        buttonText = 'Checked';
        buttonColor = Colors.grey[600]!;
      } else if (isClockedInToday.value) {
        buttonIcon = Icons.logout;
        buttonText = 'Check Out';
        buttonColor = Colors.red[700]!;
      } else {
        buttonIcon = Icons.login;
        buttonText = 'Check In';
        buttonColor = Colors.green[600]!;
      }

      return TapDebouncer(
        cooldown: const Duration(milliseconds: 200),
        onTap: () async {
          if (isOnBreak.value) {
            await _handleBreak();
          } else {
            await _handleClockInOut();
          }
          if (mounted) {
            setState(() {});
          }
        },
        builder: (BuildContext context, TapDebouncerFunc? onTap) {
          return Material(
            color: Colors.transparent,
            child: InkWell(
              splashColor: Colors.grey.withOpacity(0.6),
              highlightColor: Colors.grey.withOpacity(0.6),
              borderRadius: BorderRadius.circular(20),
              onTap: onTap,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: buttonColor,
                ),
                constraints: const BoxConstraints(
                  minWidth: 100,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      buttonIcon,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      buttonText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildBreakButton(bool isDarkMode) {
    return TapDebouncer(
      cooldown: const Duration(seconds: 3),
      onTap: () async {
        _handleBreak();
      },
      builder: (BuildContext context, TapDebouncerFunc? onTap) {
        return Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.orange[700],
          ),
          child: IconButton(
            onPressed: onTap,
            icon: const Icon(
              Icons.coffee,
              color: Colors.white,
              size: 24,
            ),
          ),
        );
      },
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
