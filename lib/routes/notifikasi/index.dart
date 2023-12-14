import 'package:get/get.dart';
import 'package:masjid_app/pages/notifikasi/detail/detail_notifikasi_page.dart';
import 'package:masjid_app/pages/notifikasi/invoice/invoice_page.dart';
import 'package:masjid_app/pages/notifikasi/notifikasi_page.dart';

class PagesNotifikasi {
  static var pages = [
    GetPage(
      name: RoutesNotifikasi.root,
      page: () => const NotifikasiPage(),
      transition: Transition.cupertino,
      // middlewares: [IsLoginMiddleware()],
    ),
    GetPage(
      name: RoutesNotifikasi.detail,
      page: () => const DetailNotifikasiPage(),
      transition: Transition.cupertino,
      // middlewares: [IsLoginMiddleware()],
    ),
    GetPage(
      name: RoutesNotifikasi.invoice,
      page: () => const InvoiceNotifikasiPage(),
      transition: Transition.cupertino,
      // middlewares: [IsLoginMiddleware()],
    ),
  ];
}

class RoutesNotifikasi {
  static const String root = '/notifikasi';
  static const String detail = '/notifikasi/detail/:id';
  static const String invoice = '/notifikasi/detail/invoice/:invoice';
}
