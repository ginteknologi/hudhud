import 'package:get/get.dart';
import 'package:masjid_app/pages/kiblat/kiblat_page.dart';

class PagesKiblat {
  static var pages = [
    GetPage(
      name: RoutesKiblat.root,
      page: () => KiblatPage(),
      maintainState: true,
    ),
  ];
}

class RoutesKiblat {
  static const String root = '/kiblat';
}
