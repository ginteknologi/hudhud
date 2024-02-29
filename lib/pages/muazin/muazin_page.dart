import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:masjid_app/controllers/muazin_controller.dart';
import 'package:masjid_app/components/partial/list_ui.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:auto_size_text/auto_size_text.dart';

class MuazinPage extends StatelessWidget {
  final ctrl = Get.put(MuazinController());
  MuazinPage({Key? key}) : super(key: key);

  layout(BuildContext context) {
    return SafeArea(
      top: false,
      child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 21),
                    child: Column(
                      children: [
                        ListView.builder(
                          physics: const ClampingScrollPhysics(),
                          itemCount: ctrl.listMuadzin.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            ;
                            return ListItemUiWidget(
                              onTap: () async {
                                final Uri url =
                                    Uri.parse(ctrl.listMuadzin[index].link);
                                if (!await launchUrl(url)) {
                                  print('Tidak dapat membuka link YouTube.');
                                }
                              },
                              minHeight: 70,
                              vjustify: false,
                              widthContent:
                                  MediaQuery.of(context).size.width - 130,
                              id: 1,
                              title: ctrl.listMuadzin[index].judul,
                              showIcon: IconPosition.left,
                              iconLeft: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(7),
                                    child: Image.network(
                                      ctrl.listMuadzin[index].image,
                                      width: 65,
                                      height: 65,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ],
                              ),
                              titleStyle: context.textTheme.labelMedium
                                  ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                              subTitle: '',
                              subtitleStyle: context.textTheme.labelMedium
                                  ?.copyWith(
                                      fontWeight: FontWeight.w100,
                                      color: Colors.black),
                              footerText: ctrl.listMuadzin[index].subjudul,
                              footerTextStyle: context.textTheme.labelSmall
                                  ?.copyWith(
                                      letterSpacing: 0,
                                      fontWeight: FontWeight.w100,
                                      color: Colors.black),
                            );
                          },
                        )
                      ],
                    ))
              ],
            ),
          )),
    );
  }

  // layout(BuildContext context) {
  //   return SafeArea(
  //     top: false,
  //     child: SingleChildScrollView(
  //       // physics: const ClampingScrollPhysics(),
  //       child: Obx(() {
  //         if (!ctrl.isLoading.value) {
  //           return Column(
  //             mainAxisAlignment: MainAxisAlignment.start,
  //             crossAxisAlignment: CrossAxisAlignment.stretch,
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               SizedBox(
  //                 height: Get.height * 0.01,
  //               ),
  //               SizedBox(
  //                   height: MediaQuery.of(context).size.height -
  //                       kBottomNavigationBarHeight -
  //                       kToolbarHeight -
  //                       23,
  //                   child: ListView.builder(
  //                     physics: const ClampingScrollPhysics(),
  //                     itemCount: ctrl.listMuadzin.length,
  //                     shrinkWrap: true,
  //                     itemBuilder: (context, index) {
  //                       ;
  //                       return ListItemUiWidget(
  //                         onTap: () async {
  //                           final Uri url =
  //                               Uri.parse(ctrl.listMuadzin[index].link);
  //                           if (!await launchUrl(url)) {
  //                             print('Tidak dapat membuka link YouTube.');
  //                           }
  //                         },
  //                         minHeight: 70,
  //                         vjustify: false,
  //                         widthContent: MediaQuery.of(context).size.width - 130,
  //                         id: 1,
  //                         title: ctrl.listMuadzin[index].judul,
  //                         showIcon: IconPosition.left,
  //                         iconLeft: Stack(
  //                           children: [
  //                             ClipRRect(
  //                               borderRadius: BorderRadius.circular(7),
  //                               child: Image.network(
  //                                 ctrl.listMuadzin[index].image,
  //                                 width: 65,
  //                                 height: 65,
  //                                 fit: BoxFit.cover,
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                         titleStyle: context.textTheme.labelMedium?.copyWith(
  //                             fontWeight: FontWeight.bold, color: Colors.black),
  //                         subTitle: '',
  //                         subtitleStyle: context.textTheme.labelMedium
  //                             ?.copyWith(
  //                                 fontWeight: FontWeight.w100,
  //                                 color: Colors.black),
  //                         footerText: ctrl.listMuadzin[index].subjudul,
  //                         footerTextStyle: context.textTheme.labelSmall
  //                             ?.copyWith(
  //                                 letterSpacing: 0,
  //                                 fontWeight: FontWeight.w100,
  //                                 color: Colors.black),
  //                       );
  //                     },
  //                   )
  //                   )
  //             ],
  //           );
  //         } else {
  //           return Column(
  //             mainAxisAlignment: MainAxisAlignment.start,
  //             crossAxisAlignment: CrossAxisAlignment.stretch,
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               SizedBox(
  //                 height: Get.height * 0.01,
  //               ),
  //               SizedBox(
  //                 child: CircularProgressIndicator(),
  //               ),
  //               SizedBox(
  //                 height: Get.height * 0.01,
  //               ),
  //             ],
  //           );
  //         }
  //       }),
  //     ),
  //   );
  // }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: false,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text("Sahabat Muadzin"),
      ),
      body: layout(context),
    );
  }
}
