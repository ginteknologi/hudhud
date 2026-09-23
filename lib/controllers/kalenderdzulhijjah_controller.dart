import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:masjid_app/service/kalenderdzulhijjah_service.dart';

class KalenderdzulhijjahController extends GetxController {
  DateTime sekarang = DateTime.now();
  DateFormat formatter = DateFormat.yMMMM();

  var isLoading = true.obs;
  var listData = [].obs;
  var tahunBulan = "asdasdasd".obs;

  Future<void> getData() async {
    try {
      final data = await KalenderdzulhijjahService.getData();
      listData.value = data;
      isLoading.value = false;
    } catch (e) {
      if (kDebugMode) {
        debugPrint("error: $e");
        debugPrint(e.toString());
      }
    }
  }

  @override
  void onInit() async {
    super.onInit();
    tahunBulan.value = formatter.format(sekarang);
    await getData();
  }
}
