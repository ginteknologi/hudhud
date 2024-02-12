import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomBottomBar extends StatelessWidget {
  CustomBottomBar({super.key, this.onChanged, this.selectedIdx = 0});
  Function(BottomBarEnum)? onChanged;

  RxInt selectedIndex = 0.obs;
  int selectedIdx;

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
        icon: 'assets/icons/ruangan_blur.png',
        activeIcon: 'assets/icons/ruangan_blur.png',
        title: "Sahabat Muazin".tr,
        // navType: BottomBarEnum.ruangan
        navType: BottomBarEnum.ruangan),
    BottomMenuModel(
        icon: 'assets/icons/dkm.png',
        activeIcon: 'assets/icons/dkm_a.png',
        title: "Marbot".tr,
        navType: BottomBarEnum.dkm)
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        // margin: const EdgeInsets.only(left: 1),
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          elevation: 10,
          currentIndex: checkStateIndex(),
          type: BottomNavigationBarType.fixed,
          items: List.generate(bottomMenuList.length, (index) {
            return BottomNavigationBarItem(
              icon: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image.asset(bottomMenuList[index].icon,
                      height: 30, width: 30),
                  Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: Text(
                      bottomMenuList[index].title ?? "",
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                      style:
                          const TextStyle(color: Colors.black54, fontSize: 10),
                    ),
                  ),
                ],
              ),
              activeIcon: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(bottomMenuList[index].activeIcon,
                      height: 30, width: 30),
                  Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: Text(bottomMenuList[index].title ?? "",
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 10)),
                  ),
                ],
              ),
              label: '',
            );
          }),
          onTap: (index) {
            selectedIndex.value = index;
            selectedIdx = index;
            onChanged!(bottomMenuList[index].navType);
          },
        ),
      ),
    );
  }

  checkStateIndex() {
    if (selectedIdx != 0) {
      selectedIndex.value = selectedIdx;
    }
    return selectedIndex.value;
  }
}

enum BottomBarEnum { beranda, alquran, ruangan, dkm }

class BottomMenuModel {
  BottomMenuModel(
      {required this.icon,
      this.title,
      required this.activeIcon,
      required this.navType});

  String icon;
  String activeIcon;
  BottomBarEnum navType;
  String? title;
}

///Set default widget when screen is not configured with bottom menu
Widget getDefaultWidget() {
  return Container(
    color: Colors.white,
    padding: const EdgeInsets.all(10),
    child: const Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Dalam Pengembangan',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ],
      ),
    ),
  );
}
