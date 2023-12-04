import 'package:get/get.dart';
import 'package:masjid_app/pages/auth/auth_service.dart';
import 'package:masjid_app/routes/home/index.dart';
import 'package:masjid_app/configs/main_service.dart';
import 'package:masjid_app/configs/main_controller.dart';

class AuthController extends GetxController {
  final gctrl = Get.find<MainController>();
  var isLoadingList = true.obs;
  var list = {}.obs;

  loginGoogle() async {
    try {
    final result = await GoogleLogin().googleSignIn();
    final userGoogle = {
      "id": result['data']['_id'],
      "name": result['data']['name'],
      "email": result['data']['email'],
      "photo": result['data']['photo'],
    };    
    getProfile(userGoogle);
    } catch (e) {
      print(e);      
    }
  }
  loginGuest() async {
    try {
    final userGoogle = {
      "name": 'Guest Account',
      "email": 'guest@mail.com',
      "photo": '',
    };    
    getProfile(userGoogle);
    } catch (e) {
      print(e);      
    }
  }

  getProfile(userGoogle) async {
    try {
    final result = await AuthService().getProfile(userGoogle);
    print(result);
    final json = {
      "id": result['data']['id'],
      "name": result['data']['nama'],
      "email": result['data']['email'],
      "photo": result['data']['photo'],
    };    
    gctrl.saveStorage(json);
    Get.offAllNamed(RoutesHome.root);
    } catch (e) {
      print(e);      
    }
  }

  @override
  void onInit() {
    super.onInit();
  }
}
