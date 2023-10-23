import 'package:get/get.dart';
import 'package:mesjid_app/pages/ruangan/ruangan_service.dart';

class JadwalRuanganController extends GetxController {
  var isLoadingList = true.obs;
  var list = {}.obs;
  List listJadwal = [].obs;

  Rx<DateTime> selectedDay = DateTime.now().obs;
  RxString inputBulan = "".obs;

  getData() async {
    final result = await RuanganService().getList(page: 0, limit: 10);
    list.value = result['data'];
    isLoadingList.value = false;
  }

  getListJadwal() async {
    listJadwal = [
      {
        "id": 1,
        "title": "Lorem ipsum dolor sit amet",
        "subtitle": "Ust. Farhan Gaperi M.A ",
        "tanggal": "10",
        "bulan": "September",
        "pukul": "10:00-20:00"
      },
      {
        "id": 1,
        "title": "Lorem ipsum dolor sit amet",
        "subtitle": "Ust. Farhan Gaperi M.A ",
        "tanggal": "10",
        "bulan": "September",
        "pukul": "10:00-20:00"
      },
      {
        "id": 1,
        "title": "Lorem ipsum dolor sit amet",
        "subtitle": "Ust. Farhan Gaperi M.A ",
        "tanggal": "10",
        "bulan": "September",
        "pukul": "10:00-20:00"
      },
      {
        "id": 1,
        "title": "Lorem ipsum dolor sit amet",
        "subtitle": "Ust. Farhan Gaperi M.A ",
        "tanggal": "10",
        "bulan": "September",
        "pukul": "10:00-20:00"
      },
      {
        "id": 1,
        "title": "Lorem ipsum dolor sit amet",
        "subtitle": "Ust. Farhan Gaperi M.A ",
        "tanggal": "10",
        "bulan": "September",
        "pukul": "10:00-20:00"
      },
    ];
    return listJadwal;
  }

  @override
  void onInit() {
    getListJadwal();
    super.onInit();
  }
}
