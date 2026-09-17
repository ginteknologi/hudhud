import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masjid_app/pages/hadits/hadits_service.dart';
import 'package:masjid_app/models/hadistData.dart';

class DetailHaditsController extends GetxController {
  var isLoadingList = true.obs;
  var list = <ListKitabData>[].obs;
  final Map arguments = Get.arguments ?? {};
  var txtController = TextEditingController();

  Future<void> getList() async {
    try {
      isLoadingList.value = true;
      final result = await HaditsService().getList(arguments['detail']['namaTabel']);
      print(result['data']);
      for (var element in result['data']) {
        list.add(ListKitabData(
            ID_Kitab: element['ID_Kitab'],
            Kitab_Indonesia: element['Kitab_Indonesia'],
            Kitab_Arab: element['Kitab_Arab'],
            NoHdt: element['NoHdt']
          ));
      }
      isLoadingList.value = false;
    } catch (e) {
      print('<<<Error Getlist>>>');
      print(e);
    }
  }

  @override
  void onInit() async {
    await getList();
    super.onInit();
  }
}
