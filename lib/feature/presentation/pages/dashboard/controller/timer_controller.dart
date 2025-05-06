import 'dart:async';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class TimerController extends GetxController {
  var elapsedSeconds = 0.obs;
  var isRunning = false.obs;
  String? clockInTime;
  Timer? _timer;
  String? _lastRunDate; // Track the last date the timer was running

  var stopwatchSeconds = 0.obs;
  var isStopwatchRunning = false.obs;
  Timer? _stopwatchTimer;

  @override
  void onInit() {
    super.onInit();
    _loadSavedState();
  }

  Future<void> _loadSavedState() async {
    final prefs = await SharedPreferences.getInstance();
    String? storedClockInTime = prefs.getString('clockInTime');
    _lastRunDate = prefs.getString('lastRunDate');
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // Check if the day has changed since last run
    bool dayChanged = _lastRunDate != null && _lastRunDate != today;

    if (dayChanged) {
      // Reset the timer if day has changed
      await stopTimer();
      await prefs.setString('lastRunDate', today);
      return;
    }

    if (storedClockInTime != null) {
      clockInTime = storedClockInTime;
      DateTime clockInDateTime = DateTime.parse(storedClockInTime);

      // Only count elapsed time if it's from the same day
      String clockInDate = DateFormat('yyyy-MM-dd').format(clockInDateTime);
      if (clockInDate == today) {
        // Truncate to minute for consistency
        clockInDateTime = DateTime(
          clockInDateTime.year,
          clockInDateTime.month,
          clockInDateTime.day,
          clockInDateTime.hour,
          clockInDateTime.minute,
        );

        int elapsed = DateTime.now().difference(clockInDateTime).inSeconds;
        if (elapsed >= 0) {
          elapsedSeconds.value = elapsed;

          // Check if timer should be running
          bool shouldBeRunning = prefs.getBool('isTimerRunning') ?? false;
          bool isOnBreak = prefs.getBool('isOnBreak') ?? false;

          if (shouldBeRunning && !isOnBreak) {
            _startTimerWithoutSaving(initialSeconds: elapsed);
          }
        }
      } else {
        // If clock in is from a different day, reset it
        await stopTimer();
      }
    }

    // Load stopwatch state if on break
    if (prefs.getBool('isOnBreak') ?? false) {
      String? breakStartTime = prefs.getString('breakStartTime');
      if (breakStartTime != null) {
        DateTime breakStart = DateTime.parse(breakStartTime);

        // Only count break time if it's from the same day
        String breakDate = DateFormat('yyyy-MM-dd').format(breakStart);
        if (breakDate == today) {
          int breakElapsed = DateTime.now().difference(breakStart).inSeconds;
          if (breakElapsed >= 0) {
            stopwatchSeconds.value = breakElapsed;
            _startStopwatchWithoutSaving(initialSeconds: breakElapsed);
          }
        } else {
          // If break started on a different day, reset it
          await stopStopwatch();
          await prefs.setBool('isOnBreak', false);
        }
      }
    }

    // Update the last run date
    await prefs.setString('lastRunDate', today);
  }

  void _startTimerWithoutSaving({int initialSeconds = 0}) {
    isRunning.value = true;
    elapsedSeconds.value = initialSeconds;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      elapsedSeconds.value++;
      _checkForDayChange();
    });
  }

  void _startStopwatchWithoutSaving({int initialSeconds = 0}) {
    isStopwatchRunning.value = true;
    stopwatchSeconds.value = initialSeconds;

    _stopwatchTimer?.cancel();
    _stopwatchTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      stopwatchSeconds.value++;
      _checkForDayChange();
    });
  }

  // Check if day has changed and reset timers if needed
  Future<void> _checkForDayChange() async {
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final prefs = await SharedPreferences.getInstance();
    String? savedDate = prefs.getString('lastRunDate');

    if (savedDate != null && savedDate != today) {
      // Day has changed, reset everything
      await stopTimer();
      await stopStopwatch();
      await prefs.setBool('isOnBreak', false);
      await prefs.setString('lastRunDate', today);
    }
  }

  Future<void> startTimer({int initialSeconds = 0}) async {
    if (isRunning.value) return;

    final prefs = await SharedPreferences.getInstance();
    isRunning.value = true;
    elapsedSeconds.value = initialSeconds;

    // Store current date
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    await prefs.setString('lastRunDate', today);
    await prefs.setBool('isTimerRunning', true);

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      elapsedSeconds.value++;
      _checkForDayChange();
      if (elapsedSeconds.value % 10 == 0) {
        await prefs.setInt('elapsedSeconds', elapsedSeconds.value);
      }
    });

    if (clockInTime != null) {
      await prefs.setString('clockInTime', clockInTime!);
    }
  }

  Future<void> pauseTimer() async {
    _timer?.cancel();
    isRunning.value = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isTimerRunning', false);
    await prefs.setInt('elapsedSeconds', elapsedSeconds.value);
  }

  Future<void> resumeTimer() async {
    if (isRunning.value) return;

    final prefs = await SharedPreferences.getInstance();
    final storedClockInTime = prefs.getString('clockInTime');
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    if (storedClockInTime != null) {
      clockInTime = storedClockInTime;
      final clockInDateTime = DateTime.parse(storedClockInTime);

      // Check if clock in is from today
      String clockInDate = DateFormat('yyyy-MM-dd').format(clockInDateTime);
      if (clockInDate != today) {
        // If not today, reset the timer instead of resuming
        await stopTimer();
        return;
      }

      // Truncate to minute
      final truncatedClockIn = DateTime(
        clockInDateTime.year,
        clockInDateTime.month,
        clockInDateTime.day,
        clockInDateTime.hour,
        clockInDateTime.minute,
      );
      final elapsed = DateTime.now().difference(truncatedClockIn).inSeconds;
      if (elapsed >= 0) {
        await startTimer(initialSeconds: elapsed);
      } else {
        await startTimer(initialSeconds: 0);
      }
    }
  }

  Future<void> startStopwatch({int initialSeconds = 0}) async {
    if (isStopwatchRunning.value) return;

    final prefs = await SharedPreferences.getInstance();
    isStopwatchRunning.value = true;
    stopwatchSeconds.value = initialSeconds;

    // Store current date
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    await prefs.setString('lastRunDate', today);

    _stopwatchTimer?.cancel();
    _stopwatchTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      stopwatchSeconds.value++;
      _checkForDayChange();
      if (stopwatchSeconds.value % 10 == 0) {
        await prefs.setInt('stopwatchElapsedSeconds', stopwatchSeconds.value);
      }
    });

    await prefs.setBool('isStopwatchRunning', true);
  }

  Future<void> stopStopwatch() async {
    _stopwatchTimer?.cancel();
    isStopwatchRunning.value = false;
    stopwatchSeconds.value = 0;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isStopwatchRunning', false);
    await prefs.remove('stopwatchElapsedSeconds');
  }

  Future<void> stopTimer() async {
    _timer?.cancel();
    _stopwatchTimer?.cancel();
    isRunning.value = false;
    isStopwatchRunning.value = false;
    elapsedSeconds.value = 0;
    stopwatchSeconds.value = 0;
    clockInTime = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isTimerRunning', false);
    await prefs.setBool('isStopwatchRunning', false);
    await prefs.remove('elapsedSeconds');
    await prefs.remove('stopwatchElapsedSeconds');
    await prefs.remove('clockInTime');
  }

  Future<void> resetTimer() async {
    elapsedSeconds.value = 0;
    if (isRunning.value) {
      _timer?.cancel();
      await startTimer(initialSeconds: 0);
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    _stopwatchTimer?.cancel();
    super.onClose();
  }
}
