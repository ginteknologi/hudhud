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
  getData() async {
    final result = await NotifikasiService().getDetail(id);
    result['data']['data'] = jsonDecode(result['data']['data']);
    print(result['data']['data']['transaksi']['invoice']);
    list.value = result['data'];
    dataUser = authStore.read('userLogin');
    isLoadingList.value = false;
  }
  @override
  void onInit() {
    getData();
    super.onInit();
  }
}
