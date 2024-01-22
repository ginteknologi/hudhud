import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:masjid_app/pages/home/home_controller.dart';
// import 'package:masjid_app/pages/quran/halaman/halaman_quran_page.dart';
import 'package:masjid_app/pages/quran/quran_controller.dart';
import 'package:masjid_app/pages/quran/quran_service.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class HalamanQuranController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final dataStore = GetStorage();
  var lastReadPerhalaman = {}.obs;
  var isLoadingList = true.obs;
  var list = {}.obs;
  List listSurah = [].obs;
  var visible = true.obs;

  var bookmarked = false.obs;

  var txtController = TextEditingController();
  late AnimationController animateController;

  final hctrl = Get.find<HomeController>();
  // final qctrl = Get.find<QuranController>();
  var selectedSurah = Get.arguments;
  var initialPage = 0.obs;

  getData() async {
    final result = await QuranService().getList('all');
    list.value = result['data'];
    isLoadingList.value = false;
  }

  getQuran() async {
    lastReadPerhalaman.value = dataStore.read('perHalamanLastRead');
    final String jsonString =
        await rootBundle.loadString('assets/img/quran/quran-page.json');
    listSurah = json.decode(jsonString);
    return listSurah;
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
  void onInit() {
    animateController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
    getQuran();
    super.onInit();
  }
}
