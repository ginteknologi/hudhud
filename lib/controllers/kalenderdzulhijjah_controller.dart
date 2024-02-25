import 'package:get/get.dart';
import 'package:masjid_app/service/kalenderdzulhijjah_service.dart';

class KalenderdzulhijjahController extends GetxController {
  var isLoading = true.obs;
  var listData = [].obs;
  Future<void> getData() async {
    try {
      final data = await KalenderdzulhijjahService.getData();
      listData.value = data;
      isLoading.value = false;
    } catch (e) {
      print("error");
      print(e);
    }
  }

  @override
  void onInit() async {
    super.onInit();
    await getData();
  }
}
