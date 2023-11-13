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
        "title": 'Sedekah yang Paling Utama adalah yang Paling Sesuai dengan Kondisi Penerima Sedekah',
        "date": '17 Agustus 2023',
        "time": '17:40',
        "viewer": "10",
        "category": "Sejarah",
        "image": "https://storage.nu.or.id/storage/post/16_9/big/gambar-whatsapp-2023-08-21-pukul-175147_1692615363.webp"
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
    ];
  }

  @override
  void onInit() {
    getCategoryFilter();
    getListArtikels();
    super.onInit();
  }
}
