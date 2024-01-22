import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HaditsController extends GetxController {
  var isLoadingList = true.obs;
  RxList list = [].obs;

  var txtController = TextEditingController();

  getData() async {
    // final result = await AlquranService().getList('all');
    // list.value = result['data'];
    isLoadingList.value = false;
  }

  @override
  void onInit() {
    getData();
    super.onInit();
  }
}
