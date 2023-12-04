import 'package:get/get.dart';
import 'package:masjid_app/pages/ruangan/ruangan_service.dart';

class RuanganController extends GetxController {
  var isLoadingList = true.obs;
  var list = [].obs;
  List listKegiatan = [].obs;

  Rx<DateTime> selectedDay = DateTime.now().obs;

  getData() async {
    final result = await RuanganService().getList();
    list.value = result['data'];
    isLoadingList.value = false;
  }

  getListKegiatan() async {
    listKegiatan = [
      {
        "id": 1,
        "label": "Kajian umum",
        "subtitle": "Lorem ipsum dolor sit amet consectetur. Aliquam nibh sds sdd"
      },
      {
        "id": 1,
        "label": "Kajian umum",
        "subtitle": "Lorem ipsum dolor sit amet consectetur. Aliquam nibh sds sdd"
      },
      {
        "id": 1,
        "label": "Kajian umum",
        "subtitle": "Lorem ipsum dolor sit amet consectetur. Aliquam nibh sds sdd"
      },
      {
        "id": 1,
        "label": "Kajian umum",
        "subtitle": "Lorem ipsum dolor sit amet consectetur. Aliquam nibh sds sdd"
      },
      {
        "id": 1,
        "label": "Kajian umum",
        "subtitle": "Lorem ipsum dolor sit amet consectetur. Aliquam nibh sds sdd"
      },
      {
        "id": 1,
        "label": "Kajian umum",
        "subtitle": "Lorem ipsum dolor sit amet consectetur. Aliquam nibh sds sdd"
      },
      {
        "id": 1,
        "label": "Kajian umum",
        "subtitle": "Lorem ipsum dolor sit amet consectetur. Aliquam nibh sds sdd"
      },
    ];
    return listKegiatan;
  }

  @override
  void onInit() {
    getData();
    getListKegiatan();
    super.onInit();
  }
}
