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
      print(result['data']);
      list.value = result['data'];
      isLoadingList.value = false;
    } catch (e) {
      print('error haidst');
      print(e);
    }
  }

  @override
  void onInit() async {
    await getData();
    super.onInit();
  }
}
