import 'package:get/get.dart';
import 'package:masjid_app/pages/doa/doa_service.dart';

class DoaController extends GetxController {
  var isLoadingList = true.obs;
  var list = [].obs;

  List listTypesDoa = [].obs;

  getData() async {
    final result = await DoaService().getList();
    list.value = result['data'];
    isLoadingList.value = false;
  }

  getListTypesDoa() async {
    return listTypesDoa = [
      {
        "id": 1,
        "title": "Do'a - Do'a Harian",
        // "subtitle": "1 Do'a",
        "icon": "assets/icons/calendar.svg"
      },
      // {
      //   "id": 2,
      //   "title": "Sholat",
      //   "subtitle": "25 Do'a",
      //   "icon": "assets/icons/prayer.svg"
      // },
      // {
      //   "id": 3,
      //   "title": "Kemudahan Rezeki",
      //   "subtitle": "35 Do'a",
      //   "icon": "assets/icons/plant.svg"
      // },
    ];
  }

  @override
  void onInit() {
    getListTypesDoa();
    getData();
    super.onInit();
  }
}
