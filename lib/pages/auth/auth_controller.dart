import 'package:get/get.dart';
import 'package:mesjid_app/pages/auth/auth_service.dart';
import 'package:mesjid_app/routes/home/index.dart';

class AuthController extends GetxController {
  var isLoadingList = true.obs;
  var list = {}.obs;

  getData() async {
    final result = await AuthService().getList(page: 0, limit: 10);
    list.value = result['data'];
    isLoadingList.value = false;
  }

  goToHome() async {
    Get.offAllNamed(RoutesHome.root);
  }

  @override
  void onInit() {
    super.onInit();
  }
}
