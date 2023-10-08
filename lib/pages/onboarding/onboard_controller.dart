import 'dart:developer';

import 'package:get/get.dart';

import 'package:mesjid_app/routes/auth/index.dart';

class OnboardController extends GetxController {
  var isLoadingList = true.obs;
  var list = {}.obs;
  var index = 0.obs;

  getData() async {
    // final result = await SedekahService().getList(page: 0, limit: 10);
    var result = {"data": []};
    list.value = result;
    isLoadingList.value = false;
  }

  goToLogin() async {
    log('data:');
    Get.offAllNamed(RoutesAuth.root);
  }

  @override
  void onInit() {
    super.onInit();
  }
}
