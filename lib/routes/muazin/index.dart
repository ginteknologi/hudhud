import 'package:get/get.dart';
import 'package:masjid_app/bindings/kalenderdzulhijjah_bindings.dart';
import 'package:masjid_app/pages/muazin/muazin_page.dart';

class PagesKalenderdzulhijjah {
  static var pages = [
    GetPage(
      name: RoutesMuadzin.root,
      page: () => MuazinPage(),
      binding: KalenderdzulhijjahBinding(),
    ),
  ];
}

class RoutesMuadzin {
  static const String root = '/kalenderdzulhijjah';
}
