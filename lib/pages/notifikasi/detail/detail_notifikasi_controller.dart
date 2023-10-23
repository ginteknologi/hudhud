import 'package:get/get.dart';
import 'package:mesjid_app/pages/doa/doa_service.dart';
import 'package:mesjid_app/pages/notifikasi/notifikasi_service.dart';
import 'package:mesjid_app/routes/notifikasi/index.dart';

class DetailNotifikasiController extends GetxController {
  var isLoadingList = true.obs;
  var list = {}.obs;
  List listNotif = [].obs;

  getData() async {
    final result = await NotifikasiService().getList(page: 0, limit: 10);
    list.value = result['data'];
    isLoadingList.value = false;
  }

  getListNotif() async {
    return listNotif = [
      {
        "id": 1,
        "title": 100000,
        "category": "INV-00123812",
        "type": "success",
        "date": "10/10/2020",
        "time": "10.10"
      },
      {
        "id": 2,
        "title": 100000,
        "category": "INV-00123812",
        "type": "pending",
        "date": "10/10/2020",
        "time": "10.10"
      },
      {
        "id": 3,
        "title": 100000,
        "category": "INV-00123812",
        "type": "cancel",
        "date": "10/10/2020",
        "time": "10.10"
      },
    ];
  }

  goToDetail(param) {
    // print(RoutesSedekah.detail, id: id);
    Get.toNamed('${RoutesNotifikasi.root}/detail/${param['id']}',
        arguments: {"selectedNotif": param});
  }

  @override
  void onInit() {
    getListNotif();
    super.onInit();
  }
}
