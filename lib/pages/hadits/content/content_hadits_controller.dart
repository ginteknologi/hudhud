import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masjid_app/pages/hadits/hadits_service.dart';

class ContentHaditsController extends GetxController {
  var isLoadingList = true.obs;
  RxList list = [].obs;
  final Map arguments = Get.arguments ?? {};
  var txtController = TextEditingController();

  getList() async {
    try {
    isLoadingList.value = true;
    final result = await HaditsService().getContent(arguments['detail']['namaTabel'], arguments['content']['ID_Kitab'], arguments['bab']['ID_Bab']);
    list.value = result['data'];
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
