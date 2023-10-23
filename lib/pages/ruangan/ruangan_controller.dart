import 'package:get/get.dart';
import 'package:mesjid_app/pages/ruangan/ruangan_service.dart';

class RuanganController extends GetxController {
  var isLoadingList = true.obs;
  var list = {}.obs;
  List listKegiatan = [].obs;

  Rx<DateTime> selectedDay = DateTime.now().obs;

  getData() async {
    final result = await RuanganService().getList(page: 0, limit: 10);
    list.value = result['data'];
    isLoadingList.value = false;
  }

  getListKegiatan() async {
    listKegiatan = [
      {
        "id": 1,
        "label": "Kajian umum",
        "subtitle": "Lorem ipsum dolor sit amet consectetur. Aliquam nibh "
      },
      {
        "id": 1,
        "label": "Kajian umum",
        "subtitle": "Lorem ipsum dolor sit amet consectetur. Aliquam nibh "
      },
      {
        "id": 1,
        "label": "Kajian umum",
        "subtitle": "Lorem ipsum dolor sit amet consectetur. Aliquam nibh "
      },
      {
        "id": 1,
        "label": "Kajian umum",
        "subtitle": "Lorem ipsum dolor sit amet consectetur. Aliquam nibh "
      },
      {
        "id": 1,
        "label": "Kajian umum",
        "subtitle": "Lorem ipsum dolor sit amet consectetur. Aliquam nibh "
      },
      {
        "id": 1,
        "label": "Kajian umum",
        "subtitle": "Lorem ipsum dolor sit amet consectetur. Aliquam nibh "
      },
      {
        "id": 1,
        "label": "Kajian umum",
        "subtitle": "Lorem ipsum dolor sit amet consectetur. Aliquam nibh "
      },
    ];
    return listKegiatan;
  }

  @override
  void onInit() {
    getListKegiatan();
    super.onInit();
  }
}
