import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:masjid_app/pages/notifikasi/notifikasi_service.dart';

class NotifikasiController extends GetxController {
  var isLoadingList = true.obs;
  var list = [].obs;

  Future<void> getData() async {
    try {
    final result = await NotifikasiService().getList();
    if (result != null) {
      list.value = result['data'];
    }
    isLoadingList.value = false;
    } catch (e) {
      if (kDebugMode) {
        debugPrint(e.toString());
      }
    }
  }
  
  @override
  void onInit() {
    getData();
    super.onInit();
  }
}
