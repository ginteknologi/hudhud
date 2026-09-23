import 'dart:developer';

import 'package:get/get.dart';

import 'package:masjid_app/routes/auth/index.dart';

class KiblatController extends GetxController {
  var isLoadingList = true.obs;
  var list = {}.obs;
  var index = 0.obs;

  Future<void> getData() async {
    // final result = await SedekahService().getList(page: 0, limit: 10);
    var result = {"data": []};
    list.value = result;
    isLoadingList.value = false;
  }

  Future<void> goToLogin() async {
    log('data:');
    Get.offAllNamed(RoutesAuth.root);
  }

}
