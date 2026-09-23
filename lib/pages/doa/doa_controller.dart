import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:masjid_app/pages/doa/doa_service.dart';
import 'package:masjid_app/models/kategori_doa_data.dart';

class DoaController extends GetxController {
  var isLoadingList = true.obs;
  var list = <KategoriDoaData>[].obs;

  Future<void> getData() async {
    try {
      final result = await DoaService().getList();
      if (result != null && result['data'] != null) {
        for (var element in result['data']) {
          list.add(KategoriDoaData(
              id: element['id'],
              name: element['name'],
              updatedAt: element['updatedAt']));
        }
      }

      isLoadingList.value = false;
      if (kDebugMode) {
        debugPrint(list.toString());
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('<<error controller getdata doa>> $e');
      }
    }
  }

  @override
  void onInit() {
    getData();
    super.onInit();
  }
}
