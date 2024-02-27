import 'package:get/get.dart';
import 'package:masjid_app/pages/doa/doa_service.dart';
import 'package:masjid_app/models/kategoriDoaData.dart';

class DoaController extends GetxController {
  var isLoadingList = true.obs;
  var list = <KategoriDoaData>[].obs;

  getData() async {
    try {
      final result = await DoaService().getList();
      for (var element in result['data']) {
        list.add(KategoriDoaData(
            id: element['id'],
            name: element['name'],
            updatedAt: element['updatedAt']));
      }
      isLoadingList.value = false;
      print(list);
    } catch (e) {
      print(e);
    }
  }

  @override
  void onInit() {
    getData();
    super.onInit();
  }
}
