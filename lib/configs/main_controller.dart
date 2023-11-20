import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mesjid_app/pages/home/home_service.dart';

class MainController extends GetxController {
  final dataStore = GetStorage();
  var isLogin = false.obs;
  var userLogin = {}.obs;
  var perAyatLastRead = {}.obs;
  var perHalamanLastRead = {}.obs;
  
  loadStorage() async {
    try {
      isLogin.value = dataStore.read('isLogin');
      if (isLogin.isTrue) {
        userLogin.value = dataStore.read('userLogin');
        if (!kIsWeb) {
          // await ProfileService().setToken(dataStore.read('fcmtoken'));
        }
      }
    } catch (e) {
      print(e);
      dataStore.write('isLogin', false);
      isLogin.value = false;
    }
  }
  loadHistoryQuran() async {
    try {
      print(dataStore.read('perAyatLastRead'));
      if (dataStore.read('perAyatLastRead') == null) {
        dataStore.write('perAyatLastRead', {'id': 0,'suratName': '', 'ayatNumber': 0});
      }
      print(dataStore.read('perHalamanLastRead'));
      if (dataStore.read('perHalamanLastRead') == null) {
        dataStore.write('perHalamanLastRead', {'id': 0,'suratName': '', 'page': 0});
      }
    } catch (e) {
      print(e);
    }
  }

  Future logout() async {
    try {
      dataStore.remove('userInfo');
      dataStore.remove('isLogin');
      dataStore.remove('token');
      isLogin.value = false;
      dataStore.write('token', "");
      userLogin.value = dataStore.read('userInfo');
    } catch (e) {
      print('gk ada session');
    }
  }

  setFcm() async {
    if (isLogin.isTrue) {
      final fcm = dataStore.read('fcm_token');
      await HomeService().setToken(fcm);
      print('done fcm saving');
    }
  }

  @override
  void onInit() {
    loadStorage();
    loadHistoryQuran();
    super.onInit();
  }
}
