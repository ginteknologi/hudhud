import 'package:get/get.dart';
import 'package:masjid_app/pages/notifikasi/notifikasi_service.dart';

class NotifikasiController extends GetxController {
  var isLoadingList = true.obs;
  var list = [].obs;

  getData() async {
    try {
    final result = await NotifikasiService().getList();
    list.value = result['data'];
    isLoadingList.value = false;
    } catch (e) {
      print(e);
    }
  }
  
  @override
  void onInit() {
    getData();
    super.onInit();
  }
}
