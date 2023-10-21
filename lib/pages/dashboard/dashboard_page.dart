import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mesjid_app/components/button/iconbutton.dart';
import 'package:mesjid_app/components/layout/custom_card_item.dart';
import 'package:mesjid_app/components/layout/custom_modal_bottom_sheet.dart';
import 'package:mesjid_app/pages/dashboard/dashboard_controller.dart';
import 'package:mesjid_app/routes/akun/index.dart';
import 'package:mesjid_app/routes/notifikasi/index.dart';
import 'package:mesjid_app/routes/sedekah/index.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  layout(DashboardController ctrl, BuildContext context) {
    return SafeArea(
        top: false,
        child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF189A8C), Colors.white, Colors.white]),
            ),
            child: Padding(
                padding: const EdgeInsets.only(left: 21, right: 21, top: 50),
                child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Column(
                      children: [
                        Row(
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
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.white)),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 0),
                                        child: Text(
                                            "Muhammad Fahmi Zulmeinidar".tr,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.start,
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w900)),
                                      ),
                                    ),
                                    const Align(
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
                                                padding:
                                                    EdgeInsets.only(left: 5),
                                                child: Text(
                                                    "Kota Jakarta, Indonesia",
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xFFFFECB7),
                                                        fontSize: 12)))
                                          ],
                                        ),
                                      ),
                                    ),
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
                                      splashColor:
                                          Colors.green.withOpacity(0.5),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: Image.network(
                                          "https://picsum.photos/50",
                                          height: 35,
                                          width: 35,
                                        ),
                                      ),
                                    )),
                              ],
                            )
                          ],
                        ),
                        Card(
                          elevation: 0,
                          color: const Color(0xFFF5F5F5),
                          margin: const EdgeInsets.only(top: 20),
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            //set border radius more than 50% of height and width to make circle
                          ),
                          child: SizedBox(
                            width: Get.width,
                            height: 220,
                            child: Column(
                              children: [
                                Flexible(
                                    flex: 1,
                                    child: Container(
                                      width: Get.width,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 5),
                                      constraints:
                                          BoxConstraints.loose(Size.infinite),
                                      decoration: const BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  "assets/img/card/card_subuh.png"),
                                              fit: BoxFit.fill)),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Ahad, 9 Muharram 1444",
                                                  style: context
                                                      .textTheme.labelSmall
                                                      ?.copyWith(
                                                          letterSpacing: 1,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white),
                                                ),
                                                Text("Minggu, 8 Agustus 2023",
                                                    style: context
                                                        .textTheme.labelSmall
                                                        ?.copyWith(
                                                            height: 1,
                                                            letterSpacing: 1,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            color:
                                                                Colors.white)),
                                              ]),
                                          Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text("Subuh",
                                                    style: context
                                                        .textTheme.headlineSmall
                                                        ?.copyWith(
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            color:
                                                                Colors.white)),
                                                Text("04.00 WIB",
                                                    style: context
                                                        .textTheme.displayMedium
                                                        ?.copyWith(
                                                            fontWeight:
                                                                FontWeight.w900,
                                                            color: Colors.white,
                                                            height: 1))
                                              ]),
                                          // SizedBox(
                                          //   height: 2,
                                          // ),
                                          Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "3 Jam 20 Menit",
                                                  style: context
                                                      .textTheme.labelMedium
                                                      ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white),
                                                ),
                                                Text("Menuju Ashar",
                                                    style: context
                                                        .textTheme.labelMedium
                                                        ?.copyWith(
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            color: Colors.white,
                                                            height: 1)),
                                              ]),
                                        ],
                                      ),
                                    )),
                                SizedBox(
                                    height: 62,
                                    child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 12, 0, 12),
                                        child: GridView.count(
                                          crossAxisCount: 5,
                                          shrinkWrap: false,
                                          mainAxisSpacing: 0,
                                          crossAxisSpacing: 0,
                                          padding: const EdgeInsets.all(0),
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          childAspectRatio: 0.5,
                                          children: List.generate(
                                              ctrl.listWaktu.length, (index) {
                                            return SizedBox(
                                                height: 20,
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                        border: Border(
                                                            right: BorderSide(
                                                                width: 1,
                                                                color: index ==
                                                                        4
                                                                    ? Colors
                                                                        .transparent
                                                                    : const Color(
                                                                        0xFFA5A5A5)))),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        AutoSizeText(
                                                          ctrl.listWaktu[index]
                                                              ['label'],
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: Colors
                                                                  .black54,
                                                              fontSize: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodySmall
                                                                  ?.fontSize),
                                                          maxLines: 1,
                                                        ),
                                                        AutoSizeText(
                                                          ctrl.listWaktu[index]
                                                              ['waktu'],
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodySmall
                                                                  ?.fontSize),
                                                          maxLines: 1,
                                                        ),
                                                      ],
                                                    )));
                                          }),
                                        )))
                              ],
                            ),
                          ), //SizedBox
                        ),
                        getGridMenu(ctrl),
                        Container(
                          margin: const EdgeInsets.only(top: 25),
                          child: getSeparator(
                              'Kajian Live', 'Lihat Semua', context),
                        ),
                        getListItem(ctrl),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: getSeparator(
                              "Sudah Baca Qur'an Hari Ini?", null, context),
                        ),
                        getButtonCard(ctrl, context),
                        Container(
                          margin: const EdgeInsets.only(top: 25),
                          child: getSeparator('Terbaru', '', context),
                        ),
                        getListItemVertical(ctrl),
                        const SizedBox(
                          height: 100,
                        )
                      ],
                    )))));
  }

  getGridMenu(DashboardController ctrl) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: ctrl.listMenuHome.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
        itemBuilder: (context, index) {
          return SizedBox(
              height: 47,
              child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                          onTap: () {
                            if (ctrl.listMenuHome[index]['urlNav'] ==
                                'lainnya') {
                              showSheet(ctrl, context);
                            } else {
                              Get.toNamed(RoutesSedekah.root);
                            }
                          },
                          borderRadius: BorderRadius.circular(20),
                          splashColor: Colors.green.withOpacity(0.5),
                          child: GestureDetector(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(ctrl.listMenuHome[index]['icon'],
                                  height: 35, width: 35),
                              const SizedBox(height: 5),
                              Text(
                                '${ctrl.listMenuHome[index]["label"]}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.fontSize,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ))))));
        },
      ),
    );
  }

  getSeparator(String nama, final String? sub, BuildContext context) {
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
                onTap: () {},
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

  getListItem(DashboardController ctrl) {
    return Container(
      height: 151,
      child: ListView.separated(
        // padding: EdgeInsets.only(left: 24, right: 24),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: ctrl.listKajianLive.length,
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          return FadeInLeft(
              child: CustomCardItem(
            title: '${ctrl.listKajianLive[index]["title"]}',
            subtitle: '${ctrl.listKajianLive[index]["subtitle"]}',
            kategori: '${ctrl.listKajianLive[index]["kategori"]}',
            chipText: '${ctrl.listKajianLive[index]["flag"]}',
            imgPath: '${ctrl.listKajianLive[index]["image"]}',
          ));
        },
      ),
    );
  }

  getButtonCard(DashboardController ctrl, BuildContext context) {
    return Card(
        elevation: 0,
        color: Color(0xFFD9BA62),
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
                  print("tapped");
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
                                          "Al-Fatihah : 5",
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

  getListItemVertical(DashboardController ctrl) {
    return Container(
      child: ListView.separated(
        // padding: EdgeInsets.only(left: 24, right: 24),
        scrollDirection: Axis.vertical,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: ctrl.listArtikel.length,
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          return FadeInLeft(
              child: CustomCardItem(
            isFullWidth: true,
            height: 165,
            size: "medium",
            positionChip: CrossAxisAlignment.start,
            chipColor: Theme.of(context).primaryColor,
            chipText: '${ctrl.listArtikel[index]["kategori"]}',
            chipTextStyle: TextStyle(
                fontSize: Theme.of(context).textTheme.labelLarge?.fontSize,
                fontWeight: FontWeight.normal,
                color: Colors.white),
            title: '${ctrl.listArtikel[index]["title"]}',
            subtitle:
                '${ctrl.listArtikel[index]["time"]} | ${ctrl.listArtikel[index]["date"]}',
            imgPath: '${ctrl.listArtikel[index]["image"]}',
          ));
        },
      ),
    );
  }

  void showSheet(ctrl, context) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20.0),
          ),
        ),
        builder: (BuildContext bc) {
          return CustomModalBottomSheet(
            typeSheet: TypeBottomSheet.typeGridSheet,
            dataGrid: ctrl.listAllMenu,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(DashboardController());

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent));

    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        body: layout(ctrl, context));
  }
}
