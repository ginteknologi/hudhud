import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masjid_app/pages/quran/new_quran/alquran_service.dart';
import 'package:get_storage/get_storage.dart';
import 'package:masjid_app/controllers/main_controller.dart';
import 'package:masjid_app/routes/quran/index.dart';

class AlquranController extends GetxController {
  final dataStore = GetStorage();
  final gctrl = Get.find<MainController>();
  var isLoadingRandom = true.obs;
  var isLoadingList = true.obs;
  var list = {}.obs;
  late BuildContext context;

  var txtController = TextEditingController();
  var indonesiaSaatIni = 'Belum dibookmark'.obs;
  var tajwidSaatIni = 'Belum dibookmark'.obs;
  var madinahSaatIni = 'Belum dibookmark'.obs;
  var ayatSaatIni = 'Belum dibookmark'.obs;
  var listMenu = [].obs;

  Future<void> getData() async {
    try {
      final result = await AlquranService().getRandom();
      list.value = result['data'];
      isLoadingRandom.value = false;
    } catch (e) {
      if (kDebugMode) {
        debugPrint(e.toString());
      }
    }
  }

  @override
  void onInit() async {
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
    if (kDebugMode) {
      debugPrint("listMenu.length");
    }
    super.onInit();
  }
}
