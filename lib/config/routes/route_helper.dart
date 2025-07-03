import 'package:ams/feature/presentation/pages/bottom_nav/bottom_nav_page.dart';
import 'package:ams/feature/presentation/pages/calender_notification/sub_view_event/event_page.dart';
import 'package:ams/feature/presentation/pages/chat/chat.dart';
import 'package:ams/feature/presentation/pages/landing/landing_page.dart';
import 'package:ams/feature/presentation/pages/login/login_page.dart';
import 'package:ams/feature/presentation/pages/offline_page/page/offline_page.dart';
import 'package:ams/feature/presentation/pages/organization/pages/organization_page.dart';
import 'package:ams/feature/presentation/pages/payroll/sub_view_payroll/payment_slip_view.dart';
import 'package:get/get.dart';

class RouteHelper {
  RouteHelper._();
  // static const String home = '/home';
  static const String landingpage = '/landingpage';
  static const String login = '/loginpage';
  static const String nointernet = '/nointernet';
  static const String bottomnav = '/bottomNav';
  static const String organization = '/organization';
  static const String chat = '/chat';
  static const String event = '/EventPage';
  static const String paymentslip = '/PaymentSlip';

  // static String getHome() => home;
  static String getlandingpage() => landingpage;
  static String getlogin() => login;
  static String getnointernet() => nointernet;
  static String getbottomnav() => bottomnav;
  static String getorganization() => organization;
  static String getchat() => chat;
  static String getevent() => event;
  static String getpaymentslip() => paymentslip;

  static List<GetPage> routes = [
    GetPage(
      name: landingpage,
      page: () => const LandingPage(),
    ),
    GetPage(
      name: login,
      page: () => const LoginPage(),
    ),
    GetPage(
      name: bottomnav,
      page: () => BottomNavPage(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: organization,
      page: () => const OrganizationPage(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: chat,
      page: () => const ChatsScreen(),
    ),
    GetPage(
      name: event,
      page: () => const EventPage(),
    ),
    GetPage(
      name: paymentslip,
      page: () => PaymentSlip(
        payrollId: Get.parameters['payemntId'] ?? '',
      ),
    ),
    GetPage(
      name: nointernet,
      popGesture: false,
      preventDuplicates: true,
      page: () => OfflineView(),
    ),
  ];
}
