import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masjid_app/pages/hadits/hadits_service.dart';

class HaditsController extends GetxController {
  var isLoadingList = true.obs;
  RxList list = [].obs;
  var txtController = TextEditingController();

  Future<void> getData() async {
    try {
      isLoadingList.value = true;
      final result = await HaditsService().getBooks();

      if (result != null && result['data'] != null) {
        list.value = result['data'];
      }

      isLoadingList.value = false;
    } catch (e) {
      isLoadingList.value = false;
      if (kDebugMode) {
        debugPrint('error hadits');
        debugPrint(e.toString());
      }
    }
  }

  @override
  void onInit() async {
    await getData();
    super.onInit();
  }
}
