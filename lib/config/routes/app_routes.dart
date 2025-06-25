part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const LANDINGPAGE = _Paths.LANDING_PAGE;
  static const LOGIN = _Paths.LOGIN;

  static const noInternet = _Paths.nointernet;

  static const bottomnav = _Paths.bottomnav;
  static const organization = _Paths.organization;
  static const chat = _Paths.chat;
}

abstract class _Paths {
  static const LANDING_PAGE = '/LandingPage';
  static const LOGIN = '/LoginPage';

  static const bottomnav = '/bottomNav';
  static const organization = '/organization';
  static const chat = '/chat';

  static const nointernet = '/nointernet';
}
