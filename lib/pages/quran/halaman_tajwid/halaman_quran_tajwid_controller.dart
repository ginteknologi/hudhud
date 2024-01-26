import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:masjid_app/pages/home/home_controller.dart';
// import 'package:masjid_app/pages/quran/halaman/halaman_quran_page.dart';
import 'package:masjid_app/pages/quran/quran_service.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class HalamanQuranTajwidController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final dataStore = GetStorage();
  var lastReadPerhalaman = {}.obs;
  var isLoadingList = true.obs;
  List list = [].obs;
  List listSurah = [].obs;
  var visible = true.obs;
  var surahSaatIni = 'Quran Tajwid'.obs;
  var bookmarked = false.obs;

  var txtController = TextEditingController();
  late AnimationController animateController;
  var searchController = TextEditingController();

  final hctrl = Get.find<HomeController>();
  // final qctrl = Get.find<QuranController>();
  var selectedSurah = Get.arguments;
  var initialPage = 0.obs;
  int toSurat = 0;

  getQuran() async {
    lastReadPerhalaman.value = dataStore.read('perHalamanLastRead');
    final String jsonString = await rootBundle.loadString('assets/img/quran/quran-page-tajwid.json');
    listSurah = json.decode(jsonString);
    isLoadingList.value = false;
    return listSurah;
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
      Map filteredData = listSurah.firstWhereOrNull((item) => item['surat'].toString().toLowerCase() == itemData['name']['transliteration']['id'].toString().toLowerCase());
      toSurat = filteredData['id'];
      isLoadingList.value = false;
    } catch (e) {
      print('<<<<<<<<error controller getDataSearch>>>>>>>>');
      print(e);      
    }
  }
  refreshTitle(itemData) async {
    try {
      isLoadingList.value = true;
      // surahSaatIni.value = itemData;
      isLoadingList.value = false;
    } catch (e) {
      print('<<<<<<<<error controller getDataSearch>>>>>>>>');
      print(e);      
    }
  }
  bookmark() async {
    Fluttertoast.showToast(
        msg: "Halaman berhasil ditandai",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black87,
        timeInSecForIosWeb: 1,
        fontSize: Get.width / 30);
  }

  @override
  void onInit() async {
    // animateController = AnimationController(
    //   vsync: this,
    //   duration: Duration(milliseconds: 400),
    // );
    await getQuran();
    super.onInit();
  }
}
