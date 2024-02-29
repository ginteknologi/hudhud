import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:masjid_app/components/button/elevatedbutton.dart';
import 'package:masjid_app/components/button/iconbutton.dart';
import 'package:masjid_app/components/layout/custom_card_item.dart';
import 'package:masjid_app/components/layout/custom_modal_bottom_sheet.dart';
import 'package:masjid_app/components/partial/list_ui.dart';
import 'package:masjid_app/models/artikelData.dart';
import 'package:masjid_app/models/kajianData.dart';
import 'package:masjid_app/models/kontenSosmed.dart';
import 'package:masjid_app/pages/dashboard/component/countDown.dart';
import 'package:masjid_app/pages/dashboard/component/ramadhanMenu.dart';
import 'package:masjid_app/pages/dashboard/component/waktusolat.dart';
import 'package:masjid_app/controllers/dashboard_controller.dart';
import 'package:masjid_app/routes/akun/index.dart';
import 'package:masjid_app/routes/notifikasi/index.dart';
import 'package:masjid_app/routes/quran/index.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:masjid_app/configs/main_controller.dart';
import 'package:simple_moment/simple_moment.dart';

class DashboardPage extends StatelessWidget {
  final DashboardController ctrl = Get.find();
  final MainController gctrl = Get.find<MainController>();
  DashboardPage({Key? key}) : super(key: key);

