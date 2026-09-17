import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:masjid_app/models/menuBottomData.dart';
import 'package:masjid_app/pages/dashboard/dashboard_page.dart';
import 'package:masjid_app/pages/dkm/dkm_page.dart';
import 'package:masjid_app/controllers/home_controller.dart';
import 'package:masjid_app/pages/quran/new_quran/alquran_page.dart';
import 'package:masjid_app/pages/muazin/muazin_page.dart';

class HomePage extends StatelessWidget {
  final HomeController ctrl = Get.find();
  HomePage({super.key});

  Widget getCurrentWidget(BottomBarEnum type, HomeController ctrl) {
    switch (type) {
      case BottomBarEnum.beranda:
        return DashboardPage();
      case BottomBarEnum.alquran:
        return AlquranPage();
      case BottomBarEnum.muazin:
        return MuazinPage();
      case BottomBarEnum.dkm:
        return DkmPage();
      default:
        return DashboardPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        body: Obx(() {
          return getCurrentWidget(ctrl.type.value, ctrl);
        }),
        bottomNavigationBar: Container(
          color: Colors.white,
          child: Obx(() {
            return BottomNavigationBar(
              backgroundColor: Colors.white,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              elevation: 10,
              currentIndex: ctrl.selectedIdx.value,
              type: BottomNavigationBarType.fixed,
              items: List.generate(ctrl.bottomMenuList.length, (index) {
                return BottomNavigationBarItem(
                  icon: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Image.asset(ctrl.bottomMenuList[index].icon,
                          height: Get.width * 0.069, width: Get.width * 0.069),
                      Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child: Text(
                          ctrl.bottomMenuList[index].title ?? "",
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                              color: Colors.black54, fontSize: 10),
                        ),
                      ),
                    ],
                  ),
                  activeIcon: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(ctrl.bottomMenuList[index].activeIcon,
                          height: Get.width * 0.069, width: Get.width * 0.069),
                      Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child: Text(ctrl.bottomMenuList[index].title ?? "",
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
                ctrl.type.value = ctrl.bottomMenuList[index].navType;
                ctrl.selectedIdx.value = index;
              },
            );
          }),
        ));
  }
}
