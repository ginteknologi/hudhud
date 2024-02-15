import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:masjid_app/components/button/elevatedbutton.dart';
import 'package:masjid_app/pages/quran/new_quran/alquran_service.dart';
import 'package:get_storage/get_storage.dart';
import 'package:masjid_app/configs/main_controller.dart';
import 'package:masjid_app/routes/quran/index.dart';

class AlquranPengaturanController extends GetxController {
  final dataStore = GetStorage();
  final gctrl = Get.find<MainController>();
  var isLoadingList = true.obs;

  @override
  void onInit() async {
    super.onInit();
  }
}
