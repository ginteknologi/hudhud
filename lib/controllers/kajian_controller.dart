import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:masjid_app/service/kajian_service.dart';
import 'package:masjid_app/models/kajianData.dart';

class KajianController extends GetxController {
  DateTime sekarang = DateTime.now();
  DateFormat formatter = DateFormat.yMMMM();

  var isLoading = true.obs;
  var listData = [].obs;
  var listKajian = <KajianData>[].obs;

  Future<void> getData() async {
    try {
      isLoading = true.obs;
      if (Get.arguments['type'] == 'tafsir') {
        listKajian.value = await KajianService.getListKajian();
      }else{
        listKajian.value = await KajianService.getListKajiLive();
      }
      isLoading.value = false;
    } catch (e) {
      print("error");
      print(e);
    }
  }

  @override
  void onInit() async {
    await getData();
    super.onInit();
  }
}
