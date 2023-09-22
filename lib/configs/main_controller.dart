import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
// import 'package:mesjid_app/pages/akun/profile/profile_service.dart';

class MainController extends GetxController {
  final authStore = GetStorage();
  var isLogin = false.obs;
  var userLogin = {}.obs;

  loadStorage() async {
    try {
      isLogin.value = authStore.read('isLogin');
      if (isLogin.isTrue) {
        userLogin.value = authStore.read('userLogin');
        if (!kIsWeb) {
          // await ProfileService().setToken(authStore.read('fcmtoken'));
        }
      }
    } catch (e) {
      print(e);
      authStore.write('isLogin', false);
      isLogin.value = false;
    }
  }


  @override
  void onInit() {
    loadStorage();
    super.onInit();
  }
}
