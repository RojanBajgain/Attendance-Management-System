import 'package:ams/feature/data/datasource/remote/api_client.dart';
import 'package:ams/feature/data/repository/auth_repository_impl.dart';
import 'package:ams/feature/data/repository/calender_notification.dart';
import 'package:ams/feature/data/repository/chat_repo.dart';
import 'package:ams/feature/data/repository/clock_in_out_repo.dart';
import 'package:ams/feature/data/repository/has_clockedIn_repo.dart';
import 'package:ams/feature/data/repository/notification_repo.dart';
import 'package:ams/feature/data/repository/organization_repo.dart';
import 'package:ams/feature/data/repository/payroll_repo.dart';
import 'package:ams/feature/data/repository/policy_repo.dart';
import 'package:ams/feature/data/repository/profile_repo.dart';
import 'package:ams/feature/data/repository/reset_password_repo.dart';
import 'package:ams/feature/data/repository/websocket_repo.dart';
import 'package:ams/feature/presentation/pages/chat/controller/chat_controller.dart';
import 'package:ams/feature/presentation/pages/organization/controller/organization_controller.dart';
import 'package:ams/feature/presentation/pages/calender_notification/controller/calender_notification_controller.dart';
import 'package:ams/feature/presentation/pages/dashboard/controller/clock_in_out_controller.dart';
import 'package:ams/feature/presentation/pages/dashboard/controller/has_clockedIn_controller.dart';
import 'package:ams/feature/presentation/pages/forget_password/controller/reset_password_controller.dart';
import 'package:ams/feature/presentation/pages/login/controller/login_controller.dart';
import 'package:ams/feature/presentation/pages/notification/controller/notification_controller.dart';
import 'package:ams/feature/presentation/pages/payroll/controller/payroll_controller.dart';
import 'package:ams/feature/presentation/pages/policy/controller/policy_controller.dart';
import 'package:ams/feature/presentation/pages/profile/controller/profile_controller.dart';
import 'package:ams/feature/presentation/pages/websocket/controller/websocket_controller.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> init() async {
  // Initialize SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.put<SharedPreferences>(sharedPreferences);

  // Initialize other dependencies
  Get.put<ApiClient>(ApiClient(sharedPreferences: Get.find()));

  Get.put<AuthRepositoryImpl>(
      AuthRepositoryImpl(apiClient: Get.find<ApiClient>()));
  Get.put<AuthController>(
    AuthController(authRepo: Get.find<AuthRepositoryImpl>()),
  );

  // // Profile
  Get.put<ProfileRepo>(ProfileRepo(apiClient: Get.find<ApiClient>()));
  Get.put<ProfileController>(ProfileController());

  // Time off
  // Get.put<TimeoffRepo>(TimeoffRepo(apiClient: Get.find<ApiClient>()));
  // Get.put<TimeoffController>(
  //     TimeoffController(timeoffRepo: Get.find<TimeoffRepo>()));

  // TimeSheet
  // Get.put<TimesheetRepo>(TimesheetRepo(apiClient: Get.find<ApiClient>()));
  // Get.put<TimesheetController>(
  //     TimesheetController(timesheetRepo: Get.find<TimesheetRepo>()));

  // Payroll
  Get.put<PayrollRepo>(PayrollRepo(apiClient: Get.find<ApiClient>()));
  Get.put<PayrollController>(
      PayrollController(payrollRepo: Get.find<PayrollRepo>()));

  // Policies
  Get.put<PolicyRepo>(PolicyRepo(apiClient: Get.find<ApiClient>()));
  Get.put<PolicyController>(
      PolicyController(policyrepo: Get.find<PolicyRepo>()));

  // Notifications
  Get.put<NotificationRepo>(NotificationRepo(apiClient: Get.find<ApiClient>()));
  Get.put<NotificationController>(
      NotificationController(notificationrepo: Get.find<NotificationRepo>()));

  // Dashboard timesheet
  // Get.put<DashboardTimesheetRepo>(
  //     DashboardTimesheetRepo(apiClient: Get.find<ApiClient>()));
  // Get.put<DashboardTimesheetController>(DashboardTimesheetController(
  //     dashboardtimesheetrepo: Get.find<DashboardTimesheetRepo>()));

  // Dashboard Clock In / Clock Out
  Get.put<ClockInOutRepo>(ClockInOutRepo(apiClient: Get.find<ApiClient>()));
  Get.put<ClockInOutController>(
      ClockInOutController(clockinoutrepo: Get.find<ClockInOutRepo>()));

  Get.put<HasClockRepo>(HasClockRepo(apiClient: Get.find<ApiClient>()));
  Get.put<HasClockedinController>(
      HasClockedinController(hasClockedIn: Get.find<HasClockRepo>()));

  // Reset Password
  Get.put<ResetPasswordRepo>(
      ResetPasswordRepo(apiClient: Get.find<ApiClient>()));
  Get.put<ResetPasswordController>(ResetPasswordController(
      resetpasswordrepo: Get.find<ResetPasswordRepo>()));

  // Event Calender
  Get.put<EventCalenderRepo>(
      EventCalenderRepo(apiClient: Get.find<ApiClient>()));
  Get.put<CalenderNotificationController>(CalenderNotificationController(
      eventCalenderrepo: Get.find<EventCalenderRepo>()));

  // // WebSocket
  // Get.put<WebsocketRepo>(WebsocketRepo(apiClient: Get.find<ApiClient>()));
  // Get.put<WebSocketController>(
  //     WebSocketController(websocketRepo: Get.find<WebsocketRepo>()));

  // Organization
  // Get.put<OrganizationRepo>(OrganizationRepo(apiClient: Get.find<ApiClient>()));
  // Get.put<OrganizationController>(
  //     OrganizationController(organizationRepo: Get.find<OrganizationRepo>()));

  /*  // Bottom Navigation
  Get.put<BottomNavController>(BottomNavController());

  // Clock Time
  Get.put<TimerController>(TimerController());
  Get.put<ClockTimeController>(ClockTimeController()); */

  // // Chat (commented out, kept as is)
  // Get.put<ChatRepo>(ChatRepo(apiClient: Get.find<ApiClient>()));
  // Get.put<ChatController>(ChatController(chatRepo: Get.find<ChatRepo>()));
}
