import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masjid_app/pages/hadits/hadits_service.dart';
import 'package:masjid_app/models/hadist_data.dart';

class BabHaditsController extends GetxController {
  var isLoadingList = true.obs;
  var list = <ListBabData>[].obs;
  final Map arguments = Get.arguments ?? {};
  var txtController = TextEditingController();

  Future<void> getList() async {
    try {
      isLoadingList.value = true;
      final result = await HaditsService().getBab(
          arguments['content'].idKitab, arguments['detail']['namaTabel']);
      if (result != null && result['data'] != null) {
        for (var element in result['data']) {
          list.add(ListBabData(
              idBab: element['ID_Bab'],
              idKitab: element['ID_Kitab'],
              babIndonesia: element['Bab_Indonesia'],
              babArab: element['Bab_Arab']));
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

  @override
  void onInit() async {
    await getList();
    super.onInit();
  }
}
