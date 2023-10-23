import 'package:get/get.dart';
import 'package:mesjid_app/pages/doa/content/doa_content_page.dart';
import 'package:mesjid_app/pages/doa/detail/detail_doa_page.dart';
import 'package:mesjid_app/pages/doa/doa_page.dart';
// import 'package:mesjid_app/pages/doa/detail/detaildoa_page.dart';

class PagesDoa {
  static var pages = [
    GetPage(
      name: RoutesDoa.root,
      page: () => const DoaPage(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RoutesDoa.detail,
      page: () => const DetailDoaPage(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RoutesDoa.content,
      page: () => const ContentDoaPage(),
      transition: Transition.cupertino,
    ),
  ];
}

class RoutesDoa {
  static const String root = '/doa';
  static const String detail = '/doa/:id';
  static const String content = '/doa/:id/content';
}
