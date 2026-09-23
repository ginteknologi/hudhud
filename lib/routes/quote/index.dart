import 'package:get/get.dart';
import 'package:masjid_app/pages/quote/quote_page.dart';

class PagesQuote {
  static var pages = [
    GetPage(
      name: RoutesQuote.root,
      page: () => QuotePage(),
      transition: Transition.cupertino,
    ),
  ];
}

class RoutesQuote {
  static const String root = '/quote';
}
