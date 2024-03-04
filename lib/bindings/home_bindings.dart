import 'package:get/get.dart';
import 'package:masjid_app/controllers/countDownEvent_controller.dart';
import 'package:masjid_app/controllers/dashboard_controller.dart';
import 'package:masjid_app/controllers/muazin_controller.dart';
import 'package:masjid_app/controllers/waktuSolat_controller.dart';
import 'package:masjid_app/controllers/dkm_controller.dart';
import 'package:masjid_app/controllers/home_controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DkmController());
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => DashboardController());
    Get.lazyPut(() => MuazinController());
    Get.lazyPut(() => CountDownEventController());
    Get.lazyPut(() => WaktuSolatController());
  }
}
