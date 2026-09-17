import 'package:get/get.dart';
import 'package:masjid_app/models/menuBottomData.dart';
// import 'package:masjid_app/routes/auth/index.dart';

class HomeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  Rx<BottomBarEnum> type = BottomBarEnum.beranda.obs;
  List<BottomMenuModel> bottomMenuList = [
    BottomMenuModel(
        icon: 'assets/icons/beranda.png',
        activeIcon: 'assets/icons/beranda_a.png',
        title: "Beranda".tr,
        navType: BottomBarEnum.beranda),
    BottomMenuModel(
        icon: 'assets/icons/al-quran.png',
        activeIcon: 'assets/icons/al-quran_a.png',
        title: "Al-Qur'an".tr,
        navType: BottomBarEnum.alquran),
    BottomMenuModel(
        icon: 'assets/icons/sahabat_muadzin.png',
        activeIcon: 'assets/icons/sahabat_muadzin_a.png',
        title: "Sahabat Muazin".tr,
        // navType: BottomBarEnum.ruangan
        navType: BottomBarEnum.muazin),
    BottomMenuModel(
        icon: 'assets/icons/dkm.png',
        activeIcon: 'assets/icons/dkm_a.png',
        title: "Marbot".tr,
        navType: BottomBarEnum.dkm)
  ];
  var selectedIdx = 0.obs;

}
