import 'package:get/get.dart';
import 'package:masjid_app/pages/dkm/dkm_page.dart';

class PagesDkm {
  static var pages = [
    GetPage(
      name: RoutesDkm.root,
      page: () => const DkmPage(),
      transition: Transition.cupertino,
    ),
  ];
}

class RoutesDkm {
  static const String root = '/dkm';
}
