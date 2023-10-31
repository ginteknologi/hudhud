import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mesjid_app/pages/quran/quran_service.dart';
import 'package:mesjid_app/routes/quran/index.dart';

class ListAyatQuranController extends GetxController {
  var isLoadingList = true.obs;
  RxList list = [].obs;
  List listSurah = [].obs;
  var txtController = TextEditingController();

  getData() async {
    final result = await QuranService().getList();
    list.value = result['data'];
    isLoadingList.value = false;
  }
  @override
  void onInit() async{
    await getData();
    super.onInit();
  }
}
