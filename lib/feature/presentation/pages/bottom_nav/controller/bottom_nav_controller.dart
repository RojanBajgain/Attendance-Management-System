/* import 'package:ams/feature/presentation/pages/calender_notification/controller/calender_notification_controller.dart';
import 'package:ams/feature/presentation/pages/timeoff/controller/timeoff_controller.dart';
import 'package:ams/feature/presentation/pages/timesheet/controller/timesheet_controller.dart';
import 'package:ams/feature/presentation/pages/dashboard/controller/dashboard_timesheet_controller.dart';
import 'package:ams/feature/presentation/pages/profile/controller/profile_controller.dart';
import 'package:ams/feature/presentation/pages/dashboard/controller/clock_in_out_controller.dart';
import 'package:ams/feature/presentation/pages/dashboard/controller/has_clockedIn_controller.dart';
import 'package:ams/feature/presentation/pages/dashboard/controller/timer_controller.dart';
import 'package:ams/feature/presentation/pages/dashboard/controller/clock_time_controller.dart';
import 'package:get/get.dart';
import 'dart:developer';

class BottomNavController extends GetxController {
  var selectedTab = 0.obs;

  @override
  void onInit() async {
    super.onInit();
    log('BottomNavController: Starting onInit');
    try {
      await Future.wait([
        Get.find<DashboardTimesheetController>().getDashboardTimesheet(),
        Get.find<TimesheetController>().getTimesheet(),
        Get.find<TimeoffController>().getTimeoff(),
        Get.find<CalenderNotificationController>().getEventCalenders(),
        Get.find<ProfileController>().getProfile(),
        Get.find<HasClockedinController>().getClockData(),
        Get.find<ClockInOutController>().getOfficeLocation(),
      ]);
      // Ensure ClockTimeController state is updated
      await Get.find<ClockTimeController>().loadState();
      log('BottomNavController: Completed onInit');
    } catch (e) {
      log('BottomNavController: Error during onInit: $e');
    }
  }

  void changeTab(int index) {
    selectedTab.value = index;
    log('BottomNavController: Changed tab to index=$index');
  }
}
 */
