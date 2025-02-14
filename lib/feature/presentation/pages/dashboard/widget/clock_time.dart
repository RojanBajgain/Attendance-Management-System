import 'package:ams/feature/presentation/pages/dashboard/widget/time_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ClockTime extends StatefulWidget {
  const ClockTime({super.key});

  @override
  State<ClockTime> createState() => _ClockTimeState();
}

class _ClockTimeState extends State<ClockTime> {
  final TimerManager _timerManager = TimerManager();
  static const int _maxSeconds = 3600;

  @override
  void initState() {
    super.initState();
    _initializeTimer();
  }

  Future<void> _initializeTimer() async {
    // Ensure the state is loaded and timer resumes if running
    if (_timerManager.isRunning) {
      _timerManager.startTimer(() {
        setState(() {});
      });
    }
    setState(() {}); // Update UI after loading
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    double progressValue =
        (_timerManager.elapsedSeconds % _maxSeconds) / _maxSeconds;

    return Container(
      height: 250.0,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        color: isDarkMode ? Colors.grey.shade800 : Colors.grey[50],
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.grey.shade800
                : Colors.grey.withOpacity(0.5),
            blurRadius: 2,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 150,
                  width: 150,
                  child: CircularProgressIndicator(
                    value: progressValue,
                    strokeWidth: 10.0,
                    valueColor: const AlwaysStoppedAnimation(Colors.green),
                    backgroundColor: Colors.grey[300],
                  ),
                ),
                Text(
                  _formatTime(_timerManager.elapsedSeconds),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'SF_Pro',
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
              width: 60.0,
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  _timerManager.isRunning ? Colors.red[700] : Colors.green[600],
                ),
                foregroundColor: MaterialStateProperty.all(Colors.white),
              ),
              onPressed: () {
                setState(() {
                  if (_timerManager.isRunning) {
                    _timerManager.stopTimer();
                  } else {
                    _timerManager.startTimer(() {
                      setState(() {});
                    });
                  }
                });
              },
              child: Text(
                _timerManager.isRunning ? 'Clock Out' : 'Clock In',
                style: const TextStyle(
                  fontFamily: 'SF_Pro',
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(int seconds) {
    final hours = (seconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$secs';
  }
}
