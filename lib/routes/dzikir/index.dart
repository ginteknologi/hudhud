import 'package:get/get.dart';
import 'package:masjid_app/pages/dzikir/dzikir_page.dart';

class PagesDzikir {
  static var pages = [
    GetPage(
      name: RoutesDzikir.root,
      page: () => const DzikirPage(),
      transition: Transition.cupertino,
      // middlewares: [IsLoginMiddleware()],
    ),
  ];
}

class RoutesDzikir {
  static const String root = '/dzikir';
}
