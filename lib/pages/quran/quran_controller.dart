import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mesjid_app/pages/quran/quran_service.dart';

class QuranController extends GetxController {
  var isLoadingList = true.obs;
  RxList list = [].obs;

  var txtController = TextEditingController();

  getData() async {
    final result = await QuranService().getList('all');
    list.value = result['data'];
    isLoadingList.value = false;
  }

  @override
  void onInit() {
    getData();
    super.onInit();
  }
}
