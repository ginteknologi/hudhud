import 'package:get/get.dart';
import 'package:mesjid_app/pages/dkm/dkm_service.dart';

class DkmController extends GetxController {
  var isLoadingList = true.obs;
  var list = {}.obs;
  List listDkm = [].obs;
  List listMemberDkm = [].obs;
  List listKontak = [].obs;

  getData() async {
    final result = await DkmService().getList(page: 0, limit: 10);
    list.value = result['data'];
    isLoadingList.value = false;
  }

  getListDkm() async {
    listDkm = [
      {"id": 1, "label": "Membangun Ukhuwah", "value": "semua"},
      {"id": 2, "label": "Mengawal Aqidah", "value": "sejarah"},
      {"id": 3, "label": "Menghindari Iftiraq", "value": "amalan"},
      {"id": 3, "label": "Memahami Ikhtilaf", "value": "sedekah"},
    ];
    return listDkm;
  }

  getListMemberDkm() async {
    listMemberDkm = [
      {"id": 1, "nama": "Ust. Arwani Amin, Lc, MA", "role": "Ketua"},
      {"id": 2, "nama": "Ust. Insan Jati, Lc, MA", "role": "Sekretaris"},
      {"id": 3, "nama": "Ust. Herdi Junaedi, Lc, MA", "role": "Bendahara"},
    ];
    return listDkm;
  }

  getListKontak() async {
    listKontak = [
      {
        "id": 1,
        "title": "+62-8575-647-xxxx",
        "category": "Telepon/WhatsApp",
        "icon": "assets/icons/wa.svg"
      },
      {
        "id": 1,
        "title":
            "CitraGran Cibubur, RT005/011, Jatikarya, Jatisampurna, Bekasi, West Java 17435",
        "category": "Alamat",
        "icon": "assets/icons/pinpoint.svg"
      },
      {
        "id": 1,
        "title": "https://linktr.ee/AnNimahTV",
        "category": "LinkTree",
        "icon": "assets/icons/tele.svg"
      },
    ];
    return listKontak;
  }

  @override
  void onInit() {
    getListDkm();
    getListMemberDkm();
    getListKontak();
    super.onInit();
  }
}
