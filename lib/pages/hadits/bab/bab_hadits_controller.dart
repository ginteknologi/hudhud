import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masjid_app/pages/hadits/hadits_service.dart';

class BabHaditsController extends GetxController {
  var isLoadingList = true.obs;
  RxList list = [].obs;
  final Map arguments = Get.arguments ?? {};
  var txtController = TextEditingController();

  getList() async {
    try {
    isLoadingList.value = true;
    final result = await HaditsService().getBab(arguments['content']['ID_Kitab'], arguments['detail']['namaTabel']);
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
