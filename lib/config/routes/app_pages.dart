import 'package:ams/feature/presentation/pages/bottom_nav/bottom_nav_page.dart';
import 'package:ams/feature/presentation/pages/calender_notification/sub_view_event/event_page.dart';
import 'package:ams/feature/presentation/pages/chat/chat.dart';
import 'package:ams/feature/presentation/pages/landing/pages/landing_page.dart';
import 'package:ams/feature/presentation/pages/login/login_page.dart';
import 'package:ams/feature/presentation/pages/organization/pages/organization_page.dart';
import 'package:ams/feature/presentation/pages/payroll/payroll_page.dart';
import 'package:ams/feature/presentation/pages/payroll/sub_view_payroll/payment_slip_view.dart';
import 'package:ams/feature/presentation/pages/timesheet/time_sheet_page.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LANDINGPAGE;

  static final routes = [
    GetPage(name: _Paths.LANDING_PAGE, page: () => const LandingPage()),
    GetPage(name: _Paths.LOGIN, page: () => const LoginPage()),
    GetPage(name: _Paths.bottomnav, page: () => BottomNavPage()),
    GetPage(name: _Paths.organization, page: () => const OrganizationPage()),
    GetPage(name: _Paths.chat, page: () => const ChatsScreen()),
    GetPage(name: _Paths.event, page: () => const EventPage()),
    GetPage(name: _Paths.timesheet, page: () => const TimeSheetPage()),
    GetPage(
        name: _Paths.paymentslip,
        page: () => PaymentSlip(
              payrollId: Get.parameters['payrollId'] ?? '',
            )),
  ];
}
