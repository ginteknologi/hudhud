import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masjid_app/pages/hadits/hadits_service.dart';
import 'package:masjid_app/models/hadistData.dart';

class BabHaditsController extends GetxController {
  var isLoadingList = true.obs;
  var list = <ListBabData>[].obs;
  final Map arguments = Get.arguments ?? {};
  var txtController = TextEditingController();

  getList() async {
    try {
    isLoadingList.value = true;
    final result = await HaditsService().getBab(arguments['content'].ID_Kitab, arguments['detail']['namaTabel']);
      for (var element in result['data']) {
        list.add(ListBabData(
            ID_Bab: element['ID_Bab'],
            ID_Kitab: element['ID_Kitab'],
            Bab_Indonesia: element['Bab_Indonesia'],
            Bab_Arab: element['Bab_Arab']
          ));
      }    
    isLoadingList.value = false;
    } catch (e) {
      print(e);
    }
  }

  @override
  void onInit()async{
    await getList();
    super.onInit();
  }
}
