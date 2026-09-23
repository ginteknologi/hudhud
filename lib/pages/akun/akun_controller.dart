import 'package:get/get.dart';
import 'package:masjid_app/pages/akun/akun_service.dart';

class AkunController extends GetxController {
  var isLoadingList = true.obs;
  var list = {}.obs;

  Future<void> getData() async {
    final result = await AkunService().getList(page: 0, limit: 10);

    if (result != null && result['data'] != null) {
      list.value = result['data'];
    } else {
      list.value = {};
    }

    isLoadingList.value = false;
  }
}
