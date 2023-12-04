import 'package:get/get.dart';
import 'package:masjid_app/pages/test/test_page.dart';

class PagesTest {
  static var pages = [
    GetPage(
      name: RoutesTest.root,
      page: () => const TestPage(),
      transition: Transition.cupertino,
      // middlewares: [IsLoginMiddleware()],
    )
  ];
}

class RoutesTest {
  static const String root = '/test';
}
