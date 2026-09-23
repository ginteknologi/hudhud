import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:masjid_app/pages/quran/quran_service.dart';
import 'package:masjid_app/controllers/main_controller.dart';

class DetailAyatQuranController extends GetxController {
  final dataStore = GetStorage();
  final gctrl = Get.find<MainController>();
  final String? surahId = Get.parameters['id'];
  final String? surahName = Get.parameters['nama_surah'];
  var isLoadingDetail = true.obs;
  var detail = <String, dynamic>{}.obs;
  List<Map<String, dynamic>> listSurah = [];
  List<Map<String, dynamic>> listAyat = [];
  var ayatBookmarked = false.obs;
  var surahBookmarked = false.obs;
  late List<int> cekbook;

  var txtController = TextEditingController();

  // var surah = Get.arguments['selectedSurah'];

  var isChecked = false.obs;

  Future<void> getData() async {
    final result = await QuranService().getDetail(surahId.toString());
    detail.value = Map<String, dynamic>.from(result['data']);
    listAyat = List<Map<String, dynamic>>.from(detail['verses']);
    if (gctrl.perAyatLastRead['suratName'] ==
        detail['name']['transliteration']['id']) {
      surahBookmarked.value = true;
    }
    isLoadingDetail.value = false;
  }

  Future<void> bookmark(Map<String, dynamic> selectedData, int index) async {
    isLoadingDetail.value = true;
    if (ayatBookmarked.value) {
      gctrl.perAyatLastRead['ayatNumber'] = 0;
      gctrl.perAyatLastRead['suratName'] = '';
      gctrl.perAyatLastRead['id'] = 0;
      ayatBookmarked.value = false;
      dataStore.write('perAyatLastRead', gctrl.perAyatLastRead);
    } else {
      gctrl.perAyatLastRead['ayatNumber'] = selectedData['number']['inSurah'];
      gctrl.perAyatLastRead['suratName'] = surahName.toString();
      gctrl.perAyatLastRead['id'] = selectedData['number']['inSurah'];
      ayatBookmarked.value = true;
      dataStore.write('perAyatLastRead', gctrl.perAyatLastRead);
    }
    isLoadingDetail.value = false;
    // Fluttertoast.showToast(
    //     msg: "Ayat Berhasil Ditandai",
    //     toastLength: Toast.LENGTH_SHORT,
    //     gravity: ToastGravity.BOTTOM,
    //     backgroundColor: Colors.black87,
    //     timeInSecForIosWeb: 1,
    //     fontSize: Get.width / 30);
  }

  @override
  void onInit() async {
    await getData();
    super.onInit();
  }
}