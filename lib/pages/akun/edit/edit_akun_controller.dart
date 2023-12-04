import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:masjid_app/configs/main_controller.dart';
import 'package:masjid_app/pages/akun/akun_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class EditAkunController extends GetxController {
  final gctrl = Get.find<MainController>();
  var isLoadingList = true.obs;
  var list = {}.obs;
  var txtController = TextEditingController();
  var phoneController = TextEditingController();
  ImagePicker picker = ImagePicker();
  RxString inputFoto = "".obs;
  File? newfile;
  var isNewfile = false.obs;

  pilihFile() async {
    final status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    final image = await picker.pickImage(
        source: ImageSource.gallery, imageQuality: 70, maxWidth: 1000);
    if (image == null) return;
    newfile = File(image.path);
    isNewfile.value = true;
  }

  batalFile() {
    newfile = null;
    isNewfile.value = false;
  }

  getData() async {
    final result = await AkunService().getList(page: 0, limit: 10);
    list.value = result['data'];
    isLoadingList.value = false;
  }

  @override
  void onInit() {
    txtController.text = gctrl.userLogin['name'] ?? '';
    phoneController.text = gctrl.userLogin['phone'] ?? '';
    super.onInit();
  }
}
