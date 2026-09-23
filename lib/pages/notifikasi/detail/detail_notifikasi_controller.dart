import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:masjid_app/pages/notifikasi/notifikasi_service.dart';
import 'dart:convert';

class DetailNotifikasiController extends GetxController {
  final authStore = GetStorage();
  var isLoadingList = true.obs;
  var list = {}.obs;
  List listNotif = [].obs;
  final id = Get.parameters['id'];
  var dataUser = {};
  Future<void> getData() async {
    final result = await NotifikasiService().getDetail(id);
    if (result != null) {
      result['data']['data'] = jsonDecode(result['data']['data']);
      if (kDebugMode) {
        debugPrint(result['data']['data']['transaksi']['invoice'].toString());
      }
      list.value = result['data'];
      dataUser = authStore.read('userLogin');
    }
    isLoadingList.value = false;
  }
  @override
  void onInit() {
    getData();
    super.onInit();
  }
}
