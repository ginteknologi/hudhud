import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:masjid_app/components/button/elevatedbutton.dart';
import 'package:masjid_app/models/bookmarkData.dart';
import 'package:masjid_app/pages/quran/new_quran/alquran_controller.dart';
import 'package:masjid_app/configs/main_controller.dart';
import 'package:masjid_app/routes/quran/index.dart';
import 'package:share_plus/share_plus.dart';

class AlquranPage extends StatelessWidget {
// class AlquranPage extends StatefulWidget {
//   const AlquranPage({Key? key}) : super(key: key);

//   @override
//   State<AlquranPage> createState() => AlquranPageState();
// }

// class AlquranPageState extends State<AlquranPage> {
  final ctrl = Get.put(AlquranController());
  final gctrl = Get.find<MainController>();
  // AlquranPage({Key? key}) : super(key: key);

  // @override
  // void initState() {
  //   super.initState();
  //   // Call your function here
  //   WidgetsBinding.instance
  //       .addPostFrameCallback((_) => showPopupAlquran(ctrl, context, 'siang'));
  // }

  layout(BuildContext context) {
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        // physics: const ClampingScrollPhysics(),
        child: Obx(() {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(child: header(context)),
              SizedBox(
                height: Get.height * 0.01,
              ),
              Flexible(
                child: getGridMenu(ctrl),
              ),
              SizedBox(
                height: Get.height * 0.01,
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: Get.width * 0.04),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Bookmark Tilawah Anda",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: Get.width * 0.04,
                            )),
                      ),
                      SizedBox(
                        height: Get.height * 0.01,
                      ),
                      tilawahMenu(
                          title: "Tilawah Perayat",
                          route: RoutesQuran.perayat,
                          history: gctrl.ayatBookmark.value,
                          context),
                      SizedBox(
                        height: Get.height * 0.01,
                      ),
                      tilawahMenu(
                          title: "Tilawah Indonesia",
                          route: RoutesQuran.perpage,
                          history: gctrl.indonesiaBookmark.value,
                          context),
                      SizedBox(
                        height: Get.height * 0.01,
                      ),
                      tilawahMenu(
                          title: "Tilawah Tajwid Indonesia",
                          route: RoutesQuran.perpagetajwid,
                          history: gctrl.tajwidBookmark.value,
                          context),
                      SizedBox(
                        height: Get.height * 0.01,
                      ),
                      tilawahMenu(
                          title: "Tilawah Madinah",
                          route: RoutesQuran.perpagemadinah,
                          history: gctrl.madinahBookmark.value,
                          context),
                      SizedBox(
                        height: Get.height * 0.05,
                      ),
                    ],
                  ))
            ],
          );
        }),
      ),
    );
  }

  tilawahMenu(BuildContext context,
      {title, route, required bookmarkData history}) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF048C7C),
        borderRadius: BorderRadius.circular(Get.width * 0.01),
      ),
      child: ListTile(
          dense: true,
          contentPadding: EdgeInsets.symmetric(
            horizontal: Get.width * 0.05,
          ),
          onTap: () {
            Get.toNamed(route + '?bookmarks=true');
          },
          trailing: Icon(
            Icons.chevron_right,
            color: Colors.white,
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: Get.width * 0.035,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: GoogleFonts.poppins().fontFamily,
            ),
          ),
          subtitle: Text(
            history.totalAyat == 0
                ? "${history.namaSurat}"
                : "${history.namaSurat} (${history.ayat}:${history.totalAyat})",
            style: TextStyle(
              fontSize: Get.width * 0.03,
              color: Colors.white,
              fontFamily: GoogleFonts.poppins().fontFamily,
            ),
          )),
    );
  }

  getGridMenu(AlquranController ctrl) {
    return Padding(
      padding: const EdgeInsets.only(left: 0, right: 0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: ctrl.listMenu.length,
        padding: EdgeInsets.only(top: 15),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 0.82,
            mainAxisExtent: Get.width / 4.5),
        itemBuilder: (context, index) {
          return Material(
              color: Colors.transparent,
              child: InkWell(
                  onTap: ctrl.listMenu[index]['onTap'] == null
                      ? () async {
                          await ctrl.getData();
                          showPopup(ctrl, context, null, null);
                        }
                      : ctrl.listMenu[index]['onTap'] as Function(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFE6F4F2),
                          borderRadius: BorderRadius.circular(Get.width / 50),
                        ),
                        padding: EdgeInsets.all(Get.width / 45),
                        child: Image.asset(ctrl.listMenu[index]['icon'],
                            height: Get.width / 9, width: Get.width / 9),
                      ),
                      SizedBox(height: 5),
                      Expanded(
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: Get.width / 50),
                          child: AutoSizeText(
                            '${ctrl.listMenu[index]["title"]}',
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

  Container header(BuildContext context) {
    return Container(
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
                          style: context.textTheme.titleMedium?.copyWith(
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
                        style: context.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.normal, color: Colors.white),
                        softWrap: true,
                        maxLines: 8,
                      )
                    ],
                  ),
                ),
                Image.asset(
                  "assets/img/quran_banner.png",
                  width: Get.width / 3,
                ),
              ],
            )
          ],
        ),
      ),
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
            child: Obx(() {
              if (ctrl.isLoadingRandom.isTrue) {
                return const Center(child: CircularProgressIndicator());
              }
              return Container(
                  child: content ??
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                InkWell(
                                  onTap: () {
                                    Get.back();
                                  },
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  '${ctrl.list['surat']} : ${ctrl.list['nomor_ayat']}',
                                  style: bc.textTheme.titleMedium?.copyWith(
                                      letterSpacing: 1,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                InkWell(
                                    onTap: () {
                                      Share.share(
                                          '${ctrl.list['arab']}\n\n${ctrl.list['indonesia']}',
                                          subject:
                                              "${ctrl.list['surat']} : ${ctrl.list['nomor_ayat']}");
                                    },
                                    child: SvgPicture.asset(
                                        "assets/icons/share.svg",
                                        height: 15,
                                        width: 15))
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
                                  textAlign: TextAlign.end,
                                  maxLines: 4,
                                  style: TextStyle(
                                      fontFamily:
                                          GoogleFonts.amiriQuran().fontFamily,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w900))),
                          SizedBox(
                            height: 15,
                          ),
                          Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: AutoSizeText("${ctrl.list['indonesia']}",
                                  textAlign: TextAlign.justify,
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
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ButtonElevated(
                              iconLeft: Icon(
                                Icons.refresh_outlined,
                                size: 20,
                                color: Colors.white,
                              ),
                              showIcon: 'left',
                              title: 'Acak Lagi',
                              bgcolor: Theme.of(bc).primaryColor,
                              height: 45,
                              color: Colors.white,
                              radius: 7,
                              shadow: false,
                              onPressed: () {
                                ctrl.getData();
                              },
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      ));
            }),
          );
        });
  }
  // =========

  // showPopupAlquran(AlquranController ctrl, context, flag) {
  //   showDialog(
  //       context: context,
  //       builder: (BuildContext bc) {
  //         return Dialog(
  //           elevation: 0,
  //           backgroundColor: Colors.white,
  //           shape:
  //               RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  //           child: Obx(() {
  //             if (!ctrl.isLoadingRandom.isTrue) {
  //               return const Center(child: CircularProgressIndicator());
  //             }
  //             var url = 'assets/img/subuh_alert.png';
  //             if (flag == 'siang') {
  //               url = 'assets/img/siang_alert.png';
  //             } else if (flag == 'petang') {
  //               url = 'assets/img/petang_alert.png';
  //             }
  //             return Container(
  //                 child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               crossAxisAlignment: CrossAxisAlignment.stretch,
  //               children: [
  //                 Container(
  //                     padding: const EdgeInsets.all(10),
  //                     decoration: BoxDecoration(
  //                         image: DecorationImage(
  //                             image: AssetImage(url), fit: BoxFit.fill),
  //                         borderRadius: BorderRadius.only(
  //                             topLeft: Radius.circular(10),
  //                             topRight: Radius.circular(10))),
  //                     child: Column(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         Align(
  //                           alignment: Alignment.centerLeft,
  //                           child: InkWell(
  //                             onTap: () {
  //                               Get.back();
  //                             },
  //                             child: Icon(
  //                               Icons.close,
  //                               color: Colors.white,
  //                             ),
  //                           ),
  //                         ),
  //                         SizedBox(
  //                           height: 40,
  //                         ),
  //                         Align(
  //                             alignment: Alignment.centerLeft,
  //                             child: AutoSizeText(
  //                               'Al-Baqarah - 10',
  //                               textAlign: TextAlign.center,
  //                               maxLines: 2,
  //                               style: TextStyle(
  //                                   fontSize: Theme.of(context)
  //                                       .textTheme
  //                                       .labelLarge
  //                                       ?.fontSize,
  //                                   height: 1.1,
  //                                   color: Colors.white,
  //                                   fontWeight: FontWeight.w500),
  //                             )),
  //                       ],
  //                     )),
  //                 const SizedBox(
  //                   height: 20,
  //                 ),
  //                 Padding(
  //                     padding: EdgeInsets.symmetric(horizontal: 10),
  //                     child: AutoSizeText(
  //                         "Ini Ayat Alquran Lorem ipsum dolor sit amet consectetur. Enim velit sodales neque rhoncus gravida elit justo. Sed vitae libero ipsum dignissim erat.",
  //                         overflow: TextOverflow.ellipsis,
  //                         textAlign: TextAlign.end,
  //                         maxLines: 4,
  //                         style: TextStyle(
  //                             fontFamily: GoogleFonts.amiriQuran().fontFamily,
  //                             color: Colors.black,
  //                             fontWeight: FontWeight.w900))),
  //                 SizedBox(
  //                   height: 15,
  //                 ),
  //                 Divider(
  //                   height: 2,
  //                 ),
  //                 SizedBox(
  //                   height: 15,
  //                 ),
  //                 Padding(
  //                     padding: EdgeInsets.symmetric(horizontal: 10),
  //                     child: AutoSizeText(
  //                         "Ini terjemahan nya Lorem ipsum dolor sit amet consectetur. Enim velit sodales neque rhoncus gravida elit justo. Sed vitae libero ipsum dignissim erat.",
  //                         textAlign: TextAlign.justify,
  //                         style: TextStyle(
  //                             fontSize: Theme.of(context)
  //                                 .textTheme
  //                                 .labelMedium
  //                                 ?.fontSize,
  //                             fontStyle: FontStyle.italic,
  //                             color: Colors.black,
  //                             fontWeight: FontWeight.w300))),
  //                 SizedBox(
  //                   height: 30,
  //                 ),
  //               ],
  //             ));
  //           }),
  //         );
  //       });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: false,
      resizeToAvoidBottomInset: false,
      body: layout(context),
    );
  }
}

enum TypeViewQuran { perayat, perhalaman }
