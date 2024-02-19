import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:masjid_app/components/button/elevatedbutton.dart';
import 'package:masjid_app/pages/quran/new_quran/alquran_controller.dart';
import 'package:masjid_app/routes/quran/index.dart';
import 'package:masjid_app/configs/main_controller.dart';

class AlquranPage extends StatelessWidget {
  const AlquranPage({Key? key}) : super(key: key);

  layout(AlquranController ctrl, MainController gctrl, BuildContext context) {
    return SafeArea(
      top: false,
      child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              children: [
                Container(
                  width: Get.width,
                  height: Get.height / 3,
                  constraints: BoxConstraints.loose(Size.infinite),
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15)),
                      gradient: LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          colors: [
                            Color(0xFF137065),
                            Color(0xFF4CB4A7),
                          ])),
                  child: Padding(
                    padding: EdgeInsets.only(left: 25, right: 25, bottom: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: AutoSizeText(
                                      'Yuk mulai tilawah Quran !',
                                      style: context.textTheme.titleMedium
                                          ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      softWrap: true,
                                      maxLines: 8,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  AutoSizeText(
                                    'Bacalah kalian Al-Quran. Karen ia akan datang pada hari kiamat kelak sebagai pemberi syafa’at bagi orang-orang yang rajin membacanya.',
                                    style: context.textTheme.labelMedium
                                        ?.copyWith(
                                            fontWeight: FontWeight.normal,
                                            color: Colors.white),
                                    softWrap: true,
                                    maxLines: 8,
                                  )
                                ],
                              ),
                            ),
                            Image.asset(
                              "assets/img/quran_banner.png",
                              // height: 85,
                              width: Get.width / 3,
                            ),
                          ],
                        )
                        // Image.asset(
                        //   "assets/img/new-logo-text.png",
                        //   height: 85,
                        //   width: 180,
                        // ),
                        // SizedBox(
                        //   height: 10,
                        // ),
                        // Align(
                        //   alignment: Alignment.center,
                        //   child: AutoSizeText(
                        //       "Di bawah Naungan Allah, kita bersatu dalam keimanan di Masjid, tempat keberkahan dan ketenangan merajut jalinan kasih dan do'a.",
                        //       maxLines: 4,
                        //       textAlign: TextAlign.center,
                        //       style: context.textTheme.labelSmall?.copyWith(
                        //           fontWeight: FontWeight.normal,
                        //           letterSpacing: -1,
                        //           color: Colors.white)),
                        // )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                // Padding(
                //   padding: EdgeInsets.only(left: 25, right: 25),
                //   child: Material(
                //       color: Colors.transparent,
                //       child: Row(
                //         children: [
                //           InkWell(
                //             onTap: () {
                //               Get.toNamed(RoutesQuran.perayat)?.then((result) {
                //                 if (result == 'refresh') {
                //                   ctrl.lastRead();
                //                 }
                //               });
                //               // Navigator.pop(context);
                //               // ctrl.typeViewQuran.value = TypeViewQuran.perayat;
                //               // ctrl.type.value = BottomBarEnum.alquran;
                //             },
                //             child: Column(
                //                 mainAxisAlignment: MainAxisAlignment.center,
                //                 crossAxisAlignment: CrossAxisAlignment.center,
                //                 children: [
                //                   Image.asset('assets/icons/icon_perayat.png',
                //                       height: 35, width: 35),
                //                   SizedBox(
                //                     height: 5,
                //                   ),
                //                   Text("Perayat",
                //                       style: context.textTheme.labelMedium
                //                           ?.copyWith(
                //                               fontWeight: FontWeight.w900,
                //                               color: Colors.black54))
                //                 ]),
                //           ),
                //           const SizedBox(
                //             width: 30,
                //           ),
                //           InkWell(
                //             onTap: () {
                //               Get.toNamed(RoutesQuran.perpage)?.then((result) {
                //                 if (result == 'refresh') {
                //                   ctrl.lastRead();
                //                 }
                //               });
                //               // Navigator.pop(context);
                //               // ctrl.typeViewQuran.value = TypeViewQuran.perhalaman;
                //               // ctrl.type.value = BottomBarEnum.alquran;
                //               // ctrl.idxLastReadHalaman.value = 3;
                //             },
                //             child: Column(
                //                 mainAxisAlignment: MainAxisAlignment.center,
                //                 crossAxisAlignment: CrossAxisAlignment.center,
                //                 children: [
                //                   Image.asset('assets/icons/quran_halaman.png',
                //                       height: 35, width: 35),
                //                   const SizedBox(
                //                     height: 5,
                //                   ),
                //                   Text("Indonesia",
                //                       style: context.textTheme.labelMedium
                //                           ?.copyWith(
                //                               fontWeight: FontWeight.w900,
                //                               color: Colors.black54))
                //                 ]),
                //           ),
                //           const SizedBox(
                //             width: 30,
                //           ),
                //           InkWell(
                //             onTap: () {
                //               Get.toNamed(RoutesQuran.perpagetajwid)
                //                   ?.then((result) {
                //                 if (result == 'refresh') {
                //                   ctrl.lastRead();
                //                 }
                //               });
                //             },
                //             child: Column(
                //                 mainAxisAlignment: MainAxisAlignment.center,
                //                 crossAxisAlignment: CrossAxisAlignment.center,
                //                 children: [
                //                   Image.asset('assets/icons/quran_halaman.png',
                //                       height: 35, width: 35),
                //                   const SizedBox(
                //                     height: 5,
                //                   ),
                //                   Text("Tajwid Indonesia",
                //                       style: context.textTheme.labelMedium
                //                           ?.copyWith(
                //                               fontWeight: FontWeight.w900,
                //                               color: Colors.black54))
                //                 ]),
                //           ),
                //           const SizedBox(
                //             width: 30,
                //           ),
                //         ],
                //       )),
                // ),
                // SizedBox(
                //   height: 40,
                // ),
                // Padding(
                //   padding: EdgeInsets.only(left: 25, right: 25),
                //   child: Material(
                //       color: Colors.transparent,
                //       child: Row(
                //         children: [
                //           InkWell(
                //             onTap: () {
                //               Get.toNamed(RoutesQuran.perpagemadinah)
                //                   ?.then((result) {
                //                 if (result == 'refresh') {
                //                   ctrl.lastRead();
                //                 }
                //               });
                //               // Navigator.pop(context);
                //               // ctrl.typeViewQuran.value = TypeViewQuran.perhalaman;
                //               // ctrl.type.value = BottomBarEnum.alquran;
                //               // ctrl.idxLastReadHalaman.value = 3;
                //             },
                //             child: Column(
                //                 mainAxisAlignment: MainAxisAlignment.center,
                //                 crossAxisAlignment: CrossAxisAlignment.center,
                //                 children: [
                //                   Image.asset('assets/icons/madinah.png',
                //                       height: 35, width: 35),
                //                   const SizedBox(
                //                     height: 5,
                //                   ),
                //                   Text("Madinah",
                //                       style: context.textTheme.labelMedium
                //                           ?.copyWith(
                //                               fontWeight: FontWeight.w900,
                //                               color: Colors.black54))
                //                 ]),
                //           ),
                //           const SizedBox(
                //             width: 30,
                //           ),
                //           InkWell(
                //             onTap: () {
                //               // Navigator.pop(context);
                //               // ctrl.typeViewQuran.value = TypeViewQuran.perhalaman;
                //               // ctrl.type.value = BottomBarEnum.alquran;
                //               // ctrl.idxLastReadHalaman.value = 3;
                //               ctrl.getData();
                //               showPopup(ctrl, context, null, null);
                //             },
                //             child: Column(
                //                 mainAxisAlignment: MainAxisAlignment.center,
                //                 crossAxisAlignment: CrossAxisAlignment.center,
                //                 children: [
                //                   Image.asset('assets/icons/gift.png',
                //                       height: 35, width: 35),
                //                   const SizedBox(
                //                     height: 5,
                //                   ),
                //                   Text("Kejutan",
                //                       style: context.textTheme.labelMedium
                //                           ?.copyWith(
                //                               fontWeight: FontWeight.w900,
                //                               color: Colors.black54))
                //                 ]),
                //           ),
                //         ],
                //       )),
                // ),
                SizedBox(
                  height: Get.height / 5.5,
                  child: Obx(() {
                    return GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.only(
                          left: Get.width / 20, right: Get.width / 20),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                      ),
                      itemCount: ctrl.listMenu.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: ctrl.listMenu[index]['onTap'] == null
                              ? () {
                                  showPopup(ctrl, context, null, null);
                                }
                              : ctrl.listMenu[index]['onTap'] as Function(),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                    ctrl.listMenu[index]['image'] as String,
                                    height: 35,
                                    width: 35),
                                const SizedBox(
                                  height: 5,
                                ),
                                Expanded(
                                  child: AutoSizeText(
                                      ctrl.listMenu[index]['title'] as String,
                                      maxLines: 2,
                                      textAlign: TextAlign.center,
                                      style: context.textTheme.labelMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.w900,
                                              color: Colors.black54)),
                                )
                              ]),
                        );
                      },
                    );
                  }),
                ),
                SizedBox(
                  height: 40,
                ),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 21),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Tilawah",
                              style: context.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  color: Colors.black)),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () {
                            Get.toNamed(RoutesQuran.perayat)?.then((result) {
                              if (result == 'refresh') {
                                ctrl.lastRead();
                              }
                            });
                          },
                          child: Container(
                              width: Get.width,
                              // height: Get.height * 0.10,
                              decoration: BoxDecoration(
                                  color: Color(0xFF048C7C),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              constraints: BoxConstraints.loose(Size.infinite),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 15),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text("Tilawah Perayat",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: context.textTheme.labelLarge
                                              ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white)),
                                    ),
                                    Align(
                                        alignment: Alignment.centerLeft,
                                        child: Obx(
                                          () => Text(ctrl.ayatSaatIni.value,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: context
                                                  .textTheme.labelMedium
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color: Colors.white)),
                                        )),
                                  ],
                                ),
                              )),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        InkWell(
                          onTap: () {
                            Get.toNamed(RoutesQuran.perpage)?.then((result) {
                              if (result == 'refresh') {
                                ctrl.lastRead();
                              }
                            });
                          },
                          child: Container(
                              width: Get.width,
                              // height: Get.height * 0.10,
                              decoration: BoxDecoration(
                                  color: Color(0xFF048C7C),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              constraints: BoxConstraints.loose(Size.infinite),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 15),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text("Tilawah Indonesia",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: context.textTheme.labelLarge
                                              ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white)),
                                    ),
                                    Align(
                                        alignment: Alignment.centerLeft,
                                        child: Obx(
                                          () => Text(
                                              ctrl.indonesiaSaatIni.value,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: context
                                                  .textTheme.labelMedium
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color: Colors.white)),
                                        )),
                                  ],
                                ),
                              )),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        InkWell(
                          onTap: () {
                            Get.toNamed(RoutesQuran.perpagetajwid)
                                ?.then((result) {
                              if (result == 'refresh') {
                                ctrl.lastRead();
                              }
                            });
                          },
                          child: Container(
                              width: Get.width,
                              // height: Get.height * 0.10,
                              decoration: BoxDecoration(
                                  color: Color(0xFF048C7C),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              constraints: BoxConstraints.loose(Size.infinite),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 15),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text("Tilawah Tajwid Indonesia",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: context.textTheme.labelLarge
                                              ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white)),
                                    ),
                                    Align(
                                        alignment: Alignment.centerLeft,
                                        child: Obx(
                                          () => Text(ctrl.tajwidSaatIni.value,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: context
                                                  .textTheme.labelMedium
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color: Colors.white)),
                                        )),
                                  ],
                                ),
                              )),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        InkWell(
                          onTap: () {
                            Get.toNamed(RoutesQuran.perpagemadinah)
                                ?.then((result) {
                              if (result == 'refresh') {
                                ctrl.lastRead();
                              }
                            });
                          },
                          child: Container(
                              width: Get.width,
                              // height: Get.height * 0.10,
                              decoration: BoxDecoration(
                                  color: Color(0xFF048C7C),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              constraints: BoxConstraints.loose(Size.infinite),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 15),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text("Tilawah Madinah",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: context.textTheme.labelLarge
                                              ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white)),
                                    ),
                                    Align(
                                        alignment: Alignment.centerLeft,
                                        child: Obx(
                                          () => Text(ctrl.madinahSaatIni.value,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: context
                                                  .textTheme.labelMedium
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color: Colors.white)),
                                        )),
                                  ],
                                ),
                              )),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                      ],
                    ))
              ],
            ),
          )),
    );
  }

  showPopup(AlquranController ctrl, context, Widget? content, double? height) {
    showDialog(
        context: context,
        builder: (BuildContext bc) {
          return Dialog(
            elevation: 0,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7.0)),
            child: Container(
                child: content ??
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Color(0xFFF5F5F5),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(7),
                                  topRight: Radius.circular(7))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                Icons.arrow_back,
                                color: Colors.black,
                              ),
                              Text(
                                '${ctrl.list['surat']} : ${ctrl.list['nomor_ayat']} ',
                                // "Q.S Al-Muthaffifiin :  34",
                                style: bc.textTheme.titleMedium?.copyWith(
                                    letterSpacing: 1,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              SvgPicture.asset("assets/icons/share.svg",
                                  height: 15, width: 15)
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: AutoSizeText("${ctrl.list['arab']}",
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.start,
                                maxLines: 2,
                                style: TextStyle(
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .labelLarge
                                        ?.fontSize,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w900))),
                        SizedBox(
                          height: 15,
                        ),
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: AutoSizeText("${ctrl.list['indonesia']}",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .labelMedium
                                        ?.fontSize,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w300))),
                        SizedBox(
                          height: 15,
                        ),
                        ButtonElevated(
                          iconLeft: Icon(
                            Icons.refresh_outlined,
                            size: 20,
                            color: Colors.white,
                          ),
                          showIcon: 'left',
                          title: 'Acak Lagi',
                          width: 129,
                          bgcolor: Theme.of(bc).primaryColor,
                          height: 45,
                          color: Colors.white,
                          radius: 7,
                          shadow: false,
                          onPressed: () {
                            Navigator.pop(context);
                            ctrl.getData();
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                      ],
                    )),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(AlquranController());
    final gctrl = Get.find<MainController>();
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light));
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      extendBodyBehindAppBar: false,
      resizeToAvoidBottomInset: false,
      body: Obx(() => ctrl.isLoadingList.value
          ? const Center(child: CircularProgressIndicator())
          : layout(ctrl, gctrl, context)),
    );
  }
}

enum TypeViewQuran { perayat, perhalaman }
