import 'package:get/get.dart';
import 'package:masjid_app/controllers/Kalenderdzulhijjah_controller.dart';

class KalenderdzulhijjahBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(KalenderdzulhijjahController());
  }
}
