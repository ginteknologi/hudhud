import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:masjid_app/components/button/elevatedbutton.dart';
import 'package:masjid_app/components/button/iconbutton.dart';
import 'package:masjid_app/components/layout/custom_card_item.dart';
import 'package:masjid_app/components/partial/list_ui.dart';
import 'package:masjid_app/models/artikelData.dart';
import 'package:masjid_app/models/kajianData.dart';
import 'package:masjid_app/pages/dashboard/component/countDown.dart';
import 'package:masjid_app/pages/dashboard/component/ramadhanMenu.dart';
import 'package:masjid_app/pages/dashboard/component/sedangLive.dart';
import 'package:masjid_app/pages/dashboard/component/waktusolat.dart';
import 'package:masjid_app/controllers/dashboard_controller.dart';
import 'package:masjid_app/routes/akun/index.dart';
import 'package:masjid_app/routes/notifikasi/index.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart' as refresh;
import 'package:skeletonizer/skeletonizer.dart';
import 'package:masjid_app/controllers/main_controller.dart';
import 'package:simple_moment/simple_moment.dart';
import 'package:masjid_app/routes/kajian/index.dart';

class DashboardPage extends StatelessWidget {
  final DashboardController ctrl = Get.find();
  final MainController gctrl = Get.find<MainController>();
  DashboardPage({super.key});

