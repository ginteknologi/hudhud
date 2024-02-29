import 'package:get/get.dart';
import 'package:masjid_app/pages/akun/akun_page.dart';
import 'package:masjid_app/pages/akun/edit/edit_akun_page.dart';
import 'package:masjid_app/pages/akun/riwayat/riwayat_page.dart';
import 'package:masjid_app/routes/isLogin_middleware.dart';

class PagesAkun {
  static var pages = [
    GetPage(
      name: RoutesAkun.root,
      page: () => const AkunPage(),
      transition: Transition.cupertino,
      middlewares: [IsLoginMiddleware()],
    ),
    GetPage(
      name: RoutesAkun.edit,
      page: () => const EditAkunPage(),
      transition: Transition.cupertino,
      middlewares: [IsLoginMiddleware()],
    ),
    GetPage(
      name: RoutesAkun.riwayat,
      page: () => const RiwayatPage(),
      transition: Transition.cupertino,
      middlewares: [IsLoginMiddleware()],
    ),
  ];
}

class RoutesAkun {
  static const String root = '/akun';
  static const String edit = '/akun/edit';
  static const String riwayat = '/akun/riwayat';
}
