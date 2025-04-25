import 'dart:async';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TimerController extends GetxController {
  var elapsedSeconds = 0.obs;
  var isRunning = false.obs;
  String? clockInTime;
  Timer? _timer;

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

    if (storedClockInTime != null) {
      clockInTime = storedClockInTime;
      DateTime clockInDateTime = DateTime.parse(storedClockInTime);

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
    }

    // Load stopwatch state if on break
    if (prefs.getBool('isOnBreak') ?? false) {
      String? breakStartTime = prefs.getString('breakStartTime');
      if (breakStartTime != null) {
        DateTime breakStart = DateTime.parse(breakStartTime);
        int breakElapsed = DateTime.now().difference(breakStart).inSeconds;
        if (breakElapsed >= 0) {
          stopwatchSeconds.value = breakElapsed;
          _startStopwatchWithoutSaving(initialSeconds: breakElapsed);
        }
      }
    }
  }

  // Private method to start timer without saving state (for initialization)
  void _startTimerWithoutSaving({int initialSeconds = 0}) {
    isRunning.value = true;
    elapsedSeconds.value = initialSeconds;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      elapsedSeconds.value++;
    });
  }

  // Private method to start stopwatch without saving state (for initialization)
  void _startStopwatchWithoutSaving({int initialSeconds = 0}) {
    isStopwatchRunning.value = true;
    stopwatchSeconds.value = initialSeconds;

    _stopwatchTimer?.cancel();
    _stopwatchTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      stopwatchSeconds.value++;
    });
  }

  Future<void> startTimer({int initialSeconds = 0}) async {
    if (isRunning.value) return;

    final prefs = await SharedPreferences.getInstance();
    isRunning.value = true;
    elapsedSeconds.value = initialSeconds;

    // Save that timer is running
    await prefs.setBool('isTimerRunning', true);

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      elapsedSeconds.value++;
      // Persist elapsed seconds periodically to avoid excessive writes
      if (elapsedSeconds.value % 10 == 0) {
        await prefs.setInt('elapsedSeconds', elapsedSeconds.value);
      }
    });

    // Persist clock-in time if provided
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
    if (storedClockInTime != null) {
      clockInTime = storedClockInTime;
      final clockInDateTime = DateTime.parse(storedClockInTime);
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

    _stopwatchTimer?.cancel();
    _stopwatchTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      stopwatchSeconds.value++;
      if (stopwatchSeconds.value % 10 == 0) {
        await prefs.setInt('stopwatchElapsedSeconds', stopwatchSeconds.value);
      }
    });

    // Record that stopwatch is running
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
