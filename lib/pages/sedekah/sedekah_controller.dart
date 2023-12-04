import 'package:get/get.dart';
import 'package:masjid_app/pages/sedekah/sedekah_service.dart';
import 'package:masjid_app/routes/sedekah/index.dart';

class SedekahController extends GetxController {
  var isLoadingList = true.obs;
  RxList list = [].obs;
  List listSedekah = [].obs;

  getData() async {
    final result = await SedekahService().getList();
    list.value = result['data'];
    print(list);
    isLoadingList.value = false;
  }

  goToDetail(String id) {
    // print(RoutesSedekah.detail, id: id);
    Get.toNamed('${RoutesSedekah.root}/$id');
  }

  @override
  void onInit() async {
    getData();
    super.onInit();
  }
}
