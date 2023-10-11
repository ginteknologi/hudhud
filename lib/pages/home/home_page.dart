import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mesjid_app/components/layout/custom_bottom_bar.dart';
import 'package:mesjid_app/pages/dashboard/dashboard_page.dart';
import 'package:mesjid_app/pages/dkm/dkm_page.dart';
import 'package:mesjid_app/pages/home/home_controller.dart';
import 'package:mesjid_app/pages/quran/quran_page.dart';
import 'package:mesjid_app/pages/ruangan/ruangan_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Widget getCurrentWidget(BottomBarEnum type) {
    switch (type) {
      case BottomBarEnum.beranda:
        return DashboardPage();
      case BottomBarEnum.alquran:
        return QuranPage();
      case BottomBarEnum.ruangan:
        return RuanganPage();
      case BottomBarEnum.dkm:
        return DkmPage();
      default:
        return getDefaultWidget();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(HomeController());

    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        // appBar: layoutAppbar(),
        // body: layout(ctrl, context),
        body: Obx(() => AnimatedContainer(
              child: getCurrentWidget(ctrl.type.value),
              duration: Duration(seconds: 4),
            )),
        bottomNavigationBar: CustomBottomBar(
          onChanged: (BottomBarEnum type) {
            print("ress");
            ctrl.type.value = type;
          },
        ));
  }
}
