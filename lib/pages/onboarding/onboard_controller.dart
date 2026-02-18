// lib/pages/onboarding/onboard_controller.dart
import 'dart:developer';
import 'package:get/get.dart';
import 'package:masjid_app/routes/auth/index.dart';

class OnboardController extends GetxController {
  var isLoadingList = true.obs;
  var list = {}.obs;
  var index = 0.obs;

  getData() async {
    var result = {"data": []};
    list.value = result;
    isLoadingList.value = false;
  }

  void goToLogin() {
    log('goToLogin');
    Get.offAllNamed(RoutesAuth.root);
  }
}
