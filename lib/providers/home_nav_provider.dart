import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      return BottomBarEnum.account;
    default:
      return BottomBarEnum.beranda;
  }
});

final homeBottomMenuListProvider = Provider<List<BottomMenuModel>>((ref) {
  return [
    BottomMenuModel(
      icon: 'assets/icons/beranda.png',
      activeIcon: 'assets/icons/beranda_a.png',
      title: 'Beranda',
      navType: BottomBarEnum.beranda,
    ),
    BottomMenuModel(
      icon: 'assets/icons/al-quran.png',
      activeIcon: 'assets/icons/al-quran_a.png',
      title: "Al-Qur'an",
      navType: BottomBarEnum.alquran,
    ),
    BottomMenuModel(
      icon: 'assets/icons/dkm.png',
      activeIcon: 'assets/icons/dkm_a.png',
      title: 'Akun',
      navType: BottomBarEnum.account,
    ),
  ];
});
