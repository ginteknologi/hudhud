import 'package:get/get.dart';
import 'package:masjid_app/models/kajianData.dart';
import 'package:masjid_app/models/sosmedData.dart';
import 'package:masjid_app/pages/dkm/dkm_service.dart';
import 'package:masjid_app/service/dashboard_service.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DkmController extends GetxController {
  late PackageInfo packageInfo;
  var isLoadingList = true.obs;
  var isLoadingSlider = true.obs;
  RxList<SosmedData> listKontak = <SosmedData>[].obs;
  RxList<KajianData> listQuotes = <KajianData>[
    KajianData(
        id: 1,
        judul: 'judul',
        subjudul: 'subjudul',
        image: 'https://dummyimage.com/600x400/000/fff',
        link: 'link'),
    KajianData(
        id: 1,
        judul: 'judul',
        subjudul: 'subjudul',
        image: 'https://dummyimage.com/600x400/000/fff',
        link: 'link'),
    KajianData(
        id: 1,
        judul: 'judul',
        subjudul: 'subjudul',
        image: 'https://dummyimage.com/600x400/000/fff',
        link: 'link'),
  ].obs;
  var version = "0.0.0".obs;
  getData() async {
    try {
      final data = await DkmService().getList();
      listKontak.value = data;
      isLoadingList.value = false;
    } catch (e) {
      isLoadingList.value = false;
      print(e);
    }
  }

  getSlider() async {
    try {
      final result = await DashboardService().getSliderKajian('quotes');
      listQuotes.value = [];
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

  getVersion() async {
    packageInfo = await PackageInfo.fromPlatform();
    version.value = packageInfo.version;
  }

  @override
  void onInit() {
    getData();
    getSlider();
    getVersion();
    super.onInit();
  }
}