  Obx layout(BuildContext context) {
    return Obx(() {
      return Container(
          padding: EdgeInsets.only(top: Get.height / 20),
          height: Get.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF189A8C), Colors.white, Colors.white]),
          ),
          child: refresh.SmartRefresher(
            enablePullDown: true,
            controller: ctrl.refreshController,
            onLoading: () async {
              await ctrl.getDataSedangLive();
              await ctrl.getSliderKajianLive();
              await ctrl.getSliderKajianTafsir();
              await ctrl.getDataArtikel();
              await ctrl.getMenuHome();
              await ctrl.getSliderDoaDashboard();
              ctrl.refreshController.loadComplete();
            },
            onRefresh: () async {
              ctrl.refreshController.refreshCompleted();
            },
            child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: Get.width / 30),
                      child: header(context),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: Get.width / 30),
                      child: WaktuSolat(),
                    ),
                    Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: Get.width / 30),
                        child: getGridMenu(ctrl)),
                    SizedBox(
                      height: Get.width / 40,
                    ),
                    SedangLiveWidget(),
                    SizedBox(
                      height: Get.width / 30,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: Get.width / 30),
                      child: CountDown_Widget(),
                    ),
                    SizedBox(
                      height: Get.width / 30,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: Get.width / 30),
                      child: RamadhanMenuWidget(),
                    ),
                    SizedBox(
                      height: Get.width / 30,
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: EdgeInsets.symmetric(horizontal: Get.width / 30),
                      child: getSeparator(
                          'Sahabat Masjid', 'Lihat Semua', context, ctrl),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: Get.width / 30),
                      child: Skeletonizer(
                        ignoreContainers: false,
                        enabled: ctrl.isLoadingDoaDashboard.value,
                        child: getListItem(ctrl),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: EdgeInsets.symmetric(horizontal: Get.width / 30),
                      child: getSeparator(
                          'Riwayat Kajian Live', 'Lihat Semua', context, ctrl),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: Get.width / 30),
                      child: Skeletonizer(
                        ignoreContainers: false,
                        enabled: ctrl.isLoadingKajianLive.value,
                        child: getListItemKajianLive(ctrl),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: Get.width / 30),
                      margin: const EdgeInsets.only(top: 10),
                      child: getSeparator(
                          'Kajian Tafsir Quran', 'Lihat Semua', context, ctrl),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: Get.width / 30),
                      child: Skeletonizer(
                        ignoreContainers: false,
                        enabled: ctrl.isLoadingKajianTafsir.value,
                        child: getListItemKajian(ctrl),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: Get.width / 30),
                      child: getSeparator('Terbaru', '', context, ctrl),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: Get.width / 30),
                      child: Skeletonizer(
                        ignoreContainers: false,
                        enabled: ctrl.isLoadingArtikel.value,
                        child: news(context, ctrl),
                      ),
                    ),
                    SizedBox(
                      height: Get.height / 30,
                    )
                  ],
                )),
          ));
    });
  }

  Row header(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
            flex: 1,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: Text("Assalamualaikum".tr,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.white)),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: AutoSizeText(gctrl.userLogin.value.nama.toString(),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                        maxLines: 1,
                        style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w900)),
                  ),
                ),
                Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () async {
                        showPopup(context, dialogTerkini(context), 200);
                      },
                      borderRadius: BorderRadius.circular(20),
                      splashColor: Colors.green.withValues(alpha: 0.5),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Row(
                            children: [
                              Icon(
                                Icons.location_pin,
                                size: 12,
                                color: Color(0xFFFFECB7),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(left: 5),
                                  child: Text(
                                      gctrl.mylokasi.value.keteranganLokasi,
                                      style: TextStyle(
                                          color: Color(0xFFFFECB7),
                                          fontSize: 12)))
                            ],
                          ),
                        ),
                      ),
                    ))
              ],
            )),
        Row(
          children: [
            ButtonIcon(
              onTap: () {
                Get.toNamed(RoutesNotifikasi.root);
              },
              bgcolor: Colors.transparent,
              icon: const Icon(
                Icons.notifications,
                size: 35,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 10),
            Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Get.toNamed(RoutesAkun.root);
                  },
                  borderRadius: BorderRadius.circular(20),
                  splashColor: Colors.green.withValues(alpha: 0.5),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.network(
                        gctrl.userLogin.value.photo,
                        height: 35,
                        width: 35,
                      )
                      // Image.network(
                      //   "https://picsum.photos/50",
                      //   height: 35,
                      //   width: 35,
                      // ),
                      ),
                )),
          ],
        )
      ],
    );
  }

  ListView news(BuildContext context, DashboardController ctrl) {
    return ListView.builder(
        primary: false,
        itemCount: ctrl.listArtikel.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final ArtikelData item = ctrl.listArtikel[index];
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomCardItem(
                network: true,
                isFullWidth: true,
                height: Get.height / 5,
                size: "medium",
                positionChip: CrossAxisAlignment.start,
                chipColor: Theme.of(context).primaryColor,
                chipText: item.category_artikel?['name'],
                chipTextStyle: TextStyle(
                    fontSize: Theme.of(context).textTheme.labelLarge?.fontSize,
                    fontWeight: FontWeight.normal,
                    color: Colors.white),
                title: item.judul,
                subtitle: () {
                  try {
                    return Moment.parse(item.publish_date)
                        .format("dd MMMM yyyy", localeOverride: 'id');
                  } catch (e) {
                    return item.publish_date;
                  }
                }(),
                imgPath: item.image,
                linkRoute: '/artikel/${item.id}',
              ),
              SizedBox(
                height: Get.height / 40,
              )
            ],
          );
        });
  }

  Padding getGridMenu(DashboardController ctrl) {
    return Padding(
      padding: const EdgeInsets.only(left: 0, right: 0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: ctrl.listMenuHome.length,
        padding: EdgeInsets.only(top: 15),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5, childAspectRatio: 0.82),
        itemBuilder: (context, index) {
          return Material(
              color: Colors.transparent,
              child: InkWell(
                  onTap: ctrl.listMenuHome[index]['onTap']! as void Function(),
                  borderRadius: BorderRadius.circular(20),
                  splashColor: Colors.green.withValues(alpha: 0.5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SvgPicture.asset(ctrl.listMenuHome[index]['icon'],
                          height: Get.width / 7.2, width: Get.width / 7.2),
                      SizedBox(height: 5),
                      Expanded(
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: Get.width / 50),
                          child: AutoSizeText(
                            '${ctrl.listMenuHome[index]["label"]}',
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            presetFontSizes: [Get.width / 38],
                            style: TextStyle(
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.fontSize,
                                height: 1.1,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ],
                  )));
        },
      ),
    );
  }

  Material getSeparator(String nama, final String? sub, BuildContext context,
      DashboardController ctrl) {
    return Material(
      color: Colors.transparent,
      child: Row(
        children: [
          Expanded(
            child: Text(nama,
                textAlign: sub == null ? TextAlign.center : TextAlign.left,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    fontSize:
                        Theme.of(context).textTheme.titleMedium?.fontSize)),
          ),
          Visibility(
              visible: sub != null,
              child: InkWell(
                highlightColor: Colors.transparent,
                borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                onTap: () async {
                  if (nama == 'Sahabat Masjid') {
                    Get.toNamed(RoutesKajian.root, arguments: {
                      'judul': 'Sahabat masjid',
                      'type': 'doa_ramadhan'
                    });
                  } else if (nama == 'Riwayat Kajian Live') {
                    Get.toNamed(RoutesKajian.root, arguments: {
                      'judul': 'Riwayat Kajian Live',
                      'type': 'live'
                    });
                  } else {
                    Get.toNamed(RoutesKajian.root, arguments: {
                      'judul': 'Kajian Tafsir Al-Quran',
                      'type': 'tafsir'
                    });
                  }
                  // showSheet(ctrl, nama, context, true);
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Row(
                    children: [
                      Text(
                        sub ?? '',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.fontSize),
                      ),
                    ],
                  ),
                ),
              ))
        ],
      ),
    );
  }

  SizedBox getListItem(DashboardController ctrl) {
    if (kDebugMode) {
      debugPrint("ctrl.isLoadingKajianTafsir ${ctrl.isLoadingKajianTafsir}");
      debugPrint("ctrl.isLoadingKajianTafsir ${ctrl.listDoaSlider.length}");
    }
    return SizedBox(
      height: 151,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: ctrl.listDoaSlider.length,
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final KajianData item = ctrl.listDoaSlider[index];
          return CustomCardItem(
            title: item.judul ?? '',
            subtitle: '',
            imgPath: item.image,
            islink: true,
            link: item.link,
            network: true,
          );
        },
      ),
    );
  }

  Obx getListItemKajianLive(DashboardController ctrl) {
    return Obx(() {
      return SizedBox(
        height: 151,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemCount: ctrl.listKajianLiveSlider.length,
          separatorBuilder: (context, index) => const SizedBox(width: 10),
          itemBuilder: (context, index) {
            final KajianData item = ctrl.listKajianLiveSlider[index];
            return CustomCardItem(
              title: '${item.judul}',
              subtitle: '${item.subjudul}',
              kategori: '${item.kategori}',
              imgPath: item.image,
              islink: true,
              link: item.link,
              network: true,
            );
          },
        ),
      );
    });
  }

  Obx getListItemKajian(DashboardController ctrl) {
    if (kDebugMode) {
      debugPrint("ctrl.isLoadingKajianTafsir ${ctrl.isLoadingKajianTafsir}");
      debugPrint(
          "ctrl.listKajianSlider.length ${ctrl.listKajianSlider.length}");
    }
    return Obx(() {
      return SizedBox(
        height: 151,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemCount: ctrl.listKajianSlider.length,
          separatorBuilder: (context, index) => const SizedBox(width: 10),
          itemBuilder: (context, index) {
            final KajianData item = ctrl.listKajianSlider[index];
            return CustomCardItem(
              title: '${item.judul}',
              subtitle: '${item.subjudul}',
              kategori: '${item.kategori}',
              imgPath: item.image,
              islink: true,
              link: item.link,
              network: true,
            );
          },
        ),
      );
    });
  }

  // void showSheet(
  //     DashboardController ctrl, nama, BuildContext context, bool flag) {
  //   showModalBottomSheet(
  //       context: context,
  //       isScrollControlled: flag,
  //       useSafeArea: flag,
  //       showDragHandle: false,
  //       shape: const RoundedRectangleBorder(
  //         borderRadius: BorderRadius.vertical(
  //           top: Radius.circular(20.0),
  //         ),
  //       ),
  //       builder: (BuildContext bc) {
  //         return !flag
  //             ? CustomModalBottomSheet(
  //                 typeSheet: TypeBottomSheet.typeGridSheet,
  //                 dataGrid: ctrl.listAllMenu,
  //               )
  //             : CustomModalBottomSheet(
  //                 typeSheet: TypeBottomSheet.typeFullscreenSheet,
  //                 content: [
  //                   SizedBox(
  //                     height: 30,
  //                     child: Text(
  //                       nama,
  //                       style: context.textTheme.titleMedium?.copyWith(
  //                           fontWeight: FontWeight.bold, color: Colors.black),
  //                     ),
  //                   ),
  //                   Obx(() {
  //                     if (ctrl.isLoadingKajianTafsir.isTrue) {
  //                       return Container(
  //                           height: Get.height / 1.2,
  //                           child: Center(child: CircularProgressIndicator()));
  //                     }
  //                     return SizedBox(
  //                         height: MediaQuery.of(context).size.height -
  //                             kBottomNavigationBarHeight -
  //                             kToolbarHeight,
  //                         child: ListView.builder(
  //                           physics: const ClampingScrollPhysics(),
  //                           itemCount: ctrl.listKajianSlider.length,
  //                           shrinkWrap: true,
  //                           itemBuilder: (context, index) {
  //                             var item = ctrl.listKajianSlider[index];
  //                             return ListItemUiWidget(
  //                               onTap: () async {
  //                                 final Uri url = Uri.parse(item['link']);
  //                                 if (!await launchUrl(url)) {
  //                                   print('Tidak dapat membuka link YouTube.');
  //                                 }
  //                               },
  //                               minHeight: 70,
  //                               vjustify: false,
  //                               widthContent:
  //                                   MediaQuery.of(context).size.width - 130,
  //                               id: item['id'],
  //                               title: item['judul'],
  //                               showIcon: IconPosition.left,
  //                               iconLeft: Stack(
  //                                 children: [
  //                                   ClipRRect(
  //                                     borderRadius: BorderRadius.circular(7),
  //                                     child: Image.network(
  //                                       item['image'],
  //                                       width: 65,
  //                                       height: 65,
  //                                       fit: BoxFit.cover,
  //                                     ),
  //                                   ),
  //                                 ],
  //                               ),
  //                               titleStyle: context.textTheme.labelMedium
  //                                   ?.copyWith(
  //                                       fontWeight: FontWeight.bold,
  //                                       color: Colors.black),
  //                               subTitle: item['subjudul'],
  //                               subtitleStyle: context.textTheme.labelMedium
  //                                   ?.copyWith(
  //                                       fontWeight: FontWeight.w100,
  //                                       color: Colors.black),
  //                               footerText: Moment.parse(item['updatedAt'])
  //                                   .format("dd MMMM yyyy",
  //                                       localeOverride: 'id'),
  //                               footerTextStyle: context.textTheme.labelSmall
  //                                   ?.copyWith(
  //                                       letterSpacing: 0,
  //                                       fontWeight: FontWeight.w100,
  //                                       color: Colors.black),
  //                             );
  //                           },
  //                         ));
  //                   })
  //                 ],
  //               );
  //       });
  // }

  void showPopup(BuildContext context, Widget? content, double? height) {
    showDialog(
        context: context,
        builder: (BuildContext bc) {
          return Dialog(
            elevation: 0,
            backgroundColor: const Color(0xFFDADADA),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7.0)),
            child: Container(
                padding: const EdgeInsets.all(10),
                height: height ?? 165,
                child: content ??
                    Column(
                      children: [
                        Text(
                          "Pilih Lokasi",
                          style: bc.textTheme.titleMedium?.copyWith(
                              letterSpacing: 1,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ButtonElevated(
                          title: 'Lokasi Terkini',
                          width: Get.width,
                          bgcolor: Theme.of(bc).primaryColor,
                          height: 45,
                          color: Colors.white,
                          radius: 7,
                          shadow: false,
                          onPressed: () {
                            Navigator.pop(context);
                            showPopup(bc, dialogTerkini(context), 200);
                          },
                        ),
                      ],
                    )),
          );
        });
  }

  Column dialogTerkini(BuildContext context) {
    return Column(
      children: [
        Text(
          "Dengan melanjutkan pilih lokasi anda akan mendapatkan pengingat adzan. Apakah anda yakin ingin melanjutkan ?",
          style: context.textTheme.titleSmall?.copyWith(
              letterSpacing: 0,
              fontWeight: FontWeight.normal,
              color: Colors.black),
        ),
        const SizedBox(
          height: 20,
        ),
        Obx(() {
          if (ctrl.isLoadingLokasi.isTrue) {
            return CircularProgressIndicator();
          }
          return ButtonElevated(
            title: 'Lanjutkan',
            width: Get.width,
            bgcolor: Theme.of(context).primaryColor,
            height: 45,
            color: Colors.white,
            radius: 7,
            shadow: false,
            onPressed: () async {
              ctrl.getLokasi();
            },
          );
        }),
      ],
    );
  }

  Column dialogCari(DashboardController ctrl, gctrl, BuildContext context, bc) {
    return Column(
      children: [
        Text(
          "Pilih Lokasi Manual mengikuti jam sholat di daerah tertentu. Jikas anda berpindah lokasi anda harus mengaktifkan secara manual kembali",
          style: context.textTheme.titleSmall?.copyWith(
              letterSpacing: 0,
              fontWeight: FontWeight.normal,
              color: Colors.black),
        ),
        const SizedBox(
          height: 20,
        ),
        ButtonElevated(
          title: 'Cari Lokasi',
          showIcon: 'right',
          iconRight: const Icon(Icons.search),
          width: Get.width,
          bgcolor: Theme.of(context).primaryColor,
          height: 45,
          color: Colors.white,
          radius: 7,
          shadow: false,
          onPressed: () {
            Navigator.pop(context);
            showPopup(
                context,
                dialogKota(context, ctrl),
                MediaQuery.of(context).size.height -
                    kBottomNavigationBarHeight -
                    100);
          },
        ),
      ],
    );
  }

  Column dialogKota(BuildContext context, DashboardController ctrl) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.search),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  "Cari Lokasi",
                  style: context.textTheme.titleSmall?.copyWith(
                      letterSpacing: 0,
                      fontWeight: FontWeight.normal,
                      color: Colors.black),
                ),
              ],
            ),
            ButtonIcon(
              onTap: () {
                Navigator.pop(context);
              },
              bgcolor: Colors.transparent,
              icon: const Icon(
                Icons.close,
                color: Colors.black38,
              ),
            )
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        ListView.builder(
          physics: const ClampingScrollPhysics(),
          itemCount: ctrl.listKota.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            // Datum model = filteredEvents[index];
            var item = ctrl.listKota[index];
            return FadeInUp(
              child: ListItemUiWidget(
                id: item['id'],
                title: item['label'],
                onTap: () {
                  Navigator.pop(context);
                },
                titleStyle: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold, color: Colors.black),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent));

    return Scaffold(
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        body: layout(context));
  }
}
