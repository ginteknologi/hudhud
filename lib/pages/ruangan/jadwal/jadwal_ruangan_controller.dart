import 'package:get/get.dart';
import 'package:masjid_app/pages/ruangan/ruangan_service.dart';

class JadwalRuanganController extends GetxController {
  var isLoadingList = true.obs;
  var list = [].obs;
  List listJadwal = [].obs;
  List<String> years = [];

  var months = [
    {
      'id': 1,
      'label': 'Januari'
    },
    {
      'id': 2,
      'label': 'Februari'
    },
    {
      'id': 3,
      'label': 'Maret'
    },
    {
      'id': 4,
      'label': 'April'
    },
    {
      'id': 5,
      'label': 'Mei'
    },
    {
      'id': 6,
      'label': 'Juni'
    },
    {
      'id': 7,
      'label': 'Juli'
    },
    {
      'id': 8,
      'label': 'Agustus'
    },
    {
      'id': 9,
      'label': 'September'
    },
    {
      'id': 10,
      'label': 'Oktober'
    },
    {
      'id': 11,
      'label': 'November'
    },
    {
      'id': 12,
      'label': 'Desember'
    }
  ];
  Rx<DateTime> selectedDay = DateTime.now().obs;
  RxString inputTanggal = "".obs;
  RxString inputBulan = "".obs;
  RxString inputTahun = "".obs;

  Future<void> getData() async {
    final result = await RuanganService().getDetail(inputTanggal, inputBulan, inputTahun);
    list.value = result['data'];
    isLoadingList.value = false;
    }

  // getListJadwal() async {
  //   listJadwal = [
  //     {
  //       "id": 1,
  //       "title": "Lorem ipsum dolor sit amet",
  //       "subtitle": "Ust. Farhan Gaperi M.A ",
  //       "tanggal": "10",
  //       "bulan": "September",
  //       "pukul": "10:00-20:00"
  //     },
  //     {
  //       "id": 1,
  //       "title": "Lorem ipsum dolor sit amet",
  //       "subtitle": "Ust. Farhan Gaperi M.A ",
  //       "tanggal": "10",
  //       "bulan": "September",
  //       "pukul": "10:00-20:00"
  //     },
  //     {
  //       "id": 1,
  //       "title": "Lorem ipsum dolor sit amet",
  //       "subtitle": "Ust. Farhan Gaperi M.A ",
  //       "tanggal": "10",
  //       "bulan": "September",
  //       "pukul": "10:00-20:00"
  //     },
  //     {
  //       "id": 1,
  //       "title": "Lorem ipsum dolor sit amet",
  //       "subtitle": "Ust. Farhan Gaperi M.A ",
  //       "tanggal": "10",
  //       "bulan": "September",
  //       "pukul": "10:00-20:00"
  //     },
  //     {
  //       "id": 1,
  //       "title": "Lorem ipsum dolor sit amet",
  //       "subtitle": "Ust. Farhan Gaperi M.A ",
  //       "tanggal": "10",
  //       "bulan": "September",
  //       "pukul": "10:00-20:00"
  //     },
  //   ];
  //   return listJadwal;
  // }
  Future<void> getParams() async {
    int currentYear = DateTime.now().year;
    for (int i = currentYear; i <= currentYear + 10; i++) {
      years.add(i.toString());
    }        
    DateTime parsedDate = DateTime.parse(Get.parameters['tanggal']!);    
    inputTanggal.value = parsedDate.day.toString();
    inputBulan.value = parsedDate.month.toString();
    inputTahun.value = parsedDate.year.toString();   
    getData();
  }
  @override
  void onInit() async {
    getParams();
    super.onInit();
  }
}
