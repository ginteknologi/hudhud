import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masjid_app/pages/quran/new_quran/alquran_service.dart';
import 'package:get_storage/get_storage.dart';
import 'package:masjid_app/configs/main_controller.dart';
import 'package:masjid_app/routes/quran/index.dart';

class AlquranController extends GetxController {
  final dataStore = GetStorage();
  final gctrl = Get.find<MainController>();
  var isLoadingList = true.obs;
  var list = {}.obs;
  late BuildContext context;

  var txtController = TextEditingController();
  var indonesiaSaatIni = 'Belum baca Al-quran'.obs;
  var tajwidSaatIni = 'Belum baca Al-quran'.obs;
  var madinahSaatIni = 'Belum baca Al-quran'.obs;
  var ayatSaatIni = 'Belum baca Al-quran'.obs;
  var listMenu = [].obs;
  getData() async {
    try {
      final result = await AlquranService().getRandom();
      list.value = result['data'];
      isLoadingList.value = false;
    } catch (e) {
      print(e);
    }
  }

  lastRead() async {
    isLoadingList.value = true;
    ayatSaatIni.value = dataStore.read('perAyatLastRead')['id'] > 0
        ? dataStore.read('perAyatLastRead')['suratName'] +
            ' Ayat: ' +
            dataStore.read('perAyatLastRead')['ayatNumber'].toString()
        : 'Belum baca Al-quran';
    indonesiaSaatIni.value = dataStore.read('indonesiaLastRead')['id'] > 0
        ? dataStore.read('indonesiaLastRead')['surat'] +
            ' Hal: ' +
            dataStore.read('indonesiaLastRead')['hal'].toString()
        : 'Belum baca Al-quran';
    tajwidSaatIni.value = dataStore.read('tajwidLastRead')['id'] > 0
        ? dataStore.read('tajwidLastRead')['surat'] +
            ' Hal: ' +
            dataStore.read('tajwidLastRead')['hal'].toString()
        : 'Belum baca Al-quran';
    madinahSaatIni.value = dataStore.read('madinahLastRead')['id'] > 0
        ? dataStore.read('madinahLastRead')['surat'] +
            ' Hal: ' +
            dataStore.read('madinahLastRead')['hal'].toString()
        : 'Belum baca Al-quran';
    isLoadingList.value = false;
  }

  @override
  void onInit() async {
    await getData();
    listMenu.value = [
      {
        'title': 'Per Ayat',
        'onTap': () {
          Get.toNamed(RoutesQuran.perayat)?.then((result) {
            if (result == 'refresh') {
              // lastRead();
            }
          });
        },
        'icon': 'assets/icons/perayat.png'
      },
      {
        'title': 'Indonesia',
        'onTap': () {
          Get.toNamed(RoutesQuran.perpage)?.then((result) {
            if (result == 'refresh') {
              // lastRead();
            }
          });
        },
        'icon': 'assets/icons/indonesia.png'
      },
      {
        'title': 'Madinah',
        'onTap': () {
          Get.toNamed(RoutesQuran.perpagemadinah)?.then((result) {
            if (result == 'refresh') {
              // lastRead();
            }
          });
        },
        'icon': 'assets/icons/madinah.png'
      },
      {
        'title': 'Tajwid Indonesia',
        'onTap': () {
          Get.toNamed(RoutesQuran.perpagetajwid)?.then((result) {
            if (result == 'refresh') {
              // lastRead();
            }
          });
        },
        'icon': 'assets/icons/tajwid.png'
      },
      {
        'title': 'Ayat Kejutan',
        'onTap': null,
        'icon': 'assets/icons/kejutan.png'
      },
      {
        'title': 'Pengaturan',
        'onTap': () {
          Get.toNamed(RoutesQuran.pengaturan)?.then((result) {});
        },
        'icon': 'assets/icons/pengaturan.png'
      }
    ];
    print("listMenu.length");
    update();
    super.onInit();
  }
}
