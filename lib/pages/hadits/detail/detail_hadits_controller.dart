import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masjid_app/pages/hadits/hadits_service.dart';
import 'package:masjid_app/models/hadist_data.dart';

class DetailHaditsController extends GetxController {
  var isLoadingList = true.obs;
  var list = <ListKitabData>[].obs;
  final Map arguments = Get.arguments ?? {};
  var txtController = TextEditingController();

  Future<void> getList() async {
    try {
      isLoadingList.value = true;
      final result =
          await HaditsService().getList(arguments['detail']['namaTabel']);
      if (result != null && result['data'] != null) {
        list.clear();
        for (var element in result['data']) {
          list.add(ListKitabData(
            idKitab: element['ID_Kitab'],
            kitabIndonesia: element['Kitab_Indonesia'],
            kitabArab: element['Kitab_Arab'],
            noHdt: element['NoHdt'],
          ));
        }
      }
      isLoadingList.value = false;
    } catch (e) {
      isLoadingList.value = false;
      if (kDebugMode) {
        debugPrint('<<<Error Getlist>>>');
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
