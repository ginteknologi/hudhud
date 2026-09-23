import 'package:get/get.dart';
import 'package:masjid_app/pages/kajian/kajian_page.dart';

class PagesKajian {
  static var pages = [
    GetPage(
      name: RoutesKajian.root,
      page: () => KajianPage(),
      transition: Transition.cupertino,
    ),
  ];
}

class RoutesKajian {
  static const String root = '/kajian';
}
