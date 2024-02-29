import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:masjid_app/pages/home/home_controller.dart';
// import 'package:masjid_app/pages/quran/halaman/halaman_quran_page.dart';
import 'package:masjid_app/pages/quran/quran_service.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:masjid_app/controllers/main_controller.dart';

class HalamanQuranController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final dataStore = GetStorage();
  final gctrl = Get.find<MainController>();
  var lastReadPerhalaman = {}.obs;
  var isLoadingList = true.obs;
  List list = [].obs;
  List listSurah = [].obs;
  var visible = true.obs;
  var surahSaatIni = 'Quran Indonesia'.obs;
  var halSaatIni = '1'.obs;
  var bookmarked = false.obs;

  var txtController = TextEditingController();
  late AnimationController animateController;
  var searchController = TextEditingController();
  TextEditingController inputFilter = TextEditingController();
  var selectedJuz = true.obs;
  var loadingFilter = false.obs;
  var isMax = false.obs;

  final hctrl = Get.find<HomeController>();
  // final qctrl = Get.find<QuranController>();
  var selectedSurah = Get.arguments;
  var initialPage = 0.obs;
  int toSurat = 0;

  getQuran() async {
    try {
      lastReadPerhalaman.value = dataStore.read('indonesiaLastRead');
      final String jsonString =
          await rootBundle.loadString('assets/img/quran/quran-page.json');
      listSurah = json.decode(jsonString);
      isLoadingList.value = false;
      return listSurah;
    } catch (e) {
      print('<<<<<<<<error controller getDataSearch>>>>>>>>');
      print(e);
    }
  }

  getDataSearch() async {
    try {
      // lastRead.value = dataStore.read('perAyatLastRead');
      isLoadingList.value = true;
      final result = await QuranService().getList(searchController.text);
      list = result['data'];
      isLoadingList.value = false;
    } catch (e) {
      print('<<<<<<<<error controller getDataSearch>>>>>>>>');
      print(e);
    }
  }

  goToData(itemData) async {
    try {
      isLoadingList.value = true;
      Map filteredData = listSurah.firstWhereOrNull((item) =>
          item['surat'].toString().toLowerCase() ==
          itemData['nama'].toString().toLowerCase());
      surahSaatIni.value = filteredData['surat'];
      halSaatIni.value = filteredData['hal'].toString();
      toSurat = filteredData['id'];
      isLoadingList.value = false;
    } catch (e) {
      print('<<<<<<<<error controller getDataSearch>>>>>>>>');
      print(e);
    }
  }

  goToNumber(numbertogo) async {
    try {
      isLoadingList.value = true;
      final result = await QuranService().getNumber(numbertogo);
      Map filteredData = listSurah
          .firstWhereOrNull((item) => item['hal'] == result['data']['hal']);
      surahSaatIni.value = filteredData['surat'];
      halSaatIni.value = filteredData['hal'].toString();
      toSurat = filteredData['id'];
      isLoadingList.value = false;
    } catch (e) {
      print('<<<<<<<<error controller getDataSearch>>>>>>>>');
      print(e);
    }
  }

  goToHal(numbertogo) async {
    try {
      isLoadingList.value = true;
      Map filteredData = listSurah
          .firstWhereOrNull((item) => item['hal'].toString() == numbertogo);
      surahSaatIni.value = filteredData['surat'];
      halSaatIni.value = filteredData['hal'].toString();
      toSurat = filteredData['id'];
      isLoadingList.value = false;
    } catch (e) {
      print('<<<<<<<<error controller getDataSearch>>>>>>>>');
      print(e);
    }
  }

  bookmark() async {
    isLoadingList.value = true;
    isLoadingList.value = false;
  }

  @override
  void onInit() async {
    await getQuran();
    await getDataSearch();
    dataStore.read('indonesiaLastRead') == null
        ? surahSaatIni.value = 'Quran Indonesia'
        : surahSaatIni.value = dataStore.read('indonesiaLastRead')['surat'];
    dataStore.read('indonesiaLastRead') == null
        ? halSaatIni.value = '1'
        : halSaatIni.value =
            dataStore.read('indonesiaLastRead')['hal'].toString();
    super.onInit();
  }
}
