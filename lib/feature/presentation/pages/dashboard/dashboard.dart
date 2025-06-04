import 'package:ams/config/resources/styles.dart';
import 'package:ams/feature/presentation/pages/calender_notification/controller/calender_notification_controller.dart';
import 'package:ams/feature/presentation/pages/dashboard/controller/clock_in_out_controller.dart';
import 'package:ams/feature/presentation/pages/dashboard/controller/dashboard_timesheet_controller.dart';
import 'package:ams/feature/presentation/pages/dashboard/controller/has_clockedIn_controller.dart';
import 'package:ams/feature/presentation/pages/dashboard/sub_view_dashboard/timesheet_timeoff_tabbar.dart';
import 'package:ams/feature/presentation/pages/dashboard/widget/clock_time.dart';
import 'package:ams/feature/presentation/pages/dashboard/widget/skeleton_box.dart';
import 'package:ams/feature/presentation/pages/login/controller/login_controller.dart';
import 'package:ams/feature/presentation/pages/organization/model/organization_profile_model.dart';
import 'package:ams/feature/presentation/pages/timeoff/controller/timeoff_controller.dart';
import 'package:ams/feature/presentation/pages/timesheet/controller/timesheet_controller.dart';
import 'package:ams/feature/presentation/widget/components/app_bar.dart';
import 'package:ams/feature/presentation/pages/dashboard/sub_view_dashboard/holiday_event_notification_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../profile/controller/profile_controller.dart';

class DashboardPage extends StatefulWidget {
  final Profile? profileData;
  final String? apiKey;

  const DashboardPage({super.key, this.profileData, this.apiKey});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final authController = Get.find<AuthController>();
  final TimeoffController timeoffController = Get.put(TimeoffController());
  final TimesheetController timesheetController =
      Get.put(TimesheetController());
  final DashboardTimesheetController dashboardTimesheetController =
      Get.put(DashboardTimesheetController());
  final CalenderNotificationController calenderNotificationController =
      Get.find<CalenderNotificationController>();
  final ProfileController profileController = Get.find<ProfileController>();

  Rx<Profile?> profile = Rx<Profile?>(null);

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning,';
    } else if (hour < 17) {
      return 'Good Afternoon,';
    } else {
      return 'Good Evening,';
    }
  }

  @override
  void initState() {
    super.initState();
    profileController.getProfile();
    // dashboardTimesheetController.getDashboardTimesheet();
    // timesheetController.getTimesheet();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: const ConstantAppBar(),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.wait([
            dashboardTimesheetController.getDashboardTimesheet(),
            timesheetController.getTimesheet(),
            timeoffController.getTimeoff(),
            calenderNotificationController.getEventCalenders(),
            Get.find<ProfileController>().getProfile(),
            Get.find<HasClockedinController>().getClockData(),
            Get.find<ClockInOutController>().getOfficeLocation(),
          ]);
        },
        child: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Obx(() {
                if (dashboardTimesheetController.isLoading.value) {
                  return const DashboardSkeletonLoading();
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Dashboard",
                      style: normalStyle.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black,
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
                                  // text: profileController.profile.isNotEmpty
                                  //     ? profileController.profile.first.username
                                  //     : "Hello",
                                  text: profileController
                                          .profile.first.username ??
                                      "User",

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
                                    "${dashboardTimesheetController.dashboardtimesheet.value.thisWeek?.totalHour ?? "---"} / 48 hrs",
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
                                                  dashboardTimesheetController
                                                              .dashboardtimesheet
                                                              .value
                                                              .thisWeek
                                                              ?.percentage !=
                                                          null
                                                      ? (dashboardTimesheetController
                                                              .dashboardtimesheet
                                                              .value
                                                              .thisWeek!
                                                              .percentage /
                                                          100)
                                                      : 0.0,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: isDarkMode
                                                      ? Colors.grey.shade700
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
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Text(
                                    "${dashboardTimesheetController.dashboardtimesheet.value.month?.totalHour ?? "---"} / 200 hrs",
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
                                                  dashboardTimesheetController
                                                              .dashboardtimesheet
                                                              .value
                                                              .month
                                                              ?.percentage !=
                                                          null
                                                      ? (dashboardTimesheetController
                                                              .dashboardtimesheet
                                                              .value
                                                              .month!
                                                              .percentage /
                                                          100)
                                                      : 0.0,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: isDarkMode
                                                      ? Colors.grey.shade700
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
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    TimesheetTimeoffTabView(
                      timeoffcontroller: timeoffController,
                      timesheetcontroller: timesheetController,
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

class DashboardSkeletonLoading extends StatelessWidget {
  const DashboardSkeletonLoading({super.key});

  @override
  Widget build(BuildContext context) {
    // final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 10.0),
          child: SkeletonBox(height: 20, width: 100, borderRadius: 4),
        ),
        const SizedBox(height: 15.0),
        const SkeletonBox(height: 90, width: double.infinity, borderRadius: 10),
        const SizedBox(height: 10.0),
        const SkeletonBox(
            height: 225, width: double.infinity, borderRadius: 12),
        const SizedBox(height: 20.0),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              SkeletonBox(
                  height: 110, width: context.width * 0.5, borderRadius: 10),
              const SizedBox(width: 15),
              SkeletonBox(
                  height: 110, width: context.width * 0.5, borderRadius: 10),
            ],
          ),
        ),
        const SizedBox(height: 30.0),
        const SkeletonBox(
            height: 200, width: double.infinity, borderRadius: 10),
        const SizedBox(height: 30.0),
        const SkeletonBox(
            height: 100, width: double.infinity, borderRadius: 10),
      ],
    );
  }
}
