import 'package:get/get.dart';
import 'package:masjid_app/controllers/main_controller.dart';
import 'package:masjid_app/pages/auth/auth_service.dart';
import 'package:masjid_app/routes/home/index.dart';
import 'package:masjid_app/configs/main_service.dart';
import 'package:masjid_app/models/userData.dart';

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

  // loginGuest() async {
  //   try {
  //     final userGoogle = {
  //       "name": 'Guest Account',
  //       "email": 'guest@mail.com',
  //       "photo": '',
  //     };
  //     // getProfile(userGoogle);
  //     final json = {
  //       "id": 1,
  //       "name": "guest",
  //       "email": "guest@gmail.com",
  //       "photo": "",
  //       "total_sedekah": 100000,
  //     };
  //     gctrl.saveStorage(json);
  //     Get.offAllNamed(RoutesHome.root);
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  getProfile(userGoogle) async {
    try {
      final result = await AuthService().getProfile(userGoogle);
      final detail = {
        "id": result['data']['id'],
        "nama": result['data']['nama'],
        "email": result['data']['email'],
        "photo": result['data']['photo'],
        "phone": result['data']['phone'],
        "total_sedekah": result['data']['total_sedekah'],
      };
      // final detail = UserData(
      //     id: result['data']['id'],
      //     nama: result['data']['nama'],
      //     email: result['data']['email'],
      //     photo: result['data']['photo'],
      //     total_sedekah: result['data']['total_sedekah']);
      gctrl.saveStorage(detail);
      Get.offAllNamed(RoutesHome.root);
    } catch (e) {
      print('<<<<error getProfile>>>>');
      print(e);
    }
  }

  @override
  void onInit() {
    super.onInit();
  }
}
