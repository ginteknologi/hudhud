import 'package:get/get.dart';
import 'package:masjid_app/pages/artikel/artikel_service.dart';
import 'package:masjid_app/routes/artikel/index.dart';

class DzikirController extends GetxController {
  var isLoadingList = false.obs;
  var list = [].obs;

  RxBool flagDzikir = false.obs;

  List listArtikels = [].obs;
  List listCategoryFilter = [].obs;
  late List<RxBool> listCategoryFilterSelected;

  @override
  void onInit() async {
    super.onInit();
  }
}
