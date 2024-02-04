import 'package:get/get.dart';
import 'package:masjid_app/pages/hadits/content/content_hadits_page.dart';
import 'package:masjid_app/pages/hadits/detail/detail_hadits_page.dart';
import 'package:masjid_app/pages/hadits/hadits_page.dart';
import 'package:masjid_app/pages/hadits/bab/bab_hadits_page.dart';

class PagesHadits {
  static var pages = [
    GetPage(
      name: RoutesHadits.root,
      page: () => HaditsPage(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RoutesHadits.detail,
      page: () => DetailHaditsPage(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RoutesHadits.bab,
      page: () => BabHaditsPage(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RoutesHadits.content,
      page: () => ContentHaditsPage(),
      transition: Transition.cupertino,
    ),
  ];
}

class RoutesHadits {
  static const String root = '/hadits';
  static const String detail = '/hadits/:id';
  static const String bab = '/hadits/bab/:id';
  static const String content = '/hadits/:id/:content';
}
