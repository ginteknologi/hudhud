import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masjid_app/pages/quran/quran_service.dart';
import 'package:masjid_app/routes/quran/index.dart';
import 'package:get_storage/get_storage.dart';

class ListAyatQuranController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final dataStore = GetStorage();
  var isLoadingList = true.obs;
  var isLoadingDetail = false.obs;
  // var lastRead = {}.obs;
  var txtController = TextEditingController();
  RxList list = [].obs;
  RxList listReverse = [].obs;
  List listSurah = [].obs;
  RxList listAyat = [].obs;
  RxMap detail = {}.obs;
  var searchController = TextEditingController();
  late TabController tabController;

  getData() async {
    // lastRead.value = dataStore.read('perAyatLastRead');
    final result = await QuranService().getList('all');
    list.value = result['data'];
    listReverse.value = result['data'];
    isLoadingList.value = false;
    // lastRead.value = {"id": 0, "suratName": "Al-Anfal", "ayatNumber": 20};
  }

  getDetailData(surahId) async {
    isLoadingDetail.value = true;
    final result = await QuranService().getDetail(surahId.toString());
    detail.value = result['data'];
    listAyat.value = detail['verses'];
    isLoadingDetail.value = false;
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
    list.value = list.reversed.toList();
    tabController = TabController(
        vsync: this, length: list.length, initialIndex: list.length - 1);
    await getDetailData(1); //first open page
    super.onInit();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}
