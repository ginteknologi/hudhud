import 'package:get/get.dart';
import 'package:mesjid_app/pages/sedekah/detail/detailsedekah_page.dart';
import 'package:mesjid_app/pages/sedekah/sedekah_page.dart';
import 'package:mesjid_app/pages/sedekah/transaksi/metode/metode_transaksi_page.dart';
import 'package:mesjid_app/pages/sedekah/transaksi/paymentEwallet/payment_transaksi_page.dart';
import 'package:mesjid_app/pages/sedekah/transaksi/status/status_sedekah_page.dart';
import 'package:mesjid_app/pages/sedekah/transaksi/transaksi_sedekah_page.dart';

class PagesSedekah {
  static var pages = [
    GetPage(
      name: RoutesSedekah.root,
      page: () => const SedekahPage(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RoutesSedekah.detail,
      page: () => const DetailSedekahPage(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RoutesSedekah.transaksi,
      page: () => const TransaksiSedekahPage(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RoutesSedekah.metode,
      page: () => const MetodeTransaksiSedekahPage(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RoutesSedekah.payment,
      page: () => const PaymentTransaksiSedekahPage(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RoutesSedekah.status,
      page: () => const StatusTransaksiSedekahPage(),
      transition: Transition.cupertino,
    ),
  ];
}

class RoutesSedekah {
  static const String root = '/sedekah';
  static const String detail = '/sedekah/:id';
  static const String transaksi = '/sedekah/:id/transaksi';
  static const String metode = '/sedekah/:id/transaksi/metode';
  static const String payment = '/sedekah/:id/transaksi/payment';
  static const String status = '/sedekah/:id/transaksi/status';
}
