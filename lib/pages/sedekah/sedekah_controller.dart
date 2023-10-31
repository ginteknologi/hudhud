import 'package:get/get.dart';
import 'package:mesjid_app/pages/sedekah/sedekah_service.dart';
import 'package:mesjid_app/routes/sedekah/index.dart';

class SedekahController extends GetxController {
  var isLoadingList = true.obs;
  RxList list = [].obs;
  List listSedekah = [].obs;

  getData() async {
    final result = await SedekahService().getList(page: 0, limit: 10);
    list.value = result['data'];
    print(list);
    isLoadingList.value = false;
  }

  goToDetail(String id) {
    // print(RoutesSedekah.detail, id: id);
    Get.toNamed('${RoutesSedekah.root}/$id');
  }

  getKajianLive() async {
    return listSedekah = [
      {
        "id": 2,
        "title": "Sedekah Mudharabah",
        "target": 2400000,
        "total": 1400000,
        "image": "assets/icons/image-item1.png",
        "dueDay": 20,
        "url": ""
      },
      {
        "id": 3,
        "title":
            "Sedekah baik baik ajah dan selalu baik baik terus dong ya kali nggak",
        "target": 2300000,
        "total": 1500000,
        "image": "assets/icons/image-item1.png",
        "dueDay": 10,
        "url": ""
      },
      {
        "id": 4,
        "title": "Sedekah Mudharabah",
        "target": 2200000,
        "total": 1600000,
        "image": "assets/icons/image-item1.png",
        "dueDay": 90,
        "url": ""
      },
      {
        "id": 5,
        "title": "Sedekah baik baik ajah dan selalu baik",
        "target": 2100000,
        "total": 1700000,
        "image": "assets/icons/image-item1.png",
        "dueDay": 90,
        "url": ""
      },
    ];
  }

  @override
  void onInit() {
    getData();
    getKajianLive();
    super.onInit();
  }
}
