import 'package:get/get.dart';
import 'package:masjid_app/models/kajianData.dart';
import 'package:masjid_app/models/sosmedData.dart';
import 'package:masjid_app/pages/dkm/dkm_service.dart';
import 'package:masjid_app/service/dashboard_service.dart';

class DkmController extends GetxController {
  var isLoadingList = true.obs;
  var isLoadingSlider = true.obs;
  List listKontak = <SosmedData>[].obs;
  List listQuotes = <KajianData>[].obs;

  getData() async {
    try {
      listKontak.clear();
      listKontak = await DkmService().getList();
      isLoadingList.value = false;
    } catch (e) {
      print(e);
    }
  }

  getSlider() async {
    try {
      final result = await DashboardService().getSliderKajian('quotes');
      for (var element in result['data']) {
        listQuotes.add(KajianData(
            id: element['id'],
            judul: element['judul'],
            subjudul: element['subjudul'],
            image: element['image'],
            link: element['link']));
      }
      isLoadingSlider.value = false;
    } catch (e) {
      print(e);
    }
  }

  @override
  void onInit() {
    getData();
    getSlider();
    super.onInit();
  }
}
