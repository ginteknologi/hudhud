import 'package:get/get.dart';
import 'package:mesjid_app/pages/onboarding/onboard_page.dart';

class PagesOnboard {
  static var pages = [
    GetPage(
      name: RoutesOnboard.root,
      page: () => OnboardPage(),
      maintainState: true,
    ),
  ];
}

class RoutesOnboard {
  static const String root = '/onboard';
}
