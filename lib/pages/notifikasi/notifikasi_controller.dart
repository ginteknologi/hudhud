import 'package:get/get.dart';
import 'package:mesjid_app/pages/doa/doa_service.dart';
import 'package:mesjid_app/pages/notifikasi/notifikasi_service.dart';

class NotifikasiController extends GetxController {
  var isLoadingList = true.obs;
  var list = {}.obs;

  getData() async {
    final result = await NotifikasiService().getList(page: 0, limit: 10);
    list.value = result['data'];
    isLoadingList.value = false;
  }

  @override
  void onInit() {
    super.onInit();
  }
}
