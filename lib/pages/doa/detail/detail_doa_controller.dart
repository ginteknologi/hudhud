import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masjid_app/pages/doa/doa_service.dart';
import 'package:masjid_app/models/doaData.dart';

class DetailDoaController extends GetxController {
  var isLoadingList = true.obs;
  var list = <DoaData>[].obs;
  final Map arguments = Get.arguments ?? {};
  String id = Get.parameters['id'] ?? '';
  List listDoa = [].obs;

  var txtController = TextEditingController();

  Future<void> getData() async {
    try {
      list.clear();
      final result = await DoaService().getListDoa(id);
      for (var element in result['data']) {
        list.add(DoaData(
            id: element['id'],
            judul: element['judul'],
            isi:element['isi'],
            updatedAt: element['updatedAt']));
      }
      isLoadingList.value = false;
    } catch (e) {
      print('<<erorr controller detail doa>>');
      print(e);
    }
  }

  Future<void> getSearchData() async {
    try {
      isLoadingList.value = true;
      list.clear();
      final result = await DoaService().getListSearchDoa(id, txtController.text);
      for (var element in result['data']) {
        list.add(DoaData(
            id: element['id'],
            judul: element['judul'],
            isi:element['isi'],
            updatedAt: element['updatedAt']));
      }
      isLoadingList.value = false;
    } catch (e) {
      print('<<erorr controller detail doa>>');
      print(e);
    }
  }

  @override
  void onInit() async {
    await getData();
    super.onInit();
  }
}
