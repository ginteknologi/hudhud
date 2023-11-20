import 'package:get/get.dart';
import 'package:mesjid_app/pages/doa/doa_service.dart';
import 'package:mesjid_app/routes/doa/index.dart';

class DoaController extends GetxController {
  var isLoadingList = true.obs;
  var list = {}.obs;

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
        "subtitle": "1 Do'a",
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

  goToDetail(param) {
    Get.toNamed('${RoutesDoa.root}/${param['id']}',
        arguments: {"selectedDoa": param});
  }

  @override
  void onInit() {
    getListTypesDoa();
    super.onInit();
  }
}
