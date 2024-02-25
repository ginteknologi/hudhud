import 'package:get/get.dart';
import 'package:masjid_app/controllers/countDownEvent_controller.dart';
import 'package:masjid_app/controllers/dashboard_controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DashboardController());
    Get.lazyPut(() => CountDownEventController());
  }
}
