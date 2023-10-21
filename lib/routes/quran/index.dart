import 'package:get/get.dart';
import 'package:mesjid_app/pages/quran/listAyat/detail/detail_quran_page.dart';
import 'package:mesjid_app/pages/quran/quran_page.dart';

class PagesQuran {
  static var pages = [
    GetPage(
      name: RoutesQuran.root,
      page: () => QuranPage(
        typeView: TypeViewQuran.perayat,
      ),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RoutesQuran.detail,
      page: () => const DetailAyatQuranPage(),
      transition: Transition.cupertino,
    ),
  ];
}

class RoutesQuran {
  static const String root = '/quran';
  static const String detail = '/quran/detail/:id';
}
