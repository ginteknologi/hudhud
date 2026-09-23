import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:masjid_app/models/menu_bottom_data.dart';

final homeBottomNavIndexProvider = StateProvider<int>((ref) => 0);

final homeBottomNavTypeProvider = Provider<BottomBarEnum>((ref) {
  final index = ref.watch(homeBottomNavIndexProvider);
  switch (index) {
    case 0:
      return BottomBarEnum.beranda;
    case 1:
      return BottomBarEnum.alquran;
    case 2:
      return BottomBarEnum.muazin;
    case 3:
      return BottomBarEnum.dkm;
    default:
      return BottomBarEnum.beranda;
  }
});

final homeBottomMenuListProvider = Provider<List<BottomMenuModel>>((ref) {
  return [
    BottomMenuModel(
      icon: 'assets/icons/beranda.png',
      activeIcon: 'assets/icons/beranda_a.png',
      title: 'Beranda'.tr(),
      navType: BottomBarEnum.beranda,
    ),
    BottomMenuModel(
      icon: 'assets/icons/al-quran.png',
      activeIcon: 'assets/icons/al-quran_a.png',
      title: "Al-Qur'an".tr(),
      navType: BottomBarEnum.alquran,
    ),
    BottomMenuModel(
      icon: 'assets/icons/sahabat_muadzin.png',
      activeIcon: 'assets/icons/sahabat_muadzin_a.png',
      title: 'Sahabat Muazin'.tr(),
      navType: BottomBarEnum.muazin,
    ),
    BottomMenuModel(
      icon: 'assets/icons/dkm.png',
      activeIcon: 'assets/icons/dkm_a.png',
      title: 'Marbot'.tr(),
      navType: BottomBarEnum.dkm,
    ),
  ];
});
