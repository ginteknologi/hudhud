import 'package:get/get.dart';
import 'package:mesjid_app/pages/artikel/artikel_service.dart';

class DetailArtikelController extends GetxController {
  var isLoadingList = true.obs;
  var list = {}.obs;

  List listArtikels = [].obs;
  List listCategoryFilter = [].obs;
  late List<RxBool> listCategoryFilterSelected;

  var selectedArtikel = Get.arguments['selectedArtikel'];

  getData() async {
    final result = await ArtikelService().getList(page: 0, limit: 10);
    list.value = result['data'];
    isLoadingList.value = false;
  }

  getCategoryFilter() async {
    listCategoryFilter = [
      {"id": 1, "label": "Semua", "value": "semua"},
      {"id": 2, "label": "Sejarah", "value": "sejarah"},
      {"id": 3, "label": "Amalan", "value": "amalan"},
      {"id": 3, "label": "Sedekah", "value": "sedekah"},
      {"id": 3, "label": "Wisata Alam", "value": "wisata_alam"},
      {"id": 3, "label": "Ramadhan", "value": "ramadhan"},
    ];
    listCategoryFilterSelected =
        List.generate(listCategoryFilter.length, (index) => false.obs);
    listCategoryFilterSelected[0] = true.obs;
    return listCategoryFilter;
  }

  getListArtikels() async {
    return listArtikels = [
      {
        "id": 1,
        "title": '"Sampaikanlah dariku walau hanya satu ayat."(HR. Bukhari)',
        "date": '17 Agustus 2023',
        "time": '17:40',
        "viewer": "10",
        "category": "Sejarah",
        "image": "assets/img/artikel_1.png"
      },
      {
        "id": 2,
        "title": 'Keutamaan berdzikir',
        "date": '17 Agustus 2023',
        "time": '17:40',
        "viewer": "10",
        "category": "Amalan",
        "image": "assets/img/artikel_2.png"
      },
      {
        "id": 2,
        "title": 'Sholat Terakhir',
        "date": '17 Agustus 2023',
        "time": '17:40',
        "viewer": "10",
        "category": "Sedekah",
        "image": "assets/img/artikel_3.png"
      },
      {
        "id": 1,
        "title": '"Sampaikanlah dariku walau hanya satu ayat."(HR. Bukhari)',
        "date": '17 Agustus 2023',
        "time": '17:40',
        "viewer": "10",
        "category": "Wisata Alam",
        "image": "assets/img/artikel_4.png"
      },
      {
        "id": 2,
        "title": 'Keutamaan berdzikir',
        "date": '17 Agustus 2023',
        "time": '17:40',
        "viewer": "10",
        "category": "Ramadhan",
        "image": "assets/img/artikel_5.png"
      },
      {
        "id": 2,
        "title": 'Sholat Terakhir',
        "date": '17 Agustus 2023',
        "time": '17:40',
        "viewer": "10",
        "category": "Ramadhan",
        "image": "assets/img/artikel_6.png"
      },
      {
        "id": 2,
        "title": 'Sholat Terakhir',
        "date": '17 Agustus 2023',
        "time": '17:40',
        "viewer": "10",
        "category": "Amalan",
        "image": "assets/img/artikel_7.png"
      },
    ];
  }

  @override
  void onInit() {
    getCategoryFilter();
    getListArtikels();
    super.onInit();
  }
}
