import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomBottomBar extends StatelessWidget {
  RxInt selectedIndex = 0.obs;

  List<BottomMenuModel> bottomMenuList = [
    BottomMenuModel(
      icon: 'assets/icons/beranda.png',
      activeIcon: 'assets/icons/beranda_a.png',
      title: "Beranda".tr,
    ),
    BottomMenuModel(
      icon: 'assets/icons/al-quran.png',
      activeIcon: 'assets/icons/al-quran_a.png',
      title: "Al-Qur'an".tr,
    ),
    BottomMenuModel(
      icon: 'assets/icons/ruangan.png',
      activeIcon: 'assets/icons/ruangan_a.png',
      title: "Ruangan".tr,
    ),
    BottomMenuModel(
      icon: 'assets/icons/dkm.png',
      activeIcon: 'assets/icons/dkm_a.png',
      title: "DKM".tr,
    )
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
          currentIndex: selectedIndex.value,
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
                    padding: EdgeInsets.only(top: 0),
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
          },
        ),
      ),
    );
  }
}

class BottomMenuModel {
  BottomMenuModel({required this.icon, this.title, required this.activeIcon});

  String icon;
  String activeIcon;

  String? title;
}

///Set default widget when screen is not configured with bottom menu
Widget getDefaultWidget() {
  return Container(
    color: Colors.white,
    padding: EdgeInsets.all(10),
    child: Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Please replace the respective Widget here',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ],
      ),
    ),
  );
}
