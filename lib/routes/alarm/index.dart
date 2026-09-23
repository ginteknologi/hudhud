import 'package:get/get.dart';
import 'package:masjid_app/pages/alarm_solat/alarm_solat_page.dart';

class PagesAlarm {
  static var pages = [
    GetPage(
      name: RoutesAlarm.root,
      page: () => AlarmSolatPage(),
      transition: Transition.cupertino,
    ),
  ];
}

class RoutesAlarm {
  static const String root = '/alarm';
}
