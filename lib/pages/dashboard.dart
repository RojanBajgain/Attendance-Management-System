import 'package:ams/components/app_bar.dart';
import 'package:ams/pages/time_off_page.dart';
import 'package:ams/widgets/logsheet_constant.dart';
import 'package:ams/widgets/toggeltext.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const ConstantAppBar(),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text(
                    "Dashboard",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24.0,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'SF_Pro',
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                Container(
                  height: 90.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Colors.grey,
                        Colors.black,
                        Colors.grey,
                        Colors.black,
                        Colors.black,
                        Colors.grey.shade200,
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      right: 10.0,
                      top: 18.0,
                      left: 22.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Hello Sushma',
                              style: TextStyle(
                                fontFamily: 'SF_Pro',
                                fontWeight: FontWeight.w500,
                                fontSize: 18.0,
                                color: Colors.grey[200],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          'Welcome to Ayata attendance',
                          style: TextStyle(
                            fontFamily: 'SF_Pro',
                            fontWeight: FontWeight.w400,
                            fontSize: 14.0,
                            color: Colors.grey[200],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                const DateTimeWidget(),
                const SizedBox(height: 10.0),
                const ClockTime(),
                const SizedBox(height: 20.0),
                Row(
                  children: [
                    Container(
                      height: 125.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        color: Colors.grey[200],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "This week time",
                              style: TextStyle(
                                fontFamily: 'SF_Pro',
                                fontSize: 16.0,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            const Text(
                              "14 h 03 m",
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'SF_Pro',
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            CustomPaint(
                              painter: ProgressBarPainter(
                                percentage: 0.6,
                                backgroundColor: Colors.grey,
                                foregroundColor: Colors.black,
                                borderRadius: 10.0,
                              ),
                              size: const Size(150, 8),
                            ),
                            const SizedBox(height: 8.0),
                            const Text(
                              "01 Nov - 07 Nov",
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'SF_Pro',
                                fontSize: 15.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Spacer(),
                    Container(
                      height: 125.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        color: Colors.grey[200],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Month time",
                              style: TextStyle(
                                fontFamily: 'SF_Pro',
                                fontSize: 16.0,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            const Text(
                              "21 h 50 m",
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'SF_Pro',
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            CustomPaint(
                              painter: ProgressBarPainter(
                                percentage: 0.5,
                                backgroundColor: Colors.grey,
                                foregroundColor: Colors.black,
                                borderRadius: 10.0,
                              ),
                              size: const Size(150, 8),
                            ),
                            const SizedBox(height: 8.0),
                            const Text(
                              "01 Nov - 30 Nov",
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'SF_Pro',
                                fontSize: 15.0,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10.0),
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Last 7 day log',
                      style: TextStyle(
                        fontFamily: 'SF_Pro',
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                const LogSheetConstant(),
                const SizedBox(height: 10.0),
                const LogSheetConstant(),
                const SizedBox(height: 10.0),
                const LogSheetConstant(),
                const SizedBox(height: 10.0),
                const LogSheetConstant(),
                const SizedBox(height: 10.0),
                const LogSheetConstant(),
                const SizedBox(height: 10.0),
                const LogSheetConstant(),
                const SizedBox(height: 10.0),
                const LogSheetConstant(),
                const SizedBox(height: 10.0),
                Row(
                  children: [
                    const Text(
                      "Time offs",
                      style: TextStyle(
                        fontFamily: 'SF_Pro',
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TimeOffPage(),
                          ),
                        );
                      },
                      child: Text(
                        "View All",
                        style: TextStyle(
                          fontFamily: 'SF_Pro',
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.blue,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                Container(
                  height: 180.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    color: Colors.grey[100],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Date',
                          style: TextStyle(
                            fontFamily: 'SF_Pro',
                            fontWeight: FontWeight.w400,
                            fontSize: 15.0,
                          ),
                        ),
                        // SizedBox(height: 5.0),
                        Row(
                          children: [
                            const Text(
                              'Jan 5, 2024 to Jan 10, 2024',
                              style: TextStyle(
                                fontFamily: 'SF_Pro',
                                fontWeight: FontWeight.w500,
                                fontSize: 15.0,
                              ),
                            ),
                            // const SizedBox(width: 20.0),
                            Spacer(),
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  Colors.red[200],
                                ),
                                foregroundColor: MaterialStateProperty.all(
                                  Colors.red[900],
                                ),
                              ),
                              onPressed: () {},
                              child: const Text('Rejected'),
                            ),
                            // const SizedBox(width: 5.0),
                            const Spacer(),
                            Icon(
                              Icons.more_vert,
                              color: Colors.black,
                            )
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        const Divider(
                          thickness: 1,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 10.0),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment
                              .spaceBetween, // Optional: for spacing
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Period',
                                  style: TextStyle(fontSize: 17.0),
                                ),
                                Text(
                                  '5 Days',
                                  style: TextStyle(
                                      fontSize: 17.0,
                                      fontFamily: 'SF_Pro',
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Type',
                                  style: TextStyle(fontSize: 17.0),
                                ),
                                Text(
                                  'Sick Leave',
                                  style: TextStyle(
                                      fontSize: 17.0,
                                      fontFamily: 'SF_Pro',
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Approved By',
                                  style: TextStyle(fontSize: 17.0),
                                ),
                                Text(
                                  'Sampurna',
                                  style: TextStyle(
                                      fontSize: 17.0,
                                      fontFamily: 'SF_Pro',
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                Container(
                  height: 180.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    color: Colors.grey[100],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 10.0,
                      left: 15.0,
                      right: 15.0,
                    ),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Date',
                          style: TextStyle(
                            fontFamily: 'SF_Pro',
                            fontWeight: FontWeight.w400,
                            fontSize: 15.0,
                          ),
                        ),
                        // SizedBox(height: 5.0),
                        Row(
                          children: [
                            const Text(
                              'Jan 5, 2024 to Jan 10, 2024',
                              style: TextStyle(
                                fontFamily: 'SF_Pro',
                                fontWeight: FontWeight.w500,
                                fontSize: 15.0,
                              ),
                            ),
                            // const SizedBox(width: 15.0),
                            Spacer(),
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  Colors.green[200],
                                ),
                                foregroundColor: MaterialStateProperty.all(
                                  Colors.green[800],
                                ),
                              ),
                              onPressed: () {},
                              child: const Text('Approved'),
                            ),
                            // SizedBox(width: 5.0),
                            Spacer(),

                            const Icon(
                              Icons.more_vert,
                              color: Colors.black,
                            )
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        const Divider(
                          thickness: 1,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 10.0),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment
                              .spaceBetween, // Optional: for spacing
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Period',
                                  style: TextStyle(fontSize: 17.0),
                                ),
                                Text(
                                  '5 Days',
                                  style: TextStyle(
                                      fontSize: 17.0,
                                      fontFamily: 'SF_Pro',
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Type',
                                  style: TextStyle(fontSize: 17.0),
                                ),
                                Text(
                                  'Sick Leave',
                                  style: TextStyle(
                                      fontSize: 17.0,
                                      fontFamily: 'SF_Pro',
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Approved By',
                                  style: TextStyle(fontSize: 17.0),
                                ),
                                Text(
                                  'Sampurna',
                                  style: TextStyle(
                                      fontSize: 17.0,
                                      fontFamily: 'SF_Pro',
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                Container(
                  height: 180.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    color: Colors.grey[100],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 10.0,
                      left: 15.0,
                      right: 15.0,
                    ),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Date',
                          style: TextStyle(
                            fontFamily: 'SF_Pro',
                            fontWeight: FontWeight.w400,
                            fontSize: 15.0,
                          ),
                        ),
                        // SizedBox(height: 5.0),
                        Row(
                          children: [
                            const Text(
                              'Jan 5, 2024 to Jan 10, 2024',
                              style: TextStyle(
                                fontFamily: 'SF_Pro',
                                fontWeight: FontWeight.w500,
                                fontSize: 15.0,
                              ),
                            ),
                            // const SizedBox(width: 15.0),
                            Spacer(),

                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  Colors.yellow[400],
                                ),
                                foregroundColor: MaterialStateProperty.all(
                                  Colors.yellow[900],
                                ),
                              ),
                              onPressed: () {},
                              child: const Text('Pending'),
                            ),
                            // SizedBox(width: 5.0),
                            Spacer(),

                            const Icon(
                              Icons.more_vert,
                              color: Colors.black,
                            )
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        const Divider(
                          thickness: 1,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 10.0),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment
                              .spaceBetween, // Optional: for spacing
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Period',
                                  style: TextStyle(fontSize: 17.0),
                                ),
                                Text(
                                  '5 Days',
                                  style: TextStyle(
                                      fontSize: 17.0,
                                      fontFamily: 'SF_Pro',
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Type',
                                  style: TextStyle(fontSize: 17.0),
                                ),
                                Text(
                                  'Sick Leave',
                                  style: TextStyle(
                                      fontSize: 17.0,
                                      fontFamily: 'SF_Pro',
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Approved By',
                                  style: TextStyle(fontSize: 17.0),
                                ),
                                Text(
                                  'Sampurna',
                                  style: TextStyle(
                                      fontSize: 17.0,
                                      fontFamily: 'SF_Pro',
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Holidays & Events",
                      style: TextStyle(
                        fontFamily: 'SF_Pro',
                        fontSize: 22.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    ToggleTextWidget(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DateTimeWidget extends StatefulWidget {
  const DateTimeWidget({super.key});

  @override
  State<DateTimeWidget> createState() => _DateTimeWidgetState();
}

class _DateTimeWidgetState extends State<DateTimeWidget> {
  DateTime _focusDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return EasyDateTimeLine(
      initialDate: DateTime.now(),
      onDateChange: (selectedDate) {
        setState(() {
          _focusDate = selectedDate;
        });
      },
      headerProps: const EasyHeaderProps(
          // monthPickerType: MonthPickerType.switcher,
          // dateFormatter: DateFormatter.fullDateDMY(),
          ),
      dayProps: const EasyDayProps(
        dayStructure: DayStructure.dayStrDayNum,
        activeDayStyle: DayStyle(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF131213),
                Color(0xFF131213),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ClockTime extends StatefulWidget {
  const ClockTime({super.key});

  @override
  State<ClockTime> createState() => _ClockTimeState();
}

class _ClockTimeState extends State<ClockTime> {
  bool _isRunning = false;
  int _elapsedSeconds = 0;
  Timer? _timer;
  static const int _maxSeconds =
      3600; // Progress indicator loops every hour (3600 seconds)

  @override
  void dispose() {
    _timer?.cancel(); // Cancel timer when widget is disposed
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedSeconds++;
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  void _resetTimer() {
    setState(() {
      _elapsedSeconds = 0;
    });
  }

  String _formatTime(int seconds) {
    final hours = (seconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$secs';
  }

  @override
  Widget build(BuildContext context) {
    double progressValue = (_elapsedSeconds % _maxSeconds) / _maxSeconds;

    return Container(
      height: 250.0,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        color: Colors.grey[50],
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 5,
            spreadRadius: 1,
            offset: const Offset(0, 5), // vertical offset
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Row(
          // crossAxisAlignment: CrossAxisAlignment.center,
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
                  _formatTime(_elapsedSeconds),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red[700]),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                  onPressed: () {
                    setState(() {
                      if (_isRunning) {
                        _stopTimer();
                      } else {
                        _startTimer();
                      }
                      _isRunning = !_isRunning;
                    });
                  },
                  child: Text(
                    _isRunning ? 'Clock Out' : 'Clock In',
                    style: const TextStyle(
                      fontFamily: 'SF_Pro',
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                    ),
                  ),
                ),
                // const SizedBox(width: 20),
                // ElevatedButton(
                //   onPressed: () {
                //     _stopTimer();
                //     _resetTimer();
                //     setState(() {
                //       _isRunning = false;
                //     });
                //   },
                //   child: const Text(
                //     'Reset',
                //     style: TextStyle(
                //       fontFamily: 'Mukta',
                //       fontWeight: FontWeight.bold,
                //       fontSize: 15.0,
                //     ),
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ProgressBarPainter extends CustomPainter {
  final double percentage;
  final Color backgroundColor;
  final Color foregroundColor;
  final double borderRadius;

  ProgressBarPainter({
    required this.percentage,
    required this.backgroundColor,
    required this.foregroundColor,
    this.borderRadius = 8.0, // Default border radius
  });

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    final foregroundPaint = Paint()
      ..color = foregroundColor
      ..style = PaintingStyle.fill;

    // Draw the background with rounded corners
    final backgroundRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(borderRadius),
    );
    canvas.drawRRect(backgroundRRect, backgroundPaint);

    // Draw the filled portion with rounded corners
    double filledWidth = size.width * percentage;
    final foregroundRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, filledWidth, size.height),
      Radius.circular(borderRadius),
    );
    canvas.drawRRect(foregroundRRect, foregroundPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Repaint whenever there's a change
  }
}
