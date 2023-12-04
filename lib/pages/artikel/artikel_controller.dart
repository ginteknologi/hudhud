import 'package:get/get.dart';
import 'package:masjid_app/pages/artikel/artikel_service.dart';
import 'package:masjid_app/routes/artikel/index.dart';

class ArtikelController extends GetxController {
  var isLoadingList = true.obs;
  var list = [].obs;

  List listArtikels = [].obs;
  List listCategoryFilter = [].obs;
  late List<RxBool> listCategoryFilterSelected;

  getData() async {
    final result = await ArtikelService().getListArtikel();
    listArtikels = result;
    isLoadingList.value = false;
  }

  goToDetail(param) {
    Get.toNamed('${RoutesArtikel.root}/${param['id']}');
  }

  getCategoryFilter() async {
    final result = await ArtikelService().getListTag();
    listCategoryFilter = result;
    listCategoryFilterSelected =
        List.generate(result.length, (index) => false.obs);
    listCategoryFilterSelected[0] = true.obs;
    return listCategoryFilter;
  }


  @override
  void onInit() async {
    await getCategoryFilter();
    await getData();
    super.onInit();
  }
}
