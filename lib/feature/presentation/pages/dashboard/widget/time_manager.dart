import 'dart:async';
import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';

class TimerManager {
  static final TimerManager _instance = TimerManager._internal();
  factory TimerManager() => _instance;

  TimerManager._internal();

  bool isRunning = false;
  int elapsedSeconds = 0;
  Timer? _timer;

  Future<void> loadState() async {
    final prefs = await SharedPreferences.getInstance();
    elapsedSeconds = prefs.getInt('elapsed_time') ?? 0;
    isRunning = prefs.getBool('is_running') ?? false;
  }

  Future<void> saveState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('elapsed_time', elapsedSeconds);
    await prefs.setBool('is_running', isRunning);
  }

  void startTimer(VoidCallback updateCallback) {
    if (_timer != null) return; // Avoid multiple timers
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      elapsedSeconds++;
      updateCallback();
      saveState(); // Save every tick
    });
    isRunning = true;
    saveState();
  }

  void stopTimer() {
    _timer?.cancel();
    _timer = null;
    isRunning = false;
    saveState();
  }
}
