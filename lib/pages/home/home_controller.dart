import 'package:get/get.dart';
import 'package:mesjid_app/components/layout/custom_bottom_bar.dart';
import 'package:mesjid_app/pages/quran/quran_page.dart';
// import 'package:mesjid_app/pages/home/home_service.dart';

class HomeController extends GetxController {
  var isLoadingList = true.obs;
  var list = {}.obs;
  Rx<BottomBarEnum> type = BottomBarEnum.beranda.obs;
  Rx<TypeViewQuran> typeViewQuran = TypeViewQuran.perayat.obs;

  getData() async {
    // final result = await HomeService().getList(page: 0, limit: 10);
    //dummy
    list.value = {
      "success": true,
      "message": "Berhasil",
      "data": {
        "page": 1,
        "limit": 8,
        "total": 1,
        "data": [
          {
            "id": 1,
            "point": 1,
            "pic": 7,
            "user_id": 4,
            "tag": "Bug",
            "priority": "Urgent",
            "judul": "asdasdasd",
            "keterangan": null,
            "status": "pending",
            "createdAt": "2023-09-22T15:58:20.020Z",
            "updatedAt": "2023-09-22T15:58:14.000Z"
          }
        ]
      }
    };
    // list.value = result['data'];
    isLoadingList.value = false;
  }

  @override
  void onInit() {
    super.onInit();
  }
}
