import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masjid_app/pages/hadits/hadits_service.dart';
import 'package:masjid_app/models/hadistData.dart';

class ContentHaditsController extends GetxController {
  var isLoadingList = true.obs;
  var list = <ListHadistData>[].obs;
  final Map arguments = Get.arguments ?? {};
  var txtController = TextEditingController();

  getList() async {
    try {
      isLoadingList.value = true;
      final result = await HaditsService().getContent(arguments['detail']['namaTabel'], arguments['content'].ID_Kitab, arguments['bab'].ID_Bab);
      for (var element in result['data']) {
        list.add(ListHadistData(
            NoHdt: element['NoHdt'],
            ID_Bab: element['ID_Bab'],
            ID_Kitab: element['ID_Kitab'],
            Isi_Arab: element['Isi_Arab'],
            Isi_Indonesia: element['Isi_Indonesia']
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