  layout(BuildContext context) {
    return SafeArea(
        top: false,
        child: Obx(() {
          return Container(
              height: Get.height,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF189A8C), Colors.white, Colors.white]),
              ),
              child: Padding(
                  padding: EdgeInsets.only(
                      left: Get.width / 30,
                      right: Get.width / 30,
                      top: Get.height / 20),
                  child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: Column(
                        children: [
                          header(context),
                          const WaktuSolat(),
                          getGridMenu(ctrl),
                          SizedBox(
                            height: Get.width / 30,
                          ),
                          CountDown_Widget(),
                          SizedBox(
                            height: Get.width / 30,
                          ),
                          RamadhanMenuWidget(),
                          SizedBox(
                            height: Get.width / 30,
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: getSeparator(
                                'Kajian Live', 'Lihat Semua', context, ctrl),
                          ),
                          Skeletonizer(
                            ignoreContainers: false,
                            enabled: ctrl.isLoadingKajianLive.value,
                            child: getListItem(ctrl, true),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: getSeparator('Kajian Tafsir Al-Quran',
                                'Lihat Semua', context, ctrl),
                          ),
                          Skeletonizer(
                            ignoreContainers: false,
                            enabled: ctrl.isLoadingKajianLive.value,
                            child: getListItemKajian(ctrl),
                          ),
                          Container(
                            child: getSeparator('Terbaru', '', context, ctrl),
                          ),
                          Skeletonizer(
                            ignoreContainers: false,
                            enabled: ctrl.isLoadingArtikel.value,
                            child: News(context, ctrl),
                          ),
                          SizedBox(
                            height: Get.height / 30,
                          )
                        ],
                      ))));
        }));
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
                      splashColor: Colors.green.withOpacity(0.5),
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
                  splashColor: Colors.green.withOpacity(0.5),
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

  News(BuildContext context, DashboardController ctrl) {
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
                chipText: "Umum",
                chipTextStyle: TextStyle(
                    fontSize: Theme.of(context).textTheme.labelLarge?.fontSize,
                    fontWeight: FontWeight.normal,
                    color: Colors.white),
                title: item.judul,
                subtitle: Moment.parse(item.updatedAt)
                    .format("dd MMMM yyyy", localeOverride: 'id'),
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

  getGridMenu(DashboardController ctrl) {
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
                  onTap: () {
                    if (ctrl.listMenuHome[index]['urlNav'] != '' &&
                        ctrl.listMenuHome[index]['urlNav'] != null) {
                      Get.toNamed(ctrl.listMenuHome[index]['urlNav']);
                    }
                  },
                  borderRadius: BorderRadius.circular(20),
                  splashColor: Colors.green.withOpacity(0.5),
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

  getSeparator(String nama, final String? sub, BuildContext context,
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
                  if (nama == 'Kajian Live') {
                    await ctrl.getKajianLive();
                  } else {
                    await ctrl.getKajianTafsir();
                  }
                  showSheet(ctrl, nama, context, true);
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

  getListItem(DashboardController ctrl, flag) {
    return SizedBox(
      height: 151,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: ctrl.listKontenSosmed.length,
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final SosmedData item = ctrl.listKontenSosmed[index];
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

  getListItemKajian(DashboardController ctrl) {
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
              imgPath: '${item.image}',
              islink: true,
              link: '${item.link}',
              network: true,
            );
          },
        ),
      );
    });
  }

  getButtonCard(DashboardController ctrl, BuildContext context) {
    return Card(
        elevation: 0,
        color: const Color(0xFFD9BA62),
        margin: const EdgeInsets.only(top: 10),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7),
          //set border radius more than 50% of height and width to make circle
        ),
        child: Material(
            color: Colors.transparent,
            child: InkWell(
                borderRadius: BorderRadius.circular(7),
                onTap: () {
                  if (ctrl.lastRead['ayatNumber'] > 0) {
                    Get.toNamed(
                        '${RoutesQuran.detail.replaceAll(':id', ctrl.lastRead['ayatNumber'].toString())}?nama_surah=${ctrl.lastRead['suratName']}');
                    // Get.toNamed(AppRoutes.detailEventScreen);
                  }
                },
                child: SizedBox(
                    width: Get.width,
                    height: 65,
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.symmetric(horizontal: 20),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                                flex: 1,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                        'assets/icons/quran_yellow.svg',
                                        height: 35,
                                        width: 35),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text("Terakhir Baca",
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall
                                                    ?.fontSize,
                                                color: Colors.black)),
                                        Text(
                                          ctrl.lastRead['ayatNumber'] > 0
                                              ? '${ctrl.lastRead['suratName']} : ${ctrl.lastRead['ayatNumber']}'
                                              : 'Belum baca',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.fontSize,
                                              color: Colors.black),
                                        )
                                      ],
                                    )
                                  ],
                                )),
                            const Icon(
                              Icons.chevron_right_rounded,
                              color: Colors.black,
                            )
                          ]),
                    )))));
  }

  void showSheet(
      DashboardController ctrl, nama, BuildContext context, bool flag) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: flag,
        useSafeArea: flag,
        showDragHandle: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20.0),
          ),
        ),
        builder: (BuildContext bc) {
          return !flag
              ? CustomModalBottomSheet(
                  typeSheet: TypeBottomSheet.typeGridSheet,
                  dataGrid: ctrl.listAllMenu,
                )
              : CustomModalBottomSheet(
                  typeSheet: TypeBottomSheet.typeFullscreenSheet,
                  content: [
                    SizedBox(
                      height: 30,
                      child: Text(
                        nama,
                        style: context.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ),
                    Obx(() {
                      if (ctrl.isLoadingKajian.isTrue) {
                        return Container(
                            height: Get.height / 1.2,
                            child: Center(child: CircularProgressIndicator()));
                      }
                      return SizedBox(
                          height: MediaQuery.of(context).size.height -
                              kBottomNavigationBarHeight -
                              kToolbarHeight,
                          child: ListView.builder(
                            physics: const ClampingScrollPhysics(),
                            itemCount: ctrl.listKajian.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              var item = ctrl.listKajian[index];
                              return ListItemUiWidget(
                                onTap: () async {
                                  final Uri url = Uri.parse(item['link']);
                                  if (!await launchUrl(url)) {
                                    print('Tidak dapat membuka link YouTube.');
                                  }
                                },
                                minHeight: 70,
                                vjustify: false,
                                widthContent:
                                    MediaQuery.of(context).size.width - 130,
                                id: item['id'],
                                title: item['judul'],
                                showIcon: IconPosition.left,
                                iconLeft: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(7),
                                      child: Image.network(
                                        item['image'],
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
                                    //       constraints: BoxConstraints.loose(
                                    //           Size.infinite),
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
                                    //               margin: const EdgeInsets.only(
                                    //                   right: 5),
                                    //               child: SvgPicture.asset(
                                    //                   'assets/icons/live.svg',
                                    //                   height: 6,
                                    //                   width: 6)),
                                    //           const Text('Live',
                                    //               overflow:
                                    //                   TextOverflow.ellipsis,
                                    //               textAlign: TextAlign.start,
                                    //               style: TextStyle(
                                    //                   color: Colors.white,
                                    //                   fontWeight:
                                    //                       FontWeight.bold,
                                    //                   fontStyle:
                                    //                       FontStyle.italic,
                                    //                   fontSize: 5)),
                                    //         ],
                                    //       ),
                                    //     ))
                                  ],
                                ),
                                titleStyle: context.textTheme.labelMedium
                                    ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                subTitle: item['subjudul'],
                                subtitleStyle: context.textTheme.labelMedium
                                    ?.copyWith(
                                        fontWeight: FontWeight.w100,
                                        color: Colors.black),
                                footerText: Moment.parse(item['updatedAt'])
                                    .format("dd MMMM yyyy",
                                        localeOverride: 'id'),
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

  void showPopup(context, Widget? content, double? height) {
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

  dialogTerkini(BuildContext context) {
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

  dialogCari(DashboardController ctrl, gctrl, BuildContext context, bc) {
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

  dialogKota(BuildContext context, DashboardController ctrl) {
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

  // void showPopupInfaq(ctrl, context) {
  //   showDialog(
  //       context: context,
  //       builder: (BuildContext bc) {
  //         return Dialog(
  //           elevation: 0,
  //           backgroundColor: const Color(0xFFDADADA),
  //           shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(7.0)),
  //           child: Container(
  //               padding: const EdgeInsets.all(10),
  //               height: 400,
  //               child: Text("testss")),
  //         );
  //       });
  // }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent));

    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        body: layout(context));
  }
}
