import 'package:get/get.dart';
import 'package:masjid_app/models/artikelData.dart';
import 'package:masjid_app/pages/artikel/artikel_service.dart';

class ArtikelController extends GetxController {
  var isLoadingList = true.obs;
  var listArtikels = <ArtikelData>[].obs;

  List listCategoryFilter = [].obs;
  late List<RxBool> listCategoryFilterSelected;

  getData() async {
    try {
      final result = await ArtikelService().getListArtikel();
      for (var element in result['data']) {
        listArtikels.add(ArtikelData(
            id: element['id'],
            judul: element['judul'],
            image: element['image'],
            category_artikel: element['category_artikel'],
            publish_date: element['publish_date'],
            updatedAt: element['updatedAt']));
      }
      isLoadingList.value = false;
    } catch (e) {
      print(e);
    }
  }

  // getCategoryFilter() async {
  //   try {
  //     final result = await ArtikelService().getListTag();
  //     listCategoryFilter = result['data'];
  //     listCategoryFilterSelected =
  //         List.generate(result.length, (index) => false.obs);
  //     listCategoryFilterSelected[0] = true.obs;
  //     return listCategoryFilter;
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  @override
  void onInit() async {
    // await getCategoryFilter();
    await getData();
    super.onInit();
  }
}
