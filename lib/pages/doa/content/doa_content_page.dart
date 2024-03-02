import 'package:auto_size_text/auto_size_text.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:masjid_app/components/button/elevatedbutton.dart';
import 'package:masjid_app/components/layout/app_bar_ws.dart';
import 'package:masjid_app/pages/doa/content/doa_content_controller.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:share_plus/share_plus.dart';

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
                                Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                        highlightColor: Colors.transparent,
                                        splashColor:
                                            Colors.green.withOpacity(0.5),
                                        child: Card(
                                          elevation: 0,
                                          color: Colors.white,
                                          margin:
                                              const EdgeInsets.only(top: 20),
                                          clipBehavior: Clip.antiAlias,
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                              color: Color(0xFFDADADA),
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            //set border radius more than 50% of height and width to make circle
                                          ),
                                          child: Container(
                                              width: Get.width,
                                              constraints: BoxConstraints.loose(
                                                  Size.infinite),
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    top: 10,
                                                    left: 10,
                                                    right: 10,
                                                    bottom: 5),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: AutoSizeText(
                                                            ctrl.list.value
                                                                .judul,
                                                            textAlign:
                                                                TextAlign.start,
                                                            style: context
                                                                .textTheme
                                                                .titleSmall
                                                                ?.copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .primaryColor),
                                                            maxLines: 2,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        ctrl.list.value
                                                                    .arabic !=
                                                                null
                                                            ? Align(
                                                                alignment: Alignment
                                                                    .centerRight,
                                                                child:
                                                                    AutoSizeText(
                                                                  ctrl.list.value.arabic!,
                                                                  textAlign:
                                                                      TextAlign.start,
                                                                  style: context.textTheme.titleSmall
                                                                      ?.copyWith(
                                                                          fontWeight: FontWeight
                                                                              .bold),
                                                                  maxLines: 2,
                                                                ))
                                                            : Container(),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        ctrl.list.value
                                                                    .transliteration !=
                                                                null
                                                            ? Text(
                                                                ctrl.list.value
                                                                    .transliteration!,
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                style: context
                                                                    .textTheme
                                                                    .labelMedium
                                                                    ?.copyWith(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w300,
                                                                        color: Colors
                                                                            .black54))
                                                            : Container(),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        ctrl.list.value
                                                                    .translations !=
                                                                null
                                                            ? Align(
                                                                alignment:
                                                                    Alignment
                                                                        .bottomRight,
                                                                child: Html(
                                                                    data: ctrl
                                                                        .list
                                                                        .value
                                                                        .translations!,
                                                                    style: {
                                                                      "p": Style(
                                                                          fontSize:
                                                                              FontSize(13.0))
                                                                    }))
                                                            : Container(),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        ctrl.list.value.isi !=
                                                                null
                                                            ? Align(
                                                                alignment: Alignment
                                                                    .bottomRight,
                                                                child: Html(
                                                                    data: ctrl
                                                                        .list
                                                                        .value
                                                                        .isi!,
                                                                    style: {
                                                                      "p": Style(
                                                                          fontSize:
                                                                              FontSize(13.0))
                                                                    }))
                                                            : Container(),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        // Text(DateFormat('dd MMMM yyyy').format( DateTime.parse(ctrl.list[index]['date'])),
                                                        // style: context.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w300),
                                                        // ),

                                                        // AutoSizeText(
                                                        //   ctrl.list[index]['isi'],
                                                        //   textAlign: TextAlign.end,
                                                        //   style: context.textTheme.labelSmall
                                                        //       ?.copyWith(
                                                        //           fontWeight: FontWeight.bold,
                                                        //           letterSpacing: 0,
                                                        //           color: Colors.black54),
                                                        //   maxLines: 2,
                                                        // ),
                                                        // Text(ctrl.list[index]['isi'],
                                                        //     textAlign: TextAlign.start,
                                                        //     style: context
                                                        //         .textTheme.labelSmall
                                                        //         ?.copyWith(
                                                        //             fontWeight:
                                                        //                 FontWeight.bold,
                                                        //             letterSpacing: 0,
                                                        //             color: Colors.black54)),
                                                        Row(
                                                          children: [
                                                            // Icon(
                                                            //   Icons.remove_red_eye_rounded,
                                                            //   color: Colors.black54,
                                                            //   size: context.textTheme
                                                            //       .labelLarge?.fontSize,
                                                            // ),
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            // Text(
                                                            //     ctrl.listDoa[index]['viewer'],
                                                            //     textAlign: TextAlign.end,
                                                            //     style: context
                                                            //         .textTheme.labelMedium
                                                            //         ?.copyWith(
                                                            //             fontWeight:
                                                            //                 FontWeight.w300,
                                                            //             color:
                                                            //                 Colors.black54)),
                                                          ],
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              )), //SizedBox
                                        ))),
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
                                                      .labelLarge
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
                                              // Gunakan plugin share_plus untuk berbagi teks artikel
                                              Share.share(ctrl.share.value,
                                                  subject:
                                                      ctrl.list.value.judul);
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
      body: Obx(() => ctrl.isLoadingList.value
          ? CircularProgressIndicator()
          : layout(ctrl, context)),
    );
  }
}
