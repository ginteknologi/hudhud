import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masjid_app/pages/quran/quran_service.dart';
import 'package:get_storage/get_storage.dart';
import 'package:masjid_app/configs/main_controller.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

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
  final ItemScrollController itemScrollController = ItemScrollController();
  TextEditingController inputFilterSurah = TextEditingController();
  TextEditingController inputFilterAyat = TextEditingController();
  final TextEditingController inputSearch = TextEditingController();
  var inputSurah = {}.obs;
  var selectedJuz = true.obs;
  var loadingFilter = false.obs;
  var isMax = false.obs;
  var isInput = true.obs;
  var maxAyat = 0.obs;
  var textError = ''.obs;

  Future getData() async {
    try {
      isLoadingList.value = true;
      final result = await QuranService().getList('');
      list.value = result['data'];
      listReverse.value = result['data'];
      isLoadingList.value = false;
    } catch (e) {
      print("<<<<<<<erorr get data ayat quran>>>>>>>");
      print(e);
    }
  }

  List<dynamic> search(String query) {
    return list
        .where((data) =>
            data['nama'].toString().toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  dynamic getSelectedItem(String selectedValue) {
    return list.firstWhere((data) => data['nama'] == selectedValue,
        orElse: () => null);
  }

  getDetailData(surahId) async {
    try {
      isLoadingDetail.value = true;
      final result = await QuranService().getDetail(surahId.toString());
      detail.value = result['data'];
      listAyat.value = detail['list'];
      offset += limit;
      inputFilterSurah.text = detail['nama'];
      // print(listAyat[0]['audio']['${dataStore.read('perAyatLastRead')['audio']}']);
      isLoadingDetail.value = false;
    } catch (e) {
      print(e);
    }
  }

  getDataSearch() async {
    // lastRead.value = dataStore.read('perAyatLastRead');
    isLoadingDetail.value = true;
    final result = await QuranService().getList(searchController.text);
    list.value = result['data'];
    isLoadingList.value = false;
  }

  bookmark(selectedData, ayatBookmarked, index) async {
    isLoadingDetail.value = true;
    if (ayatBookmarked) {
      gctrl.perAyatLastRead['ayatNumber'] = 0;
      gctrl.perAyatLastRead['suratName'] = '';
      gctrl.perAyatLastRead['id'] = 0;
      dataStore.write('perAyatLastRead', gctrl.perAyatLastRead);
    } else {
      gctrl.perAyatLastRead['ayatNumber'] = selectedData['ayat'];
      gctrl.perAyatLastRead['suratName'] = detail['nama'];
      gctrl.perAyatLastRead['id'] = detail['id'];
      dataStore.write('perAyatLastRead', gctrl.perAyatLastRead);
    }
    isLoadingDetail.value = false;
  }

  void scrollToIndex() {
    isLoadingDetail.value = true;
    if (itemScrollController.isAttached) {
      if (dataStore.read('perAyatLastRead')['id'] == detail['id']) {
        itemScrollController.scrollTo(
          index: dataStore.read('perAyatLastRead')['ayatNumber'] - 1,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    } else {
      print('ScrollController tidak berhasil diperoleh');
      Timer(Duration(seconds: 1), () {
        // Tunggu 1 detik (bisa disesuaikan) dan lakukan scrollToIndex lagi
        scrollToIndex();
      });
    }
    isLoadingDetail.value = false;
  }

  void dataGoTo(surah, ayat) async {
    try {
      isLoadingDetail.value = true;
      await getDetailData(surah['id']);
      int lastIndex = list.length;
      num reverseIndex = lastIndex - surah['id'];
      tabController.animateTo(reverseIndex.toInt());
      goToIndex(surah, ayat);
    } catch (e) {
      print(e);
    }
  }

  void goToIndex(surah, ayat) async {
    try {
      if (itemScrollController.isAttached) {
        if (surah['id'] == detail['id']) {
          itemScrollController.scrollTo(
            index: int.parse(ayat) - 1,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      } else {
        Timer(Duration(seconds: 1), () {
          goToIndex(surah, ayat);
        });
      }
      isLoadingDetail.value = false;
    } catch (e) {
      print(e);
    }
  }

  @override
  void onInit() async {
    await getData();
    if (dataStore.read('perAyatLastRead')['audio'] == null) {
      dataStore.write(
          'perAyatLastRead', {'audio': 'ar.alafasy', 'audiosource': 'server'});
    }
    list.value = list.reversed.toList();
    int lastIndex = list.length;
    int perAyatLastReadId = dataStore.read('perAyatLastRead')['id'] ?? 0;
    int result =
        perAyatLastReadId > 0 ? lastIndex - perAyatLastReadId : lastIndex - 1;
    tabController =
        TabController(vsync: this, length: list.length, initialIndex: result);
    await getDetailData(dataStore.read('perAyatLastRead')['id'] > 0
        ? dataStore.read('perAyatLastRead')['id']
        : 1); //first open page
    scrollToIndex();
    super.onInit();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}
