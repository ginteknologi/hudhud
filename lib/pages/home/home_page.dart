import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mesjid_app/components/layout/custom_bottom_bar.dart';
import 'package:mesjid_app/components/layout/custom_modal_bottom_sheet.dart';
import 'package:mesjid_app/components/layout/sliding_widget.dart';
import 'package:mesjid_app/pages/dashboard/dashboard_page.dart';
import 'package:mesjid_app/pages/dkm/dkm_page.dart';
import 'package:mesjid_app/pages/home/home_controller.dart';
import 'package:mesjid_app/pages/quran/quran_page.dart';
import 'package:mesjid_app/pages/ruangan/ruangan_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Widget getCurrentWidget(BottomBarEnum type, HomeController ctrl) {
    switch (type) {
      case BottomBarEnum.beranda:
        return DashboardPage();
      case BottomBarEnum.alquran:
        return QuranPage(typeView: ctrl.typeViewQuran.value);
      case BottomBarEnum.ruangan:
        return RuanganPage();
      case BottomBarEnum.dkm:
        return DkmPage();
      default:
        return getDefaultWidget();
    }
  }

  void showSheet(HomeController ctrl, BuildContext context) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20.0),
          ),
        ),
        builder: (BuildContext bc) {
          return CustomModalBottomSheet(
            typeSheet: TypeBottomSheet.typeCustomSheet,
            content: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Tilawah",
                    style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900, color: Colors.black)),
              ),
              Card(
                elevation: 0,
                color: Theme.of(context).primaryColor,
                margin: const EdgeInsets.only(top: 10),
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                  //set border radius more than 50% of height and width to make circle
                ),
                child: Container(
                    width: Get.width,
                    height: 65,
                    constraints: BoxConstraints.loose(Size.infinite),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Tilawah Perayat",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: context.textTheme.labelLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Belum baca Al-Quran",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: context.textTheme.labelMedium?.copyWith(
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white)),
                          ),
                        ],
                      ),
                    )), //SizedBox
              ),
              SizedBox(
                height: 5,
              ),
              Card(
                elevation: 0,
                color: Theme.of(context).primaryColor,
                margin: const EdgeInsets.only(top: 10),
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                  //set border radius more than 50% of height and width to make circle
                ),
                child: Container(
                    width: Get.width,
                    height: 65,
                    constraints: BoxConstraints.loose(Size.infinite),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Tilawah Perhalaman",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: context.textTheme.labelLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Belum baca Al-Quran",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: context.textTheme.labelMedium?.copyWith(
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white)),
                          ),
                        ],
                      ),
                    )), //SizedBox
              ),
              SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Al-Quran",
                    style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900, color: Colors.black)),
              ),
              SizedBox(
                height: 10,
              ),
              Material(
                  color: Colors.transparent,
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          ctrl.typeViewQuran.value = TypeViewQuran.perayat;
                          ctrl.type.value = BottomBarEnum.alquran;
                        },
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // SvgPicture.asset(
                              //     'assets/icons/quran_listayat.svg',
                              //     height: 30,
                              //     width: 30),
                              Image.asset('assets/icons/icon_perayat.png',
                                  height: 30, width: 30),
                              SizedBox(
                                height: 5,
                              ),
                              Text("Perayat",
                                  style: context.textTheme.labelMedium
                                      ?.copyWith(
                                          fontWeight: FontWeight.w900,
                                          color: Colors.black54))
                            ]),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          ctrl.typeViewQuran.value = TypeViewQuran.perhalaman;
                          ctrl.type.value = BottomBarEnum.alquran;
                        },
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset('assets/icons/quran_halaman.png',
                                  height: 30, width: 30),
                              SizedBox(
                                height: 5,
                              ),
                              Text("Perhalaman",
                                  style: context.textTheme.labelMedium
                                      ?.copyWith(
                                          fontWeight: FontWeight.w900,
                                          color: Colors.black54))
                            ]),
                      )
                    ],
                  ))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(HomeController());

    ctrl.obs.listen((value) {
      print(value);
    });
    // print(ctrl.visible.value);
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        // appBar: layoutAppbar(),
        // body: layout(ctrl, context),
        body: Obx(() => AnimatedContainer(
              child: getCurrentWidget(ctrl.type.value, ctrl),
              duration: Duration(seconds: 4),
            )),
        bottomNavigationBar: Obx(() => ctrl.visible.value
            ? SlidingWidget(
                from: Offset.zero,
                to: Offset(0, 1),
                visible: ctrl.visible.value,
                controller: ctrl.animateController,
                child: CustomBottomBar(
                  selectedIdx: ctrl.selectedIdx.value,
                  onChanged: (BottomBarEnum type) {
                    if (type == BottomBarEnum.alquran) {
                      showSheet(ctrl, context);
                    } else {
                      ctrl.type.value = type;
                    }
                  },
                ))
            : Container(
                height: 0,
              )));
  }
}
