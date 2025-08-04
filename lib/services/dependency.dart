import 'package:ams/feature/data/datasource/remote/api_client.dart';
import 'package:ams/feature/data/repository/app_brand.dart';
import 'package:ams/feature/data/repository/auth_repository_impl.dart';
import 'package:ams/feature/data/repository/calender_notification.dart';
import 'package:ams/feature/data/repository/chat_repo.dart';
import 'package:ams/feature/data/repository/clock_in_out_repo.dart';
import 'package:ams/feature/data/repository/has_clockedIn_repo.dart';
import 'package:ams/feature/data/repository/notification_repo.dart';
import 'package:ams/feature/data/repository/organizationStaff_repo.dart';
import 'package:ams/feature/data/repository/payroll_repo.dart';
import 'package:ams/feature/data/repository/policy_repo.dart';
import 'package:ams/feature/data/repository/profile_repo.dart';
import 'package:ams/feature/data/repository/reset_password_repo.dart';
import 'package:ams/feature/presentation/pages/HR_Details/controller/hr_detail_controller.dart';
import 'package:ams/feature/presentation/pages/app_image_brand/controller/app_brand_controller.dart';
import 'package:ams/feature/presentation/pages/chat/controller/chat_controller.dart';
import 'package:ams/feature/presentation/pages/calender_notification/controller/calender_notification_controller.dart';
import 'package:ams/feature/presentation/pages/dashboard/controller/clock_in_out_controller.dart';
import 'package:ams/feature/presentation/pages/dashboard/controller/has_clockedIn_controller.dart';
import 'package:ams/feature/presentation/pages/forget_password/controller/reset_password_controller.dart';
import 'package:ams/feature/presentation/pages/login/controller/login_controller.dart';
import 'package:ams/feature/presentation/pages/notification/controller/notification_controller.dart';
import 'package:ams/feature/presentation/pages/payroll/controller/payroll_controller.dart';
import 'package:ams/feature/presentation/pages/policy/controller/policy_controller.dart';
import 'package:ams/feature/presentation/pages/profile/controller/profile_controller.dart';
import 'package:ams/services/theme_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> init() async {
  Get.put(ApiClient(secureStorage: FlutterSecureStorage()));
  Get.put<AuthRepositoryImpl>(
      AuthRepositoryImpl(apiClient: Get.find<ApiClient>()));
  Get.put<AuthController>(
    AuthController(authRepo: Get.find<AuthRepositoryImpl>()),
  );

  // Profile
  Get.lazyPut(() => ProfileRepo(apiClient: Get.find<ApiClient>()));
  Get.lazyPut(() => PayrollRepo(apiClient: Get.find<ApiClient>()));
  Get.lazyPut(() => PolicyRepo(apiClient: Get.find<ApiClient>()));
  Get.lazyPut(() => NotificationRepo(apiClient: Get.find<ApiClient>()));
  Get.lazyPut(() => ClockInOutRepo(apiClient: Get.find<ApiClient>()));
  Get.lazyPut(() => HasClockRepo(apiClient: Get.find<ApiClient>()));
  Get.lazyPut(() => ResetPasswordRepo(apiClient: Get.find<ApiClient>()));
  Get.lazyPut(() => EventCalenderRepo(apiClient: Get.find<ApiClient>()));
  Get.lazyPut(() => ChatRepo(apiClient: Get.find<ApiClient>()));
  Get.lazyPut(() => AppBrandRepo(apiClient: Get.find<ApiClient>()));
  Get.lazyPut(() => OrganizationStaffRepo(apiClient: Get.find<ApiClient>()));

  Get.put(ProfileController(profileRepo: Get.find()));
  Get.put(PayrollController(payrollRepo: Get.find()));
  Get.put(PolicyController(policyrepo: Get.find()));
  Get.put(NotificationController(notificationrepo: Get.find()));
  Get.put(ClockInOutController(clockinoutrepo: Get.find()));
  Get.put(HasClockedinController(hasClockedIn: Get.find()));
  Get.put(ResetPasswordController(resetpasswordrepo: Get.find()));
  Get.put(CalenderNotificationController(eventCalenderrepo: Get.find()));
  Get.put(ChatController(chatRepo: Get.find()));
  Get.put(OrganizationStaffController(organizationStaffRepo: Get.find()));

  Get.put(AppBrandController(appBrandRepo: Get.find()));
  Get.put(ThemeService());
}
