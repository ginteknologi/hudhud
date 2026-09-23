import 'package:get/get.dart';
import 'package:masjid_app/pages/muazin/muazin_page.dart';

class PagesMuazin {
  static var pages = [
    GetPage(
      name: RoutesMuadzin.root,
      page: () => MuazinPage(),
    ),
  ];
}

class RoutesMuadzin {
  static const String root = '/muazin';
}
