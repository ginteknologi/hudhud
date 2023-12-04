import 'package:get/get.dart';
import 'package:masjid_app/pages/ruangan/booking/booking_ruangan_page.dart';
import 'package:masjid_app/pages/ruangan/jadwal/jadwal_ruangan_page.dart';
import 'package:masjid_app/pages/ruangan/ruangan_page.dart';

class PagesRuangan {
  static var pages = [
    GetPage(
      name: RoutesRuangan.root,
      page: () => const RuanganPage(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RoutesRuangan.jadwal,
      page: () => const JadwalRuanganPage(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RoutesRuangan.booking,
      page: () => const BookingRuanganPage(),
      transition: Transition.cupertino,
    ),
  ];
}

class RoutesRuangan {
  static const String root = '/ruangan';
  static const String jadwal = '/ruangan/jadwal';
  static const String booking = '/ruangan/booking';
}
