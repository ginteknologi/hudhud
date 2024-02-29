import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:masjid_app/service/muazin_service.dart';
import 'package:masjid_app/models/kajianData.dart';

class MuazinController extends GetxController {
  DateTime sekarang = DateTime.now();
  DateFormat formatter = DateFormat.yMMMM();

  var isLoading = true.obs;
  var listData = [].obs;
  var listMuadzin = <KajianData>[].obs;

  Future<void> getData() async {
    try {
      isLoading = true.obs;
      final result = await MuazinService.getMuadzin();
      listMuadzin.value = [];
      for (var element in result['data']) {
        listMuadzin.add(KajianData(
            id: element['id'],
            judul: element['judul'],
            subjudul: element['subjudul'],
            image: element['image'],
            link: element['link']));
      }
      isLoading.value = false;
      print(listMuadzin);
      print(isLoading.value);
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
