import 'package:ams/feature/data/datasource/remote/api_client.dart';
import 'package:ams/feature/data/repository/auth_repository_impl.dart';
import 'package:ams/feature/data/repository/notification_repo.dart';
import 'package:ams/feature/data/repository/payroll_repo.dart';
import 'package:ams/feature/data/repository/policy_repo.dart';
import 'package:ams/feature/data/repository/profile_repo.dart';
import 'package:ams/feature/data/repository/timeoff_repo.dart';
import 'package:ams/feature/data/repository/timesheet_repo.dart';
import 'package:ams/feature/presentation/pages/login/controller/login_controller.dart';
import 'package:ams/feature/presentation/pages/notification/controller/notification_controller.dart';
import 'package:ams/feature/presentation/pages/payroll/controller/payroll_controller.dart';
import 'package:ams/feature/presentation/pages/policy/controller/policy_controller.dart';
import 'package:ams/feature/presentation/pages/profile/controller/profile_controller.dart';
import 'package:ams/feature/presentation/pages/timeoff/controller/timeoff_controller.dart';
import 'package:ams/feature/presentation/pages/timesheet/controller/timesheet_controller.dart';
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

  // Profile
  Get.put<ProfileRepo>(ProfileRepo(apiClient: Get.find<ApiClient>()));
  Get.put<ProfileController>(
      ProfileController(profileRepo: Get.find<ProfileRepo>()));

  // Time off
  Get.put<TimeoffRepo>(TimeoffRepo(apiClient: Get.find<ApiClient>()));
  Get.put<TimeoffController>(
      TimeoffController(timeoffRepo: Get.find<TimeoffRepo>()));

  // TimeSheet
  Get.put<TimesheetRepo>(TimesheetRepo(apiClient: Get.find<ApiClient>()));
  Get.put<TimesheetController>(
      TimesheetController(timesheetRepo: Get.find<TimesheetRepo>()));

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
}
