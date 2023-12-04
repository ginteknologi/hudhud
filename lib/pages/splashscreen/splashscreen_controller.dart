import 'dart:async';

import 'package:get/get.dart';
import 'package:masjid_app/routes/auth/index.dart';
import 'package:masjid_app/routes/home/index.dart';
import 'package:masjid_app/configs/main_controller.dart';
// import 'package:masjid_app/routes/onboard/index.dart';

class SplashscreenController extends GetxController {
  final gctrl = Get.find<MainController>();
  @override
  void onInit() {
    Timer(const Duration(seconds: 1), () {
      if (gctrl.isLogin == true) {
        Get.offAllNamed(RoutesHome.root);
      }else{
        Get.offAllNamed(RoutesAuth.root);
      }
    });
    super.onInit();
  }
}
