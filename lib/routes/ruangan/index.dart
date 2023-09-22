import 'package:get/get.dart';
import 'package:mesjid_app/pages/ruangan/ruangan_page.dart';

class PagesRuangan {
  static var pages = [
    GetPage(
      name: RoutesRuangan.root,
      page: () => const RuanganPage(),
      transition: Transition.cupertino,
    ),
  ];
}

class RoutesRuangan {
  static const String root = '/ruangan';
}
