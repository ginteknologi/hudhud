import 'package:get/get.dart';
import 'package:mesjid_app/pages/sedekah/sedekah_page.dart';

class PagesSedekah {
  static var pages = [
    GetPage(
      name: RoutesSedekah.root,
      page: () => const SedekahPage(),
      transition: Transition.cupertino,
    ),
  ];
}

class RoutesSedekah {
  static const String root = '/sedekah';
}
