import 'package:get/get.dart';
import 'package:mesjid_app/pages/quran/quran_page.dart';

class PagesQuran {
  static var pages = [
    GetPage(
      name: RoutesQuran.root,
      page: () => const QuranPage(),
      transition: Transition.cupertino,
    ),
  ];
}

class RoutesQuran {
  static const String root = '/quran';
}
