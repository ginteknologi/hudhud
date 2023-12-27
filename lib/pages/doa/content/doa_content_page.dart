import 'package:easy_localization/easy_localization.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:masjid_app/components/button/elevatedbutton.dart';
import 'package:masjid_app/components/layout/app_bar_ws.dart';
import 'package:masjid_app/components/partial/list_card_ui.dart';
import 'package:masjid_app/pages/doa/content/doa_content_controller.dart';

class ContentDoaPage extends StatelessWidget {
  const ContentDoaPage({super.key});

  layout(ContentDoaController ctrl, BuildContext context) {
    return SafeArea(
        child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        decoration: BoxDecoration(color: Colors.white),
                        child: Padding(
                            padding: const EdgeInsets.only(
                                left: 21, right: 21, top: 21),
                            child: Column(
                              children: [
                                ListCardUiWidget(
                                  id: 1,
                                  title: "Do’a Bangun Tidur",
                                  titleStyle: context.textTheme.titleSmall
                                      ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Theme.of(context).primaryColor),
                                  subtitleStyle: context.textTheme.labelMedium
                                      ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black45),
                                  onTap: () {
                                    // ctrl.goToDetail(ctrl.listDoa[index]);
                                  },
                                  subtitle:
                                      "Alhamdulillahil ladzi ahyana ba'da ma amatana wa ilaihin nusyur. Segala puji bagi Allah, Tuhan yang menghidupkan kami setelah ia mematikan kami. Kepada-Nyalah kebangkitan hari kiamat",
                                  hasFooter: true,
                                  footerContent: [
                                    Text(DateFormat('dd MMMM yyyy').format( DateTime.parse(ctrl.list['date'])),
                                      style: context.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w300),
                                    ),                                    
                                    // Text("QS. Al-Baqoroh 185",
                                    //     textAlign: TextAlign.start,
                                    //     style: context.textTheme.labelSmall
                                    //         ?.copyWith(
                                    //             fontWeight: FontWeight.bold,
                                    //             letterSpacing: 0,
                                    //             color: Colors.black54)),
                                    // Row(
                                    //   children: [
                                    //     Icon(
                                    //       Icons.remove_red_eye_rounded,
                                    //       color: Colors.black54,
                                    //       size: context
                                    //           .textTheme.labelLarge?.fontSize,
                                    //     ),
                                    //     SizedBox(
                                    //       width: 5,
                                    //     ),
                                    //     Text("10",
                                    //         textAlign: TextAlign.end,
                                    //         style: context.textTheme.labelMedium
                                    //             ?.copyWith(
                                    //                 fontWeight: FontWeight.w300,
                                    //                 color: Colors.black54)),
                                    //   ],
                                    // )
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  // height: 53,
                                  width: Get.width,
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Container(
                                          padding: EdgeInsets.only(right: 13.0),
                                          child: AutoSizeText(
                                              "Yuk ingetin yang lain!",
                                              maxLines: 1,
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontSize: Theme.of(context)
                                                      .textTheme
                                                      .labelMedium
                                                      ?.fontSize,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      ),
                                      Flexible(
                                        child: Container(
                                          width: double.infinity,
                                          child: ButtonElevated(
                                            title: 'Bagikan',
                                            width: Get.width,
                                            bgcolor: const Color(0xFF92E3A9),
                                            height: 35,
                                            color: Colors.black,
                                            radius: 5,
                                            size: 12,
                                            // size: Theme.of(context)
                                            //     .textTheme
                                            //     .bodySmall
                                            //     ?.fontSize,
                                            showIcon: "right",
                                            iconRight: Icon(
                                              Icons.share,
                                              size: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.fontSize,
                                            ),
                                            onPressed: () {
                                              // ctrl.goToDetail('1');
                                            },
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            )),
                      )
                    ]))));
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(ContentDoaController());

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBarWSWidget.getAppbarWidget(
          title: "Do'a > Do'a Harian > Detail", context: context, elevation: 0),
      body: Obx(() => ctrl.isLoadingList.value ? CircularProgressIndicator() : layout(ctrl, context)),
    );
  }
}
