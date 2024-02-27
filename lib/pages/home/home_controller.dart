import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masjid_app/components/layout/custom_bottom_bar.dart';
import 'package:masjid_app/configs/main_controller.dart';
import 'package:masjid_app/pages/home/home_service.dart';
import 'package:masjid_app/pages/quran/quran_page.dart';
// import 'package:masjid_app/pages/home/home_service.dart';
import 'package:get_storage/get_storage.dart';
import 'package:masjid_app/routes/auth/index.dart';
import 'package:masjid_app/models/kajianData.dart';

class HomeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final gctrl = Get.find<MainController>();
  final dataStore = GetStorage();
  var isLoadingList = true.obs;
  RxInt idxLastReadHalaman = 0.obs;
  var list = {}.obs;
  Rx<BottomBarEnum> type = BottomBarEnum.beranda.obs;
  Rx<TypeViewQuran> typeViewQuran = TypeViewQuran.perayat.obs;

  var visible = true.obs;
  late AnimationController animateController;
  var selectedIdx = 0.obs;
  var listMuadzin = [].obs;
  var isLoadingMuadzin = true.obs;

  getMuadzin() async {
    try {
      final result = await HomeService().getMuadzin();
      listMuadzin.value = [];
      for (var element in result['data']) {
        listMuadzin.add(KajianData(
            id: element['id'],
            judul: element['judul'],
            subjudul: element['subjudul'],
            image: element['image'],
            link: element['link']));
      }
      isLoadingMuadzin.value = false;
    } catch (e) {
      print(e);
    }
  }

  @override
  void onInit() async {
    getMuadzin();
    if (!gctrl.isLogin.value) {
      Get.offAllNamed(RoutesAuth.root);
    }
    animateController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
    super.onInit();
  }
}
