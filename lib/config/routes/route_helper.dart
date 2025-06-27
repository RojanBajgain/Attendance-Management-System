import 'package:ams/feature/presentation/pages/bottom_nav/bottom_nav_page.dart';
import 'package:ams/feature/presentation/pages/chat/chat.dart';
import 'package:ams/feature/presentation/pages/landing/landing_page.dart';
import 'package:ams/feature/presentation/pages/login/login_page.dart';
import 'package:ams/feature/presentation/pages/offline_page/page/offline_page.dart';
import 'package:ams/feature/presentation/pages/organization/pages/organization_page.dart';
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

  // static String getHome() => home;
  static String getlandingpage() => landingpage;
  static String getlogin() => login;
  static String getnointernet() => nointernet;
  static String getbottomnav() => bottomnav;
  static String getorganization() => organization;
  static String getchat() => chat;

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
      page: () => const BottomNavPage(),
    ),
    GetPage(
      name: organization,
      page: () => const OrganizationPage(),
    ),
    GetPage(
      name: chat,
      page: () => const ChatsScreen(),
    ),
    GetPage(
      name: nointernet,
      popGesture: false,
      preventDuplicates: true,
      page: () => OfflineView(),
    ),
  ];
}
