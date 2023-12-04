import 'package:get/get.dart';
import 'package:masjid_app/pages/auth/auth_page.dart';
import 'package:masjid_app/pages/auth/logout/logout_page.dart';

class PagesAuth {
  static var pages = [
    GetPage(
      name: RoutesAuth.root,
      page: () => const AuthPage(),
      transition: Transition.noTransition,
      maintainState: true,
    ),
    GetPage(
      name: RoutesAuth.logout,
      page: () => const LogOutPage(),
      transition: Transition.noTransition,
      maintainState: true,
    ),
  ];
}

class RoutesAuth {
  static const String root = '/auth';
  static const String logout = '/auth/logout';
}
