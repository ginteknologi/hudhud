import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masjid_app/pages/quran/new_quran/alquran_service.dart';
import 'package:get_storage/get_storage.dart';
import 'package:masjid_app/configs/main_controller.dart';
class AlquranController extends GetxController {
  final dataStore = GetStorage();
  final gctrl = Get.find<MainController>();
  var isLoadingList = true.obs;
  var list = {}.obs;

  var txtController = TextEditingController();
  var indonesiaSaatIni = 'Belum baca Al-quran'.obs;
  var tajwidSaatIni = 'Belum baca Al-quran'.obs;
  var madinahSaatIni = 'Belum baca Al-quran'.obs;
  var ayatSaatIni = 'Belum baca Al-quran'.obs;

  getData() async {
    final result = await AlquranService().getRandom();
    list.value = result['data'];
    isLoadingList.value = false;
  }

  lastRead() async {
    isLoadingList.value = true;
    print(ayatSaatIni);
    ayatSaatIni.value = dataStore.read('perAyatLastRead')['id'] > 0 ? dataStore.read('perAyatLastRead')['suratName'] + ' Ayat: ' + dataStore.read('perAyatLastRead')['ayatNumber'].toString() : 'Belum baca Al-quran';
    indonesiaSaatIni.value = dataStore.read('indonesiaLastRead')['id'] > 0 ? dataStore.read('indonesiaLastRead')['surat'] + ' Hal: ' + dataStore.read('indonesiaLastRead')['hal'].toString() : 'Belum baca Al-quran';
    tajwidSaatIni.value = dataStore.read('tajwidLastRead')['id'] > 0 ? dataStore.read('tajwidLastRead')['surat'] + ' Hal: ' + dataStore.read('tajwidLastRead')['hal'].toString() : 'Belum baca Al-quran';
    madinahSaatIni.value = dataStore.read('madinahLastRead')['id'] > 0 ? dataStore.read('madinahLastRead')['surat'] + ' Hal: ' + dataStore.read('madinahLastRead')['hal'].toString() : 'Belum baca Al-quran';
    isLoadingList.value = false;
  }

  @override
  void onInit() async {
    await getData();
    await lastRead();
    super.onInit();
  }
}
