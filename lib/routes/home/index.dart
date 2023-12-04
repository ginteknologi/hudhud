import 'package:get/get.dart';
import 'package:masjid_app/pages/home/home_page.dart';
import 'package:masjid_app/pages/splashscreen/splashscreen_page.dart';
// import 'package:masjid_app/routes/isLogin_middleware.dart';

class PagesHome {
  static var pages = [
    GetPage(
      name: RoutesHome.root,
      page: () => const HomePage(),
      maintainState: true,
    ),
    GetPage(
      name: RoutesHome.splashscreen,
      page: () => const SplashscreenPage(),
    ),

  ];
}

class RoutesHome {
  static const String root = '/home';
  static const String splashscreen = '/splashscreen';
}
