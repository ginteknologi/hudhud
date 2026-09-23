import 'package:get/get.dart';
import 'package:masjid_app/controllers/main_controller.dart';
import 'package:masjid_app/pages/auth/auth_service.dart';
import 'package:masjid_app/routes/home/index.dart';
import 'package:masjid_app/service/google_login.dart';

class AuthController extends GetxController {
  final gctrl = Get.find<MainController>();
  final isBusy = false.obs;
  final errorMsg = ''.obs;

  Future<void> loginGoogle() async {
    isBusy.value = true;
    errorMsg.value = '';

    try {
      final result = await GoogleLogin().googleSignIn();
      if (result['code'] != 200) {
        errorMsg.value = result['message'] ?? 'Login gagal.';
        Get.snackbar("Info", errorMsg.value,
            backgroundColor: Get.theme.colorScheme.error,
            colorText: Get.theme.colorScheme.onError,
            snackPosition: SnackPosition.BOTTOM);
        return;
      }

      final data = result['data'] ?? {};
      final userGoogle = {
        "id": data['id'],
        "name": data['name'],
        "email": data['email'],
        "photo": data['photo'],
        "idToken": data['idToken'], // mungkin null di Web
      };

      final res = await AuthService().getProfile(userGoogle);

      // Check response from AuthService
      if (res['code'] != 200) {
        errorMsg.value = res['message'] ?? 'Gagal memproses data user.';
        Get.snackbar("Error", errorMsg.value,
            backgroundColor: Get.theme.colorScheme.error,
            colorText: Get.theme.colorScheme.onError,
            snackPosition: SnackPosition.BOTTOM);
        return;
      }

      final detail = {
        "id": res['data']['id'],
        "nama": res['data']['nama'],
        "email": res['data']['email'],
        "photo": res['data']['photo'],
        "phone": res['data']['phone'],
        "total_sedekah": res['data']['total_sedekah'],
      };

      gctrl.saveStorage(detail);
      Get.offAllNamed(RoutesHome.root);
    } catch (e) {
      errorMsg.value = 'Terjadi kesalahan: $e';
      Get.snackbar("Error", errorMsg.value,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isBusy.value = false;
    }
  }
}
