import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mesjid_app/pages/quran/quran_service.dart';

class DetailAyatQuranController extends GetxController {
  final dataStore = GetStorage();
  final surahId = Get.parameters['id'];
  final surahName = Get.parameters['nama_surah'];
  var isLoadingDetail = true.obs;
  var detail = {}.obs;
  var detailLastRead = {}.obs;
  List listSurah = [].obs;
  List listAyat = [].obs;
  late List<RxBool> listAyatBookmarked;
  late List<int> cekbook;

  var txtController = TextEditingController();

  // var surah = Get.arguments['selectedSurah'];

  var isChecked = false.obs;

  getData() async {
    final result = await QuranService().getDetail(surahId.toString());
    detail.value = result['data'];
    listAyat = detail['verses'];
    listAyatBookmarked =
        List.generate(detail['numberOfVerses'], (index) => false.obs);
    detailLastRead.value = dataStore.read('perAyatLastRead');
    if (detailLastRead['ayatNumber'] > 0) {
      listAyatBookmarked[detailLastRead['ayatNumber'] - 1] = true.obs;
    }
    isLoadingDetail.value = false;
  }

  bookmark() async {
    Fluttertoast.showToast(
        msg: "Ayat Berhasil Ditandai",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black87,
        timeInSecForIosWeb: 1,
        fontSize: Get.width / 30);
  }

  @override
  void onInit() async {
    await getData();
    super.onInit();
  }
}
