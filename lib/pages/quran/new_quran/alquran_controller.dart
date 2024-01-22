import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masjid_app/pages/quran/new_quran/alquran_service.dart';

class AlquranController extends GetxController {
  var isLoadingList = true.obs;
  RxList list = [].obs;

  var txtController = TextEditingController();

  getData() async {
    final result = await AlquranService().getList('all');
    list.value = result['data'];
    isLoadingList.value = false;
  }

  @override
  void onInit() {
    getData();
    super.onInit();
  }
}
