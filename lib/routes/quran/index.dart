import 'package:get/get.dart';
import 'package:masjid_app/pages/quran/listAyat/detail/detail_quran_page.dart';
import 'package:masjid_app/pages/quran/listAyat/listAyat_quran_page.dart';
import 'package:masjid_app/pages/quran/pengaturan/alquran_pengaturan_page.dart';
import 'package:masjid_app/pages/quran/quran_page.dart';
import 'package:masjid_app/pages/quran/halaman/halaman_quran_page.dart';
import 'package:masjid_app/pages/quran/halaman_madinah/halaman_quran_madinah_page.dart';
import 'package:masjid_app/pages/quran/halaman_tajwid/halaman_quran_tajwid_page.dart';

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
    GetPage(
      name: RoutesQuran.perayat,
      page: () => ListAyatQuranPage(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RoutesQuran.perpage,
      page: () => const HalamanQuranPage(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RoutesQuran.perpagemadinah,
      page: () => const HalamanQuranMadinahPage(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RoutesQuran.perpagetajwid,
      page: () => const HalamanQuranTajwidPage(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RoutesQuran.pengaturan,
      page: () => AlquranPengaturanPage(),
      transition: Transition.cupertino,
    ),
  ];
}

class RoutesQuran {
  static const String root = '/quran';
  static const String perpage = '/quran/perpage';
  static const String perpagemadinah = '/quran/perpage/madinah';
  static const String perpagetajwid = '/quran/perpage/tajwid';
  static const String perayat = '/quran/perayat';
  static const String detail = '/quran/detail/:id';
  static const String pengaturan = '/quran/pengaturan';
}
