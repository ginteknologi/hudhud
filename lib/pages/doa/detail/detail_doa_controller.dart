import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masjid_app/pages/doa/doa_service.dart';
import 'package:masjid_app/models/doa_data.dart';

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

      if (result != null && result['data'] != null) {
        for (var element in result['data']) {
          list.add(DoaData(
              id: element['id'],
              judul: element['judul'],
              isi: element['isi'],
              updatedAt: element['updatedAt']));
        }
      }

      isLoadingList.value = false;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('<<erorr controller detail doa>>');
        debugPrint(e.toString());
      }
    }
  }

  Future<void> getSearchData() async {
    try {
      isLoadingList.value = true;
      list.clear();
      final result =
          await DoaService().getListSearchDoa(id, txtController.text);
      if (result != null && result['data'] != null) {
        for (var element in result['data']) {
          list.add(DoaData(
              id: element['id'],
              judul: element['judul'],
              isi: element['isi'],
              updatedAt: element['updatedAt']));
        }
      }
      isLoadingList.value = false;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('<<erorr controller detail doa>>');
        debugPrint(e.toString());
      }
    }
  }

  @override
  void onInit() async {
    await getData();
    super.onInit();
  }
}
