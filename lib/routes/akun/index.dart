import 'package:get/get.dart';
import 'package:mesjid_app/pages/akun/akun_page.dart';
import 'package:mesjid_app/routes/isLogin_middleware.dart';

class PagesAkun {
  static var pages = [
    GetPage(
      name: RoutesAkun.root,
      page: () => const AkunPage(),
      transition: Transition.cupertino,
      // middlewares: [IsLoginMiddleware()],
    ),
  ];
}

class RoutesAkun {
  static const String root = '/akun';
}
