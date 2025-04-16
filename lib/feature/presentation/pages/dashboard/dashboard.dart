import 'package:ams/config/resources/shimmer.dart';
import 'package:ams/config/resources/styles.dart';
import 'package:ams/feature/presentation/pages/dashboard/controller/dashboard_timesheet_controller.dart';
import 'package:ams/feature/presentation/pages/dashboard/sub_view_dashboard/timeoff_view.dart';
import 'package:ams/feature/presentation/pages/dashboard/widget/clock_time.dart';
import 'package:ams/feature/presentation/pages/login/controller/login_controller.dart';
import 'package:ams/feature/presentation/pages/timeoff/controller/timeoff_controller.dart';
import 'package:ams/feature/presentation/pages/timesheet/controller/timesheet_controller.dart';
import 'package:ams/feature/presentation/pages/timesheet/sub_view_timesheet/time_sheet_view.dart';
import 'package:ams/feature/presentation/pages/timesheet/time_sheet_page.dart';
import 'package:ams/feature/presentation/widget/components/app_bar.dart';
import 'package:ams/feature/presentation/pages/timeoff/time_off_page.dart';
import 'package:ams/feature/presentation/pages/dashboard/sub_view_dashboard/logsheet_constant.dart';
import 'package:ams/feature/presentation/pages/dashboard/sub_view_dashboard/holiday_event_notification_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final authcontroller = Get.find<AuthController>();

  final TimeoffController timeoffcontroller =
      Get.put(TimeoffController(timeoffRepo: Get.find()));

  final TimesheetController timesheetcontroller =
      Get.put(TimesheetController(timesheetRepo: Get.find()));

  final DashboardTimesheetController dashboardtimesheetcontroller =
      Get.put(DashboardTimesheetController(dashboardtimesheetrepo: Get.find()));

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning,'.tr;
    } else if (hour < 17) {
      return 'Good Afternoon,'.tr;
    } else {
      return 'Good Evening,'.tr;
    }
  }

  @override
  void initState() {
    super.initState();
    timeoffcontroller.getTimeoff();
    timesheetcontroller.getTimesheet();
    dashboardtimesheetcontroller.getDashboardTimesheet();
  }

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
                      borderRadius: BorderRadius.circular(10.0),
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
                        top: 22.0,
                        left: 22.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: "${_getGreeting()} ",
                              style: smallStyle.copyWith(
                                fontWeight: FontWeight.bold,
                                color: isDarkMode
                                    ? Colors.black
                                    : Colors.grey[200],
                              ),
                              children: [
                                TextSpan(
                                  text: authcontroller
                                          .alluserData.value.user?.fullName ??
                                      'Guest',
                                  style: smallStyle.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: isDarkMode
                                        ? Colors.black
                                        : Colors.grey[200],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Welcome to Ayata attendance.',
                            style: smallStyle.copyWith(
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
                ClockTime(),
                const SizedBox(height: 20.0),
                Obx(() {
                  if (dashboardtimesheetcontroller.isLoading.value) {
                    return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: ShrimmerEffect.rectangular(height: 50),
                    );
                  } else {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Container(
                            height: 110.0,
                            width: context.width * 0.5,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: isDarkMode
                                  ? Colors.grey.shade800
                                  : Colors.grey[200],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "This week time",
                                    style: smallStyle.copyWith(
                                      color: isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Text(
                                    "${dashboardtimesheetcontroller.dashboardtimesheet.value.thisWeek?.totalHour ?? "---"} ",
                                    style: smallStyle.copyWith(
                                      color: isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Stack(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: Colors.grey[300],
                                              ),
                                              height: 8,
                                            ),
                                            AnimatedFractionallySizedBox(
                                              duration: const Duration(
                                                  milliseconds: 200),
                                              widthFactor:
                                                  (dashboardtimesheetcontroller
                                                              .dashboardtimesheet
                                                              .value
                                                              .thisWeek
                                                              ?.percentage /
                                                          100 ??
                                                      0.0), // This should be a value between 0 and 1
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: isDarkMode
                                                      ? Colors.white
                                                      : Colors.black,
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                height: 8,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                          width:
                                              8), // Space between progress bar and text
                                      Text(
                                        "${((dashboardtimesheetcontroller.dashboardtimesheet.value.thisWeek?.percentage ?? 0.0)).toStringAsFixed(0)} / 100",
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Container(
                            height: 110.0,
                            width: context.width * 0.5,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: isDarkMode
                                  ? Colors.grey.shade800
                                  : Colors.grey[200],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Month time",
                                    style: smallStyle.copyWith(
                                        color: isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Text(
                                    "${dashboardtimesheetcontroller.dashboardtimesheet.value.month?.totalHour ?? "---"} ",
                                    style: smallStyle.copyWith(
                                      color: isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Stack(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: Colors.grey[300],
                                              ),
                                              height: 8,
                                            ),
                                            AnimatedFractionallySizedBox(
                                              duration: const Duration(
                                                  milliseconds: 200),
                                              widthFactor:
                                                  (dashboardtimesheetcontroller
                                                              .dashboardtimesheet
                                                              .value
                                                              .month
                                                              ?.percentage /
                                                          100 ??
                                                      0.0), // This should be a value between 0 and 1
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: isDarkMode
                                                      ? Colors.white
                                                      : Colors.black,
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                height: 8,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                          width:
                                              8), // Space between progress bar and text
                                      Text(
                                        "${((dashboardtimesheetcontroller.dashboardtimesheet.value.month?.percentage ?? 0.0)).toStringAsFixed(0)} / 100",
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  // const SizedBox(height: 10.0),
                                  // Text(
                                  //   "01 Nov - 30 Nov",
                                  //   style: smallStyle.copyWith(
                                  //     color: isDarkMode
                                  //         ? Colors.white
                                  //         : Colors.black,
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                }),
                const SizedBox(height: 20.0),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Last 7 day log',
                      style: smallNStyle.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15.0),
                Obx(() {
                  if (timesheetcontroller.isLoading.value) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ShrimmerEffect.rectangular(
                        height: 200,
                        width: MediaQuery.sizeOf(context).width,
                      ),
                    );
                  } else if (timesheetcontroller.timesheet.isEmpty) {
                    return SizedBox(
                      child: Center(
                        child: Text(
                          "No available Timesheet data.",
                          style: miniStyle.copyWith(
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    );
                  } else {
                    int maxItems = 7;

                    bool showViewAll =
                        timesheetcontroller.timesheet.length > maxItems;

                    int itemCount = showViewAll
                        ? maxItems
                        : timesheetcontroller.timesheet.length;

                    double itemHeight = 120;
                    double totalHeight = itemCount * itemHeight;

                    return SizedBox(
                      height: totalHeight,
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: showViewAll
                                  ? maxItems
                                  : timesheetcontroller.timesheet.length,
                              itemBuilder: (context, index) {
                                final timesheet =
                                    timesheetcontroller.timesheet[index];
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TimeSheetWidget(
                                    timesheetdata: timesheet,
                                  ),
                                );
                              },
                            ),
                          ),
                          if (showViewAll)
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const TimeSheetPage(),
                                  ),
                                );
                              },
                              child: const Text(
                                "View All",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  }
                }),

                // TIme Offs
                const SizedBox(height: 10.0),
                Row(
                  children: [
                    Text(
                      "Time offs",
                      style: normalStyle.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                Obx(() {
                  if (timeoffcontroller.isLoading.value) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ShrimmerEffect.rectangular(
                        height: 200,
                        width: MediaQuery.sizeOf(context).width,
                      ),
                    );
                  } else if (timeoffcontroller.timeoff.isEmpty) {
                    return SizedBox(
                      child: Center(
                        child: Text(
                          "No available Timeoff data",
                          style: miniStyle.copyWith(
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    );
                  } else {
                    int maxItems = 3;
                    bool showViewAll =
                        timeoffcontroller.timeoff.length > maxItems;
                    int itemCount = showViewAll
                        ? maxItems
                        : timeoffcontroller.timeoff.length;

                    double itemHeight = 210;
                    double totalHeight = itemCount * itemHeight;

                    return Column(
                      children: [
                        SizedBox(
                          height: totalHeight,
                          child: Column(
                            children: [
                              Expanded(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  itemCount: showViewAll
                                      ? maxItems
                                      : timeoffcontroller.timeoff.length,
                                  itemBuilder: (context, index) {
                                    final timeoff =
                                        timeoffcontroller.timeoff[index];
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TimeoffView(timeoffdata: timeoff),
                                    );
                                  },
                                ),
                              ),
                              if (showViewAll)
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const TimeOffPage(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    "View All",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                }),
                const SizedBox(height: 20.0),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Holidays & Events",
                      style: normalStyle.copyWith(
                        color: isDarkMode ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
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
