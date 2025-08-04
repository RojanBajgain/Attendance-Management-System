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

  // Add error state management
  RxBool hasError = false.obs;
  RxString errorMessage = ''.obs;

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
    _initializeDashboard();
  }

  // Enhanced initialization with error handling
  Future<void> _initializeDashboard() async {
    try {
      hasError.value = false;
      await profileController.getProfile();
      // Add other initialization calls as needed
    } catch (e) {
      print('Dashboard initialization error: $e');
      hasError.value = true;
      errorMessage.value = 'Failed to load dashboard data';
    }
  }

  // Safe refresh method
  Future<void> _safeRefresh() async {
    try {
      hasError.value = false;
      await Future.wait([
        dashboardTimesheetController.getDashboardTimesheet(),
        timesheetController.getTimesheet(),
        timeoffController.getTimeoff(),
        calenderNotificationController.getEventCalenders(),
        profileController.getProfile(),
        Get.find<HasClockedinController>().getClockData(),
        Get.find<ClockInOutController>().getOfficeLocation(),
      ]);
    } catch (e) {
      print('Refresh error: $e');
      hasError.value = true;
      errorMessage.value = 'Failed to refresh data';
    }
  }

  // Safe widget builder that handles nulls gracefully
  Widget _buildDashboardContent(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 6.0),
          child: Text(
            "Dashboard",
            style: normalStyle.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 12.0),
        _buildWelcomeCard(isDarkMode),
        const SizedBox(height: 15.0),
        const ClockTime(),
        const SizedBox(height: 20.0),
        _buildStatisticsCards(isDarkMode),
        const SizedBox(height: 30.0),
        TimesheetTimeoffTabView(
          timeoffcontroller: timeoffController,
          timesheetcontroller: timesheetController,
        ),
        const SizedBox(height: 15.0),
        _buildHolidaysSection(isDarkMode),
      ],
    );
  }

  // Welcome card with null safety
  Widget _buildWelcomeCard(bool isDarkMode) {
    return Container(
      height: 85.0,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 22.0),
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
                fontSize: 12.0,
              ),
              children: [
                TextSpan(
                  text: _getUserName(),
                  style: smallStyle.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.black : Colors.white,
                    fontSize: 12.0,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Department: ${_getDepartmentName()}',
            style: smallStyle.copyWith(
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.black87 : Colors.white70,
              fontSize: 12.0,
            ),
          ),
        ],
      ),
    );
  }

  // Safe username getter
  String _getUserName() {
    try {
      return profileController.profile.value!.username ?? "Dear User";
    } catch (e) {
      return "Dear User";
    }
  }

  // Safe department name getter
  String _getDepartmentName() {
    try {
      return profileController.profile.value!.organization?.title ?? "N/A";
    } catch (e) {
      return "N/A";
    }
  }

  // Statistics cards with null safety
  Widget _buildStatisticsCards(bool isDarkMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildStatCard(
          isDarkMode: isDarkMode,
          title: "This week time",
          hours: _getWeeklyHours(),
          percentage: _getWeeklyPercentage(),
          width: context.width * 0.45,
        ),
        const SizedBox(width: 15),
        _buildStatCard(
          isDarkMode: isDarkMode,
          title: "Month time",
          hours: _getMonthlyHours(),
          percentage: _getMonthlyPercentage(),
          width: context.width * 0.45,
        ),
      ],
    );
  }

  // Individual stat card with null safety
  Widget _buildStatCard({
    required bool isDarkMode,
    required String title,
    required String hours,
    required double percentage,
    required double width,
  }) {
    return Container(
      height: 110.0,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: isDarkMode ? Colors.grey.shade800 : Colors.grey[200],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: smallStyle.copyWith(
                color: isDarkMode ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 12.0,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              hours,
              style: smallStyle.copyWith(
                color: isDarkMode ? Colors.white : Colors.black,
                fontSize: 12.0,
              ),
            ),
            const SizedBox(height: 15.0),
            _buildProgressBar(percentage, isDarkMode),
          ],
        ),
      ),
    );
  }

  // Progress bar widget
  Widget _buildProgressBar(double percentage, bool isDarkMode) {
    return Row(
      children: [
        Expanded(
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.grey[300],
                ),
                height: 8,
              ),
              AnimatedFractionallySizedBox(
                duration: const Duration(milliseconds: 200),
                widthFactor: percentage / 100,
                child: Container(
                  decoration: BoxDecoration(
                    color: getProgressColor(percentage, isDarkMode),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  height: 8,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Safe data getters with fallbacks
  String _getWeeklyHours() {
    try {
      final totalHour = dashboardTimesheetController
          .dashboardtimesheet.value.thisWeek?.totalHour;
      return totalHour != null ? "$totalHour / 48 hrs" : "--- / 48 hrs";
    } catch (e) {
      return "--- / 48 hrs";
    }
  }

  String _getMonthlyHours() {
    try {
      final totalHour = dashboardTimesheetController
          .dashboardtimesheet.value.month?.totalHour;
      return totalHour != null ? "$totalHour / 200 hrs" : "--- / 200 hrs";
    } catch (e) {
      return "--- / 200 hrs";
    }
  }

  double _getWeeklyPercentage() {
    try {
      return dashboardTimesheetController
              .dashboardtimesheet.value.thisWeek?.percentage ??
          0.0;
    } catch (e) {
      return 0.0;
    }
  }

  double _getMonthlyPercentage() {
    try {
      return dashboardTimesheetController
              .dashboardtimesheet.value.month?.percentage ??
          0.0;
    } catch (e) {
      return 0.0;
    }
  }

  // Holidays section
  Widget _buildHolidaysSection(bool isDarkMode) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 6.0),
          child: Text(
            "Holidays & Events",
            style: normalStyle.copyWith(
              color: isDarkMode ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 14.0,
            ),
          ),
        ),
        const SizedBox(height: 20.0),
        const HolidayEventNotification(),
      ],
    );
  }

  // Error state widget
  Widget _buildErrorState(bool isDarkMode) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: isDarkMode ? Colors.white54 : Colors.black54,
          ),
          const SizedBox(height: 16),
          Text(
            'Something went wrong',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            errorMessage.value.isNotEmpty
                ? errorMessage.value
                : 'Unable to load dashboard data',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: isDarkMode ? Colors.white54 : Colors.black54,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              _safeRefresh();
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Try Again'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: const ConstantAppBar(),
      body: RefreshIndicator(
        color: isDarkMode ? Colors.white : Colors.black,
        backgroundColor: isDarkMode ? Colors.grey.shade800 : Colors.white,
        onRefresh: _safeRefresh,
        child: SingleChildScrollView(
          physics:
              const AlwaysScrollableScrollPhysics(), // Ensures pull-to-refresh works
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Obx(() {
                // Handle error state
                if (hasError.value) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height - 200,
                    child: _buildErrorState(isDarkMode),
                  );
                }

                // Handle loading state
                if (dashboardTimesheetController.isLoading.value) {
                  return const DashboardSkeletonLoading();
                }

                // Handle success state
                return _buildDashboardContent(isDarkMode);
              }),
            ),
          ),
        ),
      ),
    );
  }

  Color getProgressColor(double percentage, bool isDarkMode) {
    if (percentage < 25) {
      return Colors.red;
    } else if (percentage < 50) {
      return Colors.orange;
    } else if (percentage < 75) {
      return Colors.yellow.shade700;
    } else {
      return isDarkMode ? Colors.green.shade700 : Colors.green;
    }
  }
}

class DashboardSkeletonLoading extends StatelessWidget {
  const DashboardSkeletonLoading({super.key});

  @override
  Widget build(BuildContext context) {
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
