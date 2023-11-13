import 'dart:async';

import 'package:get/get.dart';
import 'package:mesjid_app/routes/home/index.dart';
import 'package:mesjid_app/routes/onboard/index.dart';

class SplashscreenController extends GetxController {
  @override
  void onInit() {
    Timer(const Duration(seconds: 1), () {
      // Get.offAllNamed(RoutesHome.root);
      Get.offAllNamed(RoutesOnboard.root);
    });
    super.onInit();
  }
}
