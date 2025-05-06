import 'package:ams/config/resources/styles.dart';
import 'package:ams/feature/presentation/pages/calender_notification/controller/calender_notification_controller.dart';
import 'package:ams/feature/presentation/pages/dashboard/controller/dashboard_timesheet_controller.dart';
import 'package:ams/feature/presentation/pages/dashboard/sub_view_dashboard/timesheet_timeoff_tabbar.dart';
import 'package:ams/feature/presentation/pages/dashboard/widget/clock_time.dart';
import 'package:ams/feature/presentation/pages/dashboard/widget/skeleton_box.dart';
import 'package:ams/feature/presentation/pages/login/controller/login_controller.dart';
import 'package:ams/feature/presentation/pages/timeoff/controller/timeoff_controller.dart';
import 'package:ams/feature/presentation/pages/timesheet/controller/timesheet_controller.dart';
import 'package:ams/feature/presentation/widget/components/app_bar.dart';
import 'package:ams/feature/presentation/pages/dashboard/sub_view_dashboard/holiday_event_notification_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  final CalenderNotificationController calenderNotificationController =
      Get.put(CalenderNotificationController(eventCalenderrepo: Get.find()));

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
    // dashboardtimesheetcontroller.getDashboardTimesheet();

    // Defer less-important data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // timeoffcontroller.getTimeoff();
      // timesheetcontroller.getTimesheet();
      // calenderNotificationController.getEventCalenders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: const ConstantAppBar(),
      body: RefreshIndicator(
        onRefresh: () async {
          await dashboardtimesheetcontroller.getDashboardTimesheet();
          await timeoffcontroller.getTimeoff();
          await timesheetcontroller.getTimesheet();
          await calenderNotificationController.getEventCalenders();
        },
        child: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Obx(() {
                if (dashboardtimesheetcontroller.isLoading.value) {
                  return const DashboardSkeletonLoading();
                }

                return Column(
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
                    Container(
                      height: 90.0,
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 22.0, vertical: 22.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: isDarkMode ? Colors.grey[300] : Colors.grey[900],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text.rich(
                            TextSpan(
                              text: "${_getGreeting()} ",
                              style: smallStyle.copyWith(
                                fontWeight: FontWeight.bold,
                                color: isDarkMode ? Colors.black : Colors.white,
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
                                        : Colors.white,
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
                                  isDarkMode ? Colors.black87 : Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    const ClockTime(),
                    const SizedBox(height: 20.0),
                    SingleChildScrollView(
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
                                    "${dashboardtimesheetcontroller.dashboardtimesheet.value.thisWeek?.totalHour ?? "---"} / 48 hrs",
                                    style: smallStyle.copyWith(
                                      color: isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 12.0,
                                    ),
                                  ),
                                  const SizedBox(height: 15.0),
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
                                                      0.0),
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
                                      const SizedBox(width: 8),
                                      // Text(
                                      //   "${((dashboardtimesheetcontroller.dashboardtimesheet.value.thisWeek?.percentage ?? 0.0)).toStringAsFixed(0)} / 100",
                                      //   style: const TextStyle(
                                      //       fontSize: 12,
                                      //       fontWeight: FontWeight.bold),
                                      // ),
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
                                    "${dashboardtimesheetcontroller.dashboardtimesheet.value.month?.totalHour ?? "---"} / 200 hrs",
                                    style: smallStyle.copyWith(
                                      color: isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 12.0,
                                    ),
                                  ),
                                  const SizedBox(height: 15.0),
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
                                                      0.0),
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
                                      // const SizedBox(width: 8),
                                      // Text(
                                      //   "${((dashboardtimesheetcontroller.dashboardtimesheet.value.month?.percentage ?? 0.0)).toStringAsFixed(0)} / 100",
                                      //   style: const TextStyle(
                                      //       fontSize: 12,
                                      //       fontWeight: FontWeight.bold),
                                      // ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // OverTime
                          /* const SizedBox(width: 15),
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
                                    "OverTime",
                                    style: smallStyle.copyWith(
                                        color: isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Text(
                                    "${dashboardtimesheetcontroller.dashboardtimesheet.value.day?.overTime ?? "---"} / 0 hrs",
                                    style: smallStyle.copyWith(
                                      color: isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 15.0),
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
                                                              .day
                                                              ?.overTime
                                                          // .percentage
                                                          /
                                                          100 ??
                                                      0.0),
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
                                      // const SizedBox(width: 8),
                                      // Text(
                                      //   "${((dashboardtimesheetcontroller.dashboardtimesheet.value.month?.percentage ?? 0.0)).toStringAsFixed(0)} / 100",
                                      //   style: const TextStyle(
                                      //       fontSize: 12,
                                      //       fontWeight: FontWeight.bold),
                                      // ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ), */
                        ],
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    TimesheetTimeoffTabView(
                      timeoffcontroller: timeoffcontroller,
                      timesheetcontroller: timesheetcontroller,
                    ),
                    const SizedBox(height: 30.0),
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
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
