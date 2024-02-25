import 'package:get/get.dart';
import 'package:masjid_app/bindings/kalenderdzulhijjah_bindings.dart';
import 'package:masjid_app/pages/kalenderdzulhijjah/kalenderdzulhijjah_page.dart';

class PagesKalenderdzulhijjah {
  static var pages = [
    GetPage(
      name: Routeskalenderdzulhijjah.root,
      page: () => KalenderdzulhijjahPage(),
      binding: KalenderdzulhijjahBinding(),
    ),
  ];
}

class Routeskalenderdzulhijjah {
  static const String root = '/kalenderdzulhijjah';
}
