import 'package:ams/config/resources/styles.dart';
import 'package:ams/feature/presentation/pages/dashboard/sub_view_dashboard/timeoff_view.dart';
import 'package:ams/feature/presentation/pages/dashboard/widget/clock_time.dart';
import 'package:ams/feature/presentation/widget/components/app_bar.dart';
import 'package:ams/feature/presentation/pages/timeoff/time_off_page.dart';
import 'package:ams/feature/presentation/pages/dashboard/sub_view_dashboard/logsheet_constant.dart';
import 'package:ams/feature/presentation/pages/dashboard/sub_view_dashboard/holiday_event_notification_page.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: const ConstantAppBar(),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    "Dashboard",
                    style: normalStyle.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 15.0),
                Shimmer(
                  duration: const Duration(seconds: 3),
                  interval: const Duration(seconds: 2),
                  child: Container(
                    height: 90.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          isDarkMode ? Colors.white : Colors.grey,
                          isDarkMode ? Colors.grey : Colors.black,
                          isDarkMode ? Colors.white : Colors.grey,
                          isDarkMode ? Colors.grey : Colors.black,
                          isDarkMode ? Colors.grey : Colors.black,
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
                                style: normalStyle.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: isDarkMode
                                        ? Colors.black
                                        : Colors.grey[200]),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5.0),
                          Text(
                            'Welcome to Ayata attendance management system',
                            style: miniStyle.copyWith(
                              fontWeight: FontWeight.w400,
                              color:
                                  isDarkMode ? Colors.black : Colors.grey[200],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                // const DateTimeWidget(),
                const SizedBox(height: 10.0),
                const ClockTime(),
                const SizedBox(height: 20.0),
                Row(
                  children: [
                    Container(
                      height: 125.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        color: isDarkMode
                            ? Colors.grey.shade800
                            : Colors.grey[200],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "This week time",
                              // style: normalStyle.copyWith(
                              //     color:
                              //         isDarkMode ? Colors.white : Colors.black),
                              style: TextStyle(
                                fontFamily: 'SF_Pro',
                                fontSize: 16.0,
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              "14 h 03 m",
                              style: TextStyle(
                                color: isDarkMode ? Colors.white : Colors.black,
                                fontFamily: 'SF_Pro',
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            CustomPaint(
                              painter: ProgressBarPainter(
                                percentage: 0.6,
                                backgroundColor: isDarkMode
                                    ? Colors.grey.shade600
                                    : Colors.grey,
                                foregroundColor:
                                    isDarkMode ? Colors.white : Colors.black,
                                borderRadius: 10.0,
                              ),
                              size: const Size(150, 8),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              "01 Nov - 07 Nov",
                              style: TextStyle(
                                color: isDarkMode ? Colors.white : Colors.black,
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
                        color: isDarkMode
                            ? Colors.grey.shade800
                            : Colors.grey[200],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Month time",
                              style: TextStyle(
                                fontFamily: 'SF_Pro',
                                fontSize: 16.0,
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              "21 h 50 m",
                              style: TextStyle(
                                color: isDarkMode ? Colors.white : Colors.black,
                                fontFamily: 'SF_Pro',
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            CustomPaint(
                              painter: ProgressBarPainter(
                                percentage: 0.5,
                                backgroundColor: isDarkMode
                                    ? Colors.grey.shade600
                                    : Colors.grey,
                                foregroundColor:
                                    isDarkMode ? Colors.white : Colors.black,
                                borderRadius: 10.0,
                              ),
                              size: const Size(150, 8),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              "01 Nov - 30 Nov",
                              style: TextStyle(
                                color: isDarkMode ? Colors.white : Colors.black,
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
                const SizedBox(height: 15.0),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Last 7 day log',
                      style: normalStyle.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                      // style: TextStyle(
                      //   fontFamily: 'SF_Pro',
                      //   fontSize: 20.0,
                      //   fontWeight: FontWeight.bold,
                      //   color: isDarkMode ? Colors.white : Colors.black,
                      // ),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                const LogSheetConstant(),
                // const SizedBox(height: 10.0),
                // const LogSheetConstant(),
                // const SizedBox(height: 10.0),
                // const LogSheetConstant(),
                // const SizedBox(height: 10.0),
                // const LogSheetConstant(),
                // const SizedBox(height: 10.0),
                // const LogSheetConstant(),
                // const SizedBox(height: 10.0),
                // const LogSheetConstant(),
                // const SizedBox(height: 10.0),
                // const LogSheetConstant(),
                const SizedBox(height: 20.0),
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
                      child: const Text(
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
                const TimeoffView(),
                const SizedBox(height: 20.0),
                const TimeoffView(),
                const SizedBox(height: 20.0),
                const TimeoffView(),
                const SizedBox(height: 20.0),
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
                    HolidayEventNotification(),
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
