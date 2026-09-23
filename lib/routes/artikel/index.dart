import 'package:get/get.dart';
import 'package:masjid_app/pages/artikel/artikel_page.dart';
import 'package:masjid_app/pages/artikel/detail/detail_artikel_page.dart';
// import 'package:masjid_app/pages/artikel/detail/detailartikel_page.dart';

class PagesArtikel {
  static var pages = [
    GetPage(
      name: RoutesArtikel.root,
      page: () => ArtikelPage(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RoutesArtikel.detail,
      page: () => DetailArtikelPage(),
      transition: Transition.cupertino,
    ),
  ];
}

class RoutesArtikel {
  static const String root = '/artikel';
  static const String detail = '/artikel/:id';
}
