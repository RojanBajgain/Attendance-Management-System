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

  Future<void> startTimer({bool fromResume = false}) async {
    if (isRunning.value) return;

    final prefs = await SharedPreferences.getInstance();

    // Load elapsed time from SharedPreferences if resuming
    if (!fromResume) {
      elapsedSeconds.value = 0;
      await prefs.setInt('elapsedSeconds', 0);
    } else {
      elapsedSeconds.value = prefs.getInt('elapsedSeconds') ?? 0;
    }

    isRunning.value = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      elapsedSeconds.value++;
      await prefs.setInt('elapsedSeconds', elapsedSeconds.value);
    });

    clockInTime = _getCurrentTime();
    await prefs.setString('clockInTime', clockInTime!);
  }

  Future<void> pauseTimer() async {
    _timer?.cancel();
    isRunning.value = false;
  }

  Future<void> resumeTimer() async {
    if (isRunning.value) return;
    await startTimer(fromResume: true);
  }

  void startStopwatch({int initialSeconds = 0}) {
    if (isStopwatchRunning.value) return;

    isStopwatchRunning.value = true;
    stopwatchSeconds.value = initialSeconds;
    _stopwatchTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      stopwatchSeconds.value++;

      if (stopwatchSeconds.value % 10 == 0) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('stopwatchElapsedSeconds', stopwatchSeconds.value);
      }
    });
  }

  void stopStopwatch() {
    _stopwatchTimer?.cancel();
    isStopwatchRunning.value = false;
    stopwatchSeconds.value = 0;
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
    await prefs.remove('elapsedSeconds');
    await prefs.remove('stopwatchElapsedSeconds');
    await prefs.remove('clockInTime');
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    final hour = now.hour > 12 ? now.hour - 12 : now.hour;
    final period = now.hour >= 12 ? "PM" : "AM";
    return "${hour.toString().padLeft(2, '0')}:"
        "${now.minute.toString().padLeft(2, '0')}:"
        "${now.second.toString().padLeft(2, '0')} $period";
  }

  @override
  void onClose() {
    _timer?.cancel();
    _stopwatchTimer?.cancel();
    super.onClose();
  }
}
