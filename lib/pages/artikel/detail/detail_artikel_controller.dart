import 'package:get/get.dart';
import 'package:masjid_app/pages/artikel/artikel_service.dart';
import 'package:masjid_app/routes/artikel/index.dart';

class DetailArtikelController extends GetxController {
  var isLoadingList = true.obs;
  var detail = {}.obs;

  List listArtikels = [].obs;
  List listCategoryFilter = [].obs;
  late List<RxBool> listCategoryFilterSelected;

  getData() async {
    final result = await ArtikelService().getDetailArtikel();
    detail.value = result;
  }

  goToDetail(param) {
    Get.offAllNamed('${RoutesArtikel.root}/${param['id']}');
  }
  getListArtikels() async {
    final result = await ArtikelService().getListArtikellain();
    listArtikels = result;
    isLoadingList.value = false;
  }

  @override
  void onInit() {
    getData();
    getListArtikels();
    super.onInit();
  }
}
