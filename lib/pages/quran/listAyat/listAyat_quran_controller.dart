import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masjid_app/pages/quran/quran_service.dart';
import 'package:get_storage/get_storage.dart';
import 'package:masjid_app/configs/main_controller.dart';

class ListAyatQuranController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final dataStore = GetStorage();
  final gctrl = Get.find<MainController>();
  final surahId = Get.parameters['id'];
  final surahName = Get.parameters['nama_surah'];  
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
  int offset = 0;
  int limit = 10;
  
  getData() async {
    final result = await QuranService().getList('all');
    list.value = result['data'];
    listReverse.value = result['data'];
    isLoadingList.value = false;
  }

  getDetailData(surahId) async {
    isLoadingDetail.value = true;
    final result = await QuranService().getDetail(surahId.toString());
    detail.value = result['data'];
    listAyat.value = detail['verses'];
    offset += limit;
    isLoadingDetail.value = false;
  }

  getDataSearch() async {
    // lastRead.value = dataStore.read('perAyatLastRead');
    final result = await QuranService().getList(searchController.text);
    list.value = result['data'];
    isLoadingList.value = false;
  }
bookmark(selectedData,ayatBookmarked, index) async {
    isLoadingDetail.value = true;
    if (ayatBookmarked) {
      gctrl.perAyatLastRead['ayatNumber'] = 0;
      gctrl.perAyatLastRead['suratName'] = '';
      gctrl.perAyatLastRead['id'] = 0;
      dataStore.write('perAyatLastRead', gctrl.perAyatLastRead);

    } else{
      gctrl.perAyatLastRead['ayatNumber'] = selectedData['number']['inSurah'];
      gctrl.perAyatLastRead['suratName'] = detail['name']['transliteration']['id'];
      gctrl.perAyatLastRead['id'] = detail['number'];
      dataStore.write('perAyatLastRead', gctrl.perAyatLastRead);
    }
    isLoadingDetail.value = false;
  }
  @override
  void onInit() async {
    await getData();
    list.value = list.reversed.toList();
    int lastIndex = list.length;
    int perAyatLastReadId = dataStore.read('perAyatLastRead')['id'] ?? 0;
    int result = perAyatLastReadId > 0 ? lastIndex - perAyatLastReadId : lastIndex - 1;
    tabController = TabController(
        vsync: this, length: list.length, initialIndex: result);
    await getDetailData(dataStore.read('perAyatLastRead')['id'] > 0 ? dataStore.read('perAyatLastRead')['id'] : 1); //first open page
    print(dataStore.read('perAyatLastRead'));
    print(dataStore.read('perAyatLastRead')['id']);
    print(result);
    super.onInit();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}
