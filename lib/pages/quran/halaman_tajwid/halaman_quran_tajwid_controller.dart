import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:masjid_app/pages/home/home_controller.dart';
// import 'package:masjid_app/pages/quran/halaman/halaman_quran_page.dart';
import 'package:masjid_app/pages/quran/quran_service.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:masjid_app/configs/main_controller.dart';

class HalamanQuranTajwidController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final dataStore = GetStorage();
  final gctrl = Get.find<MainController>();
  var lastReadPerhalaman = {}.obs;
  var isLoadingList = true.obs;
  List list = [].obs;
  List listSurah = [].obs;
  var visible = true.obs;
  var surahSaatIni = 'Quran Tajwid'.obs;
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
    lastReadPerhalaman.value = dataStore.read('tajwidLastRead');
    final String jsonString = await rootBundle.loadString('assets/img/quran/quran-page-tajwid.json');
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
    print(list);
    isLoadingList.value = false;
    } catch (e) {
      print('<<<<<<<<error controller getDataSearch>>>>>>>>');
      print(e);
    }
  }
  goToData(itemData) async {
    try {
      isLoadingList.value = true;
      Map filteredData = listSurah.firstWhereOrNull((item) => item['surat'].toString().toLowerCase() == itemData['nama'].toString().toLowerCase());
      surahSaatIni.value = filteredData['surat'];
      halSaatIni.value = filteredData['hal'].toString();
      toSurat = filteredData['id'];
      print(filteredData['id']);
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
      Map filteredData = listSurah.firstWhereOrNull((item) => item['hal'] == result['data']['hal']);
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
      Map filteredData = listSurah.firstWhereOrNull((item) => item['hal'].toString() == numbertogo);
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
      print('<<<<<<<<<<<wei>>>>>>>>>>>');
      isLoadingList.value = false;

  }

  @override
  void onInit() async {
    // animateController = AnimationController(
    //   vsync: this,
    //   duration: Duration(milliseconds: 400),
    // );
    await getQuran();
    await getDataSearch();
    dataStore.read('tajwidLastRead') == null ? surahSaatIni.value = 'Quran Tajwid' : surahSaatIni.value = dataStore.read('tajwidLastRead')['surat'];
    dataStore.read('tajwidLastRead') == null ? halSaatIni.value = '1' : halSaatIni.value = dataStore.read('tajwidLastRead')['hal'].toString();
    super.onInit();
  }
}
