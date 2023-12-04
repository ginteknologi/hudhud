import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masjid_app/pages/quran/quran_service.dart';
import 'package:masjid_app/routes/quran/index.dart';
import 'package:get_storage/get_storage.dart';

class ListAyatQuranController extends GetxController {
  final dataStore = GetStorage();
  var isLoadingList = true.obs;
  // var lastRead = {}.obs;
  RxList list = [].obs;
  List listSurah = [].obs;
  var searchController = TextEditingController();

  getData() async {
    // lastRead.value = dataStore.read('perAyatLastRead');
    final result = await QuranService().getList('all');
    list.value = result['data'];
    isLoadingList.value = false;
    // lastRead.value = {"id": 0, "suratName": "Al-Anfal", "ayatNumber": 20};
  }

  getDataSearch() async {
    // lastRead.value = dataStore.read('perAyatLastRead');
    final result = await QuranService().getList(searchController.text);
    list.value = result['data'];
    isLoadingList.value = false;
  }

  @override
  void onInit() async {
    await getData();
    super.onInit();
  }
}
