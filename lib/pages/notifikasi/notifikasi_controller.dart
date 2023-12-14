import 'package:get/get.dart';
import 'package:masjid_app/pages/notifikasi/notifikasi_service.dart';
import 'package:masjid_app/routes/notifikasi/index.dart';

class NotifikasiController extends GetxController {
  var isLoadingList = true.obs;
  var list = [].obs;

  getData() async {
    final result = await NotifikasiService().getList();
    list.value = result['data'];
    isLoadingList.value = false;
  }
  
  @override
  void onInit() {
    getData();
    super.onInit();
  }
}
