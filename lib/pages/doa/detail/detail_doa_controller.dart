import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mesjid_app/pages/doa/doa_service.dart';
import 'package:mesjid_app/routes/doa/index.dart';

class DetailDoaController extends GetxController {
  var isLoadingList = true.obs;
  var list = [].obs;

  List listDoa = [].obs;

  var txtController = TextEditingController();

  getData() async {
    final result = await DoaService().getList();
    list.value = result;
    isLoadingList.value = false;
  }

  goToDetail(param) {
    Get.toNamed('${RoutesDoa.root}/${Get.parameters['id']}/$param');
  }

  @override
  void onInit() async{
   await getData();
    super.onInit();
  }
}
