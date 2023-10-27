import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mesjid_app/pages/akun/akun_service.dart';

class EditAkunController extends GetxController {
  var isLoadingList = true.obs;
  var list = {}.obs;
  var txtController = TextEditingController();
  var emailController = TextEditingController();

  getData() async {
    final result = await AkunService().getList(page: 0, limit: 10);
    list.value = result['data'];
    isLoadingList.value = false;
  }

  @override
  void onInit() {
    txtController.text = "Muhammad Fahmi zulmeindar";
    emailController.text = "insanjati@gmail.com";
    super.onInit();
  }
}
