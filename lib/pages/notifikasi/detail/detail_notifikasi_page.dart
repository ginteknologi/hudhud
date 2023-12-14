import 'package:auto_size_text/auto_size_text.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:masjid_app/components/button/elevatedbutton.dart';
import 'package:masjid_app/components/layout/app_bar_ws.dart';
import 'package:masjid_app/pages/notifikasi/detail/detail_notifikasi_controller.dart';
import 'package:masjid_app/routes/home/index.dart';
import 'package:masjid_app/routes/notifikasi/index.dart';
import 'package:masjid_app/theme.dart';
import 'package:easy_localization/easy_localization.dart';

class DetailNotifikasiPage extends StatelessWidget {
  const DetailNotifikasiPage({super.key});

  layout(BuildContext context, DetailNotifikasiController ctrl) {
    return SafeArea(
        child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Padding(
                    padding:
                        const EdgeInsets.only(left: 21, right: 21, top: 21),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Image.asset(
                            "assets/img/logo_circle.png",
                            fit: BoxFit.fitHeight,
                            width: 100,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text("Jazakallah Khairon",
                              style: context.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.normal,
                                  fontFamily: "DMSerifDisplay",
                                  color: Theme.of(context).primaryColor)
                              // TextStyle(
                              //     fontFamily: "DMSerifDisplay",
                              //     color: Color(0xFF048C7C),
                              //     fontSize: 30)
                              ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(ctrl.dataUser['name'],
                              style: context.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black)
                              // TextStyle(
                              //     fontFamily: "DMSerifDisplay",
                              //     color: Color(0xFF048C7C),
                              //     fontSize: 30)
                              ),
                        ),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              constraints: BoxConstraints.loose(Size.infinite),
                              width: Get.width,
                              clipBehavior: Clip.antiAlias,
                              decoration: const BoxDecoration(
                                  color: Color(0xFFD9D9D9),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      height: 85,
                                      child: Padding(
                                        padding: EdgeInsets.all(15),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            AutoSizeText(
                                                "No. Invoice : " + ctrl.list['data']['transaksi']['invoice'],
                                                maxLines: 1,
                                                style: context
                                                    .textTheme.bodyMedium
                                                    ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                )),
                                            AutoSizeText("Tanggal : "+ DateFormat('dd MMMM yyyy, HH:mm').format(DateTime.parse(ctrl.list['createdAt'])),
                                                maxLines: 1,
                                                style: context
                                                    .textTheme.bodyMedium
                                                    ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ))
                                          ],
                                        ),
                                      )),
                                  Container(
                                    height: 250,
                                    width: Get.width,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: const Radius.circular(10),
                                        bottomRight: const Radius.circular(10),
                                      ),
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.all(15),
                                      margin: const EdgeInsetsDirectional.only(
                                          start: 2, end: 2, bottom: 2),
                                      decoration: BoxDecoration(
                                          border: Border(
                                        left: BorderSide(
                                          color: Color(0xFFDADADA),
                                          width: 1.0,
                                        ),
                                        right: BorderSide(
                                          color: Color(0xFFDADADA),
                                          width: 1.0,
                                        ),
                                        bottom: BorderSide(
                                          color: Color(0xFFDADADA),
                                          width: 1.0,
                                        ),
                                      )),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              AutoSizeText(
                                                "Donasi Anda sudah Kami terima, Semoga Allah SWT membalas segala kebaikan dan membalas kelimpahan yang berlipat ganda serta keberkahan.",
                                                style: context
                                                    .textTheme.bodySmall
                                                    ?.copyWith(
                                                  fontWeight: FontWeight.w300,
                                                  color: Colors.black,
                                                ),
                                                maxLines: 5,
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              AutoSizeText(
                                                "Salam, ",
                                                style: context
                                                    .textTheme.bodySmall
                                                    ?.copyWith(
                                                  fontWeight: FontWeight.w300,
                                                  color: Colors.black,
                                                ),
                                                maxLines: 1,
                                              )
                                            ],
                                          ),
                                          AutoSizeText(
                                            "DKM Mesjid An Ni'mah ",
                                            style: context.textTheme.bodySmall
                                                ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                            maxLines: 1,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                                left: -15,
                                top: 70,
                                child: Container(
                                  height: 30,
                                  width: 30,
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle),
                                )),
                            Positioned(
                                right: -15,
                                top: 70,
                                child: Container(
                                  height: 30,
                                  width: 30,
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle),
                                )),
                            Positioned(
                                top: 75,
                                child: Container(
                                  height: 20,
                                  width: Get.width - 85,
                                  child: Row(
                                    children: List.generate(
                                        150 ~/ 2,
                                        (index) => Expanded(
                                              child: Container(
                                                color: index % 2 == 0
                                                    ? Colors.transparent
                                                    : Colors.grey,
                                                height: 2,
                                              ),
                                            )),
                                  ),
                                )),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: Get.width,
                          child: ButtonElevated(
                            title: 'Lihat Invoice',
                            width: Get.width,
                            bgcolor: Color(0xFF007EA6),
                            height: 45,
                            color: Colors.white,
                            radius: 5,
                            onPressed: () {
                              print(ctrl.list['data']['transaksi']['invoice']);
                              Get.toNamed('${RoutesNotifikasi.root}/detail/invoice/${ctrl.list['data']['transaksi']['invoice']}');
                            },
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                      ],
                    )))));
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(DetailNotifikasiController());

    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBarWSWidget.getAppbarWidget(
            title: "", context: context, elevation: 0),
        body: Obx(() => ctrl.isLoadingList.value ? Center(child: CircularProgressIndicator()) : layout(context, ctrl)),
        persistentFooterButtons: [
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Container(
              width: Get.width,
              child: ButtonElevated(
                title: 'Kembali Ke Beranda',
                width: Get.width,
                bgcolor: Theme.of(context).primaryColor,
                height: 45,
                color: Colors.white,
                radius: 5,
                onPressed: () {
                  Get.offAllNamed(RoutesHome.root);
                },
              ),
            ),
          )
        ]);
  }
}
