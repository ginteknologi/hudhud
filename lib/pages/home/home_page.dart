import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:masjid_app/components/layout/custom_bottom_bar.dart';
import 'package:masjid_app/components/layout/custom_modal_bottom_sheet.dart';
import 'package:masjid_app/components/layout/sliding_widget.dart';
import 'package:masjid_app/components/partial/list_ui.dart';
import 'package:masjid_app/controllers/main_controller.dart';
import 'package:masjid_app/pages/dashboard/dashboard_page.dart';
import 'package:masjid_app/pages/dkm/dkm_page.dart';
import 'package:masjid_app/pages/home/home_controller.dart';
import 'package:masjid_app/pages/quran/new_quran/alquran_page.dart';
import 'package:masjid_app/pages/muazin/muazin_page.dart';
import 'package:masjid_app/models/kajianData.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:masjid_app/routes/muazin/index.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Widget getCurrentWidget(BottomBarEnum type, HomeController ctrl) {
    print(type);
    switch (type) {
      case BottomBarEnum.beranda:
        return DashboardPage();
      case BottomBarEnum.alquran:
        // return QuranPage(typeView: ctrl.typeViewQuran.value);
        return AlquranPage();
      case BottomBarEnum.ruangan:
        // return const RuanganPage();
        return getDefaultWidget();
      case BottomBarEnum.muazin:
        return MuazinPage();
      case BottomBarEnum.dkm:
        return const DkmPage();
      default:
        return getDefaultWidget();
    }
  }

  void showSheet(
      HomeController ctrl, MainController gctrl, BuildContext context) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20.0),
          ),
        ),
        isScrollControlled: true,
        useSafeArea: true,
        showDragHandle: true,
        builder: (BuildContext bc) {
          return CustomModalBottomSheet(
            typeSheet: TypeBottomSheet.typeFullscreenSheet,
            content: [
              SizedBox(
                height: 30,
                child: Text(
                  "Sahabat Muadzin".tr,
                  style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
              Obx(() {
                if (ctrl.isLoadingMuadzin.isTrue) {
                  return Container(
                      height: Get.height / 1.2,
                      child: Center(child: CircularProgressIndicator()));
                }
                return SizedBox(
                    height: MediaQuery.of(context).size.height -
                        kBottomNavigationBarHeight -
                        kToolbarHeight -
                        23,
                    child: ListView.builder(
                      physics: const ClampingScrollPhysics(),
                      itemCount: ctrl.listMuadzin.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final KajianData item = ctrl.listMuadzin[index];
                        return ListItemUiWidget(
                          onTap: () async {
                            final Uri url = Uri.parse(item.link);
                            if (!await launchUrl(url)) {
                              print('Tidak dapat membuka link YouTube.');
                            }
                            // print('Tidak dapat membuka link YouTube.');
                          },
                          minHeight: 70,
                          vjustify: false,
                          widthContent: MediaQuery.of(context).size.width - 130,
                          id: 1,
                          title: item.judul,
                          showIcon: IconPosition.left,
                          iconLeft: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(7),
                                child: Image.network(
                                  item.image,
                                  width: 65,
                                  height: 65,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              // Positioned(
                              //     top: 2,
                              //     right: 2,
                              //     child: Container(
                              //       padding: const EdgeInsets.all(3),
                              //       constraints:
                              //           BoxConstraints.loose(Size.infinite),
                              //       decoration: const BoxDecoration(
                              //           color: Colors.red,
                              //           borderRadius: BorderRadius.all(
                              //               Radius.circular(20))),
                              //       child: Row(
                              //         mainAxisSize: MainAxisSize.min,
                              //         crossAxisAlignment:
                              //             CrossAxisAlignment.center,
                              //         mainAxisAlignment:
                              //             MainAxisAlignment.center,
                              //         children: [
                              //           Container(
                              //               margin:
                              //                   const EdgeInsets.only(right: 5),
                              //               child: SvgPicture.asset(
                              //                   'assets/icons/live.svg',
                              //                   height: 6,
                              //                   width: 6)),
                              //           const Text('Live',
                              //               overflow: TextOverflow.ellipsis,
                              //               textAlign: TextAlign.start,
                              //               style: TextStyle(
                              //                   color: Colors.white,
                              //                   fontWeight: FontWeight.bold,
                              //                   fontStyle: FontStyle.italic,
                              //                   fontSize: 5)),
                              //         ],
                              //       ),
                              //     ))
                            ],
                          ),
                          titleStyle: context.textTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.bold, color: Colors.black),
                          subTitle: '',
                          subtitleStyle: context.textTheme.labelMedium
                              ?.copyWith(
                                  fontWeight: FontWeight.w100,
                                  color: Colors.black),
                          footerText: item.subjudul,
                          footerTextStyle: context.textTheme.labelSmall
                              ?.copyWith(
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.w100,
                                  color: Colors.black),
                        );
                      },
                    ));
              })
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(HomeController());
    final gctrl = Get.find<MainController>();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      body: Obx(() => AnimatedContainer(
            duration: const Duration(seconds: 4),
            child: getCurrentWidget(ctrl.type.value, ctrl),
          )),
      bottomNavigationBar: Obx(() => ctrl.visible.value
          ? SlidingWidget(
              from: Offset.zero,
              to: const Offset(0, 1),
              visible: ctrl.visible.value,
              controller: ctrl.animateController,
              child: CustomBottomBar(
                selectedIdx: ctrl.selectedIdx.value,
                onChanged: (BottomBarEnum type) {
                  // if (type == BottomBarEnum.muazin) {
                  // showSheet(ctrl, gctrl, context);
                  // Get.toNamed(RoutesMuadzin.root);
                  // } else {
                  ctrl.type.value = type;
                  // }
                },
              ))
          : Container(
              height: 0,
            )),
    );
  }
}
