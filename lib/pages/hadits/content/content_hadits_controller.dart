import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masjid_app/pages/hadits/hadits_service.dart';
import 'package:masjid_app/models/hadist_data.dart';

class ContentHaditsController extends GetxController {
  var isLoadingList = true.obs;
  var list = <ListHadistData>[].obs;
  final Map arguments = Get.arguments ?? {};
  var txtController = TextEditingController();
  var currentIndex = 0.obs;

  Future<void> getList() async {
    try {
      isLoadingList.value = true;
      final result = await HaditsService().getContent(
          arguments['detail']['namaTabel'],
          arguments['content'].idKitab,
          arguments['bab'].idBab);

      if (result != null && result['data'] != null) {
        for (var element in result['data']) {
          list.add(ListHadistData(
            noHdt: element['NoHdt'],
            idBab: element['ID_Bab'],
            idKitab: element['ID_Kitab'],
            isiArab: element['Isi_Arab'],
            isiIndonesia: element['Isi_Indonesia'],
          ));
        }
      }
      isLoadingList.value = false;
    } catch (e) {
      isLoadingList.value = false;
      if (kDebugMode) {
        debugPrint(e.toString());
      }
    }
  }

  void nextHadits() {
    if (currentIndex.value < list.length - 1) {
      currentIndex.value++;
    }
  }

  void previousHadits() {
    if (currentIndex.value > 0) {
      currentIndex.value--;
    }
  }

  @override
  void onInit() async {
    await getList();
    super.onInit();
  }
}
