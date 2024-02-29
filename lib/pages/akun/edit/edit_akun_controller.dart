import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:masjid_app/configs/main_controller.dart';
import 'package:masjid_app/models/userData.dart';
import 'package:masjid_app/pages/akun/akun_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:minio_new/minio.dart';

class EditAkunController extends GetxController {
  final gctrl = Get.find<MainController>();
  var isLoadingList = true.obs;
  var list = {}.obs;
  var txtController = TextEditingController();
  var phoneController = TextEditingController();
  ImagePicker picker = ImagePicker();
  RxString inputFoto = "".obs;
  File? newfile;
  var fileName = "".obs;
  var isNewfile = false.obs;

  final minio = Minio(
    endPoint: 'nos.wjv-1.neo.id',
    accessKey: '00de6efb8708931b289e',
    secretKey: '8PG4OCho1aJJaZlYoa0cc+lQlODCF8EMla+rNKR0',
  );

  pilihFile() async {
    final status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    final image = await picker.pickImage(
        source: ImageSource.gallery, imageQuality: 70, maxWidth: 1000);
    if (image == null) return;
    newfile = File(image.path);
    fileName.value = image.name;
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

  String generateRandomString(int len) {
    var r = Random();
    String randomString =
        String.fromCharCodes(List.generate(len, (index) => r.nextInt(33) + 89));
    return randomString;
  }

  Future simpan() async {
    try {
      var photo = null;
      if (newfile != null) {
        var file = File(newfile!.path);
        final bytes = await file.readAsBytes();
        DateTime now = DateTime.now();
        int currentTimeInMillis = now.millisecondsSinceEpoch;
        await minio.putObject(
          'marbot',
          'avatar/$currentTimeInMillis-${fileName.value}',
          Stream<Uint8List>.value(bytes),
          metadata: {'x-amz-acl': 'public-read', 'Content-type': 'image/png'},
          onProgress: (bytes) => print('$bytes uploaded'),
        );
        photo =
            "https://nos.wjv-1.neo.id/marbot/avatar/$currentTimeInMillis-${fileName.value}";
      }
      final result = await AkunService().postProfile(gctrl.userLogin.value.id,
          txtController.text, phoneController.text, photo);
      if (result['code'] == 200) {
        gctrl.userLogin.value = UserData(
            id: result['data']['id'],
            nama: result['data']['nama'],
            email: result['data']['email'],
            photo: result['data']['photo'] ?? 'https://nos.wjv-1.neo.id/marbot/assets/app_icon.png',
            total_sedekah: result['data']['total_sedekah'],
            phone: result['data']['phone']);
        Get.back();
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void onInit() {
    inputFoto.value = gctrl.userLogin.value.photo;
    txtController.text = gctrl.userLogin.value.nama;
    phoneController.text = gctrl.userLogin.value.phone ?? '';
    super.onInit();
  }
}
