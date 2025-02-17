import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:masjid_app/components/partial/list_ui.dart';
import 'package:masjid_app/models/kajianData.dart';
import 'package:masjid_app/models/sosmedData.dart';
import 'package:masjid_app/controllers/dkm_controller.dart';
import 'package:masjid_app/routes/quote/index.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart' as Refresh;
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';
// Pastikan impor ini sudah disertakan

class DkmPage extends StatelessWidget {
  final DkmController ctrl = Get.find();

  DkmPage({super.key});

  layout(BuildContext context) {
    return Refresh.SmartRefresher(
      enablePullDown: true,
      controller: ctrl.refreshController,
      onLoading: () async {
        await ctrl.getSlider();
        await ctrl.getData();
        ctrl.refreshController.loadComplete();
      },
      onRefresh: () async {
        ctrl.refreshController.refreshCompleted();
      },
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            Container(
              width: Get.width,
              height: Get.width / 2,
              constraints: BoxConstraints.loose(Size.infinite),
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15)),
                  image: DecorationImage(
                      image: AssetImage("assets/img/bg_dkm.png"),
                      fit: BoxFit.fill)),
              child: Padding(
                padding: EdgeInsets.only(left: 25, right: 25, bottom: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/img/new-logo-text.png",
                      fit: BoxFit.contain,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Align(
                        alignment: Alignment.center,
                        child: AutoSizeText(
                            "Di bawah Naungan Allah, kita bersatu dalam keimanan di Masjid, tempat keberkahan dan ketenangan merajut jalinan kasih dan do'a.",
                            maxLines: 4,
                            presetFontSizes: [Get.width / 35],
                            textAlign: TextAlign.center,
                            style: context.textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.normal,
                                letterSpacing: 0.5,
                                color: Colors.white)),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                Get.toNamed(RoutesQuote.root);
              },
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: Get.width / 20),
                  child: Text(
                    "Lihat Semua",
                    style: TextStyle(
                        color: Colors.black87, fontSize: Get.width / 30),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Obx(() => getListCategory(ctrl)),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Kontak Kami",
                          style: context.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.black38)),
                    ),
                    Obx(
                      () => ctrl.isLoadingList.value
                          ? SizedBox(
                              height: 30,
                            )
                          : ListView.builder(
                              physics: const ClampingScrollPhysics(),
                              itemCount: ctrl.listKontak.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                final SosmedData item = ctrl.listKontak[index];
                                return ListItemUiWidget(
                                  id: item.id,
                                  title: item.nama,
                                  widthContent:
                                      MediaQuery.of(context).size.width * 0.7,
                                  showIcon: IconPosition.left,
                                  // iconLeft: SvgPicture.network(item.icon,
                                  //     height: 30, width: 30),
                                  iconLeft: Image.network(item.icon,
                                      height: 40, width: 40),
                                  titleStyle: context.textTheme.bodySmall
                                      ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                  category: item.type,
                                  onTap: () async {
                                    final Uri url = Uri.parse(item.link);
                                    if (!await launchUrl(url)) {
                                      // print('Tidak dapat membuka link');
                                      Fluttertoast.showToast(
                                        msg: "Tidak dapat membuka link",
                                      );
                                    }
                                  },
                                );
                              },
                            ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Marbot Apps Supporting Formasi Satu",
                            style: context.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                        Image.asset(
                          "assets/img/formasi-satu.png",
                          // height: 85,
                          width: 180,
                          alignment: Alignment.centerLeft,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Marbot App version ${ctrl.version.value}",
                            style: context.textTheme.bodySmall?.copyWith(
                                fontSize: Get.width / 35, color: Colors.black),
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                      ],
                    ),
                    // ListView.builder(
                    //   physics: const ClampingScrollPhysics(),
                    //   itemCount: ctrl.listKontakv2.length,
                    //   shrinkWrap: true,
                    //   itemBuilder: (context, index) {
                    //     // Datum model = filteredEvents[index];
                    //     return FadeInUp(
                    //       child: ListItemUiWidget(
                    //         id: ctrl.listKontakv2[index]['id'],
                    //         title: ctrl.listKontakv2[index]['title'],
                    //         widthContent:
                    //             MediaQuery.of(context).size.width * 0.7,
                    //         showIcon: IconPosition.left,
                    //         iconLeft: SvgPicture.asset(
                    //             ctrl.listKontakv2[index]['icon'],
                    //             height: 30,
                    //             width: 30),
                    //         titleStyle: context.textTheme.bodySmall
                    //             ?.copyWith(
                    //                 fontWeight: FontWeight.bold,
                    //                 color: Colors.black),
                    //         category: ctrl.listKontakv2[index]['category'],
                    //         onTap: () async {
                    //           final Uri url = Uri.parse(
                    //               ctrl.listKontakv2[index]['link']);
                    //           if (!await launchUrl(url)) {
                    //             print('Tidak dapat membuka link.');
                    //           }
                    //         },
                    //         // subtitleStyle: context.textTheme.bodySmall
                    //         //     ?.copyWith(
                    //         //         fontWeight: FontWeight.normal,
                    //         //         color: Colors.black),
                    //       ),
                    //     );
                    //   },
                    // )
                  ],
                ))
          ],
        ),
      ),
    );
  }

  getListCategory(DkmController ctrl) {
    return Container(
      height: Get.height / 4.5,
      margin: const EdgeInsets.only(left: 15),
      child: Skeletonizer(
        ignoreContainers: false,
        enabled: ctrl.isLoadingSlider.isTrue,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemCount: ctrl.listQuotes.length,
          separatorBuilder: (context, index) => const SizedBox(width: 5),
          itemBuilder: (context, index) {
            final KajianData item = ctrl.listQuotes[index];
            return GestureDetector(
              onTap: () {
                ctrl.share(item);
              },
              child: Container(
                width: Get.width / 1.4,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Get.width / 50),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(item.image),
                      fit: BoxFit.fitWidth,
                    )),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: layout(context),
    );
  }
}
