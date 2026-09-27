import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:masjid_app/components/button/elevatedbutton.dart';
import 'package:masjid_app/components/layout/app_bar_ws.dart';
import 'package:masjid_app/core/router/app_router.dart';
import 'package:masjid_app/providers/auth_provider.dart';
import 'package:masjid_app/providers/notifikasi_provider.dart';

class DetailNotifikasiPage extends ConsumerWidget {
  const DetailNotifikasiPage({super.key});

  SafeArea layout(BuildContext context, Map<String, dynamic> list, String userName) {
    final screenWidth = MediaQuery.of(context).size.width;

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
                            "assets/icons/app_icon.png",
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
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.normal,
                                  fontFamily: "DMSerifDisplay",
                                  color: Theme.of(context).primaryColor)
                              // TextStyle(
                              //     fontFamily: "DMSerifDisplay",
                              //     color: Color(0xFFD06A4C),
                              //     fontSize: 30)
                              ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(userName,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black)
                              // TextStyle(
                              //     fontFamily: "DMSerifDisplay",
                              //     color: Color(0xFFD06A4C),
                              //     fontSize: 30)
                              ),
                        ),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              constraints: BoxConstraints.loose(Size.infinite),
                              width: screenWidth,
                              clipBehavior: Clip.antiAlias,
                              decoration: const BoxDecoration(
                                  color: Color(0xFFD9D9D9),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                      height: 85,
                                      child: Padding(
                                        padding: EdgeInsets.all(15),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            AutoSizeText(
                                                "ID Transaksi : ${list['data']['transaksi']['invoice'] ?? '-'}",
                                                maxLines: 1,
                                                style: Theme.of(context).textTheme.bodyMedium
                                                    ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                )),
                                            AutoSizeText(
                                                "Tanggal : ${DateFormat('dd MMMM yyyy, HH:mm').format(DateTime.parse(list['createdAt']))}",
                                                maxLines: 1,
                                                style: Theme.of(context).textTheme.bodyMedium
                                                    ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ))
                                          ],
                                        ),
                                      )),
                                  Container(
                                    height: 250,
                                    width: screenWidth,
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
                                                style: Theme.of(context).textTheme.bodySmall
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
                                                style: Theme.of(context).textTheme.bodySmall
                                                    ?.copyWith(
                                                  fontWeight: FontWeight.w300,
                                                  color: Colors.black,
                                                ),
                                                maxLines: 1,
                                              )
                                            ],
                                          ),
                                          AutoSizeText(
                                            "Tim Hudhud",
                                            style: Theme.of(context).textTheme.bodySmall
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
                                child: SizedBox(
                                  height: 20,
                                  width: screenWidth - 85,
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
                          height: 50,
                        ),
                      ],
                    )))));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = GoRouterState.of(context).pathParameters['id'] ?? '';
    final detailAsync = ref.watch(notifikasiDetailProvider(id));
    final userName = ref.watch(authNotifierProvider).valueOrNull?.name ?? '';

    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBarWSWidget.getAppbarWidget(
            title: "", context: context, elevation: 0),
        body: detailAsync.when(
          data: (list) => layout(context, list, userName),
          loading: () => Center(child: CircularProgressIndicator()),
          error: (err, _) =>
              Center(child: Text('Gagal memuat notifikasi: $err')),
        ),
        persistentFooterButtons: [
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ButtonElevated(
                title: 'Kembali Ke Beranda',
                width: MediaQuery.of(context).size.width,
                bgcolor: Theme.of(context).primaryColor,
                height: 45,
                color: Colors.white,
                radius: 5,
                onPressed: () {
                  context.go(AppRoutes.home);
                },
              ),
            ),
          )
        ]);
  }
}
