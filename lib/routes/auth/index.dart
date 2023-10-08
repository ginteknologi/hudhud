import 'package:get/get.dart';
import 'package:mesjid_app/pages/auth/auth_page.dart';

class PagesAuth {
  static var pages = [
    GetPage(
      name: RoutesAuth.root,
      page: () => const AuthPage(),
      transition: Transition.noTransition,
      maintainState: true,
    ),
  ];
}

class RoutesAuth {
  static const String root = '/auth';
}
