import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masjid_app/pages/doa/doa_service.dart';

class DetailDoaController extends GetxController {
  var isLoadingList = true.obs;
  var list = [].obs;
  final Map arguments = Get.arguments ?? {};

  List listDoa = [].obs;

  var txtController = TextEditingController();

  getData() async {
    final result = await DoaService().getListDoa(arguments['category']['id']);
    list.value = result['data'];
    isLoadingList.value = false;
  }

  goToDetail(param) {
  }

  @override
  void onInit() async{
   await getData();
    super.onInit();
  }
}
