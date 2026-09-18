import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:masjid_app/configs/file_setup.dart';
import 'package:masjid_app/controllers/dashboard_controller.dart';
import 'package:masjid_app/models/sedangLiveData.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SedangLiveWidget extends StatelessWidget {
  final DashboardController ctrl = Get.find();
  SedangLiveWidget({super.key});

  @override
  Widget build(BuildContext context) {
    if (ctrl.listSedangLive.isEmpty) {
      return SizedBox();
    }
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFD5EDEA),
      ),
      height: Get.height / 4.7,
      width: Get.width,
      padding: EdgeInsets.symmetric(
        vertical: Get.width / 30,
      ),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.width / 30),
              child: AutoSizeText(
                "Sedang Live",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    fontSize:
                        Theme.of(context).textTheme.titleMedium?.fontSize),
              ),
            ),
            SizedBox(
              height: Get.width / 40,
            ),
            SizedBox(
              width: Get.width / 2.5,
              height: Get.height / 8,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: ctrl.listSedangLive.length,
                itemBuilder: (item, index) {
                  SedangLiveData item = ctrl.listSedangLive[index];
                  return Container(
                    width: Get.width / 1.2,
                    margin: EdgeInsets.only(left: Get.width / 80),
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                            useSafeArea: false,
                            context: Get.context!,
                            builder: (BuildContext context) {
                              return Dialog(
                                elevation: 3,
                                child: Stack(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(Get.width / 30),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(7)),
                                      ),
                                      height: Get.height / 1.8,
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            AutoSizeText(item.masjid,
                                                maxLines: 2,
                                                presetFontSizes: [
                                                  Get.width / 28
                                                ],
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    height: 0)),
                                            AutoSizeText(item.title,
                                                maxLines: 2,
                                                presetFontSizes: [
                                                  Get.width / 28
                                                ],
                                                style: TextStyle()),
                                            SizedBox(
                                              height: Get.width / 30,
                                            ),
                                            AutoSizeText(
                                              item.keterangan,
                                              maxLines: 4,
                                              presetFontSizes: [Get.width / 35],
                                            ),
                                            SizedBox(
                                              height: Get.width / 30,
                                            ),
                                            AutoSizeText(
                                              item.subtittle,
                                              presetFontSizes: [Get.width / 35],
                                              maxLines: 2,
                                            ),
                                            SizedBox(
                                              height: Get.width / 30,
                                            ),
                                            Expanded(
                                              child: Container(
                                                width: Get.width,
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        fit: BoxFit.fitHeight,
                                                        image:
                                                            CachedNetworkImageProvider(
                                                          item.image,
                                                        ))),
                                              ),
                                            ),
                                            SizedBox(
                                              height: Get.width / 30,
                                            ),
                                            Container(
                                              child: Row(
                                                children: [
                                                  Spacer(),
                                                  ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          Color(0xFF0685FA),
                                                      foregroundColor:
                                                          Colors.white,
                                                      maximumSize: Size(
                                                          Get.width / 3, 40),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              //to set border radius to button
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          Get.width /
                                                                              80)),
                                                    ),
                                                    onPressed: () async {
                                                      final result =
                                                          await downloadAndSaveFile(
                                                        url: item.image,
                                                        pathsave: '/sedanglive',
                                                      );
                                                      final resultshare =
                                                          await Share
                                                              .shareXFiles(
                                                        [XFile(result)],
                                                        text:
                                                            '${item.masjid}\n${item.title}\n${item.subtittle}\n${item.keterangan}\nBerikut adalah linknya: ${item.link}',
                                                      );

                                                      if (resultshare.status ==
                                                          ShareResultStatus
                                                              .success) {
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                "Berhasil dishare");
                                                      }
                                                      Get.back();
                                                    },
                                                    child: AutoSizeText(
                                                      'Bagikan Live',
                                                      presetFontSizes: [
                                                        Get.width / 32
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: Get.width / 50,
                                                  ),
                                                  ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          Color(0xFF048C7C),
                                                      foregroundColor:
                                                          Colors.white,
                                                      maximumSize: Size(
                                                          Get.width / 3, 40),
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      Get.width /
                                                                          80)),
                                                    ),
                                                    onPressed: () async {
                                                      final Uri url =
                                                          Uri.parse(item.link);
                                                      if (!await launchUrl(
                                                          url)) {
                                                        print(
                                                            'Tidak dapat membuka link YouTube.');
                                                      }
                                                    },
                                                    child: AutoSizeText(
                                                      'Tonton Live',
                                                      presetFontSizes: [
                                                        Get.width / 30
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ]),
                                    ),
                                  ],
                                ),
                              );
                            });
                      },
                      child: Card(
                        color: Colors.white,
                        child: Row(
                          children: [
                            Stack(
                              children: [
                                Container(
                                  width: Get.width / 5,
                                  margin: EdgeInsets.all(Get.width / 40),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(7),
                                      ),
                                      image: DecorationImage(
                                          fit: BoxFit.fitHeight,
                                          image: CachedNetworkImageProvider(
                                            item.image,
                                          ))),
                                  // child: ,
                                ),
                                Positioned(
                                    top: Get.width / 30,
                                    left: Get.width / 30,
                                    child: SvgPicture.asset(
                                        "assets/icons/live2.svg")),
                              ],
                            ),
                            Expanded(
                                child: Container(
                              padding: EdgeInsets.only(
                                  top: Get.width / 40,
                                  right: Get.width / 40,
                                  bottom: Get.width / 40),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AutoSizeText(
                                      item.masjid,
                                      maxLines: 2,
                                      presetFontSizes: [
                                        Get.width / 35,
                                        Get.width / 40,
                                        Get.width / 50
                                      ],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Spacer(),
                                    AutoSizeText(
                                      item.title,
                                      maxLines: 1,
                                      presetFontSizes: [Get.width / 40],
                                    ),
                                    AutoSizeText(
                                      item.subtittle,
                                      maxLines: 1,
                                      presetFontSizes: [Get.width / 45],
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic),
                                    )
                                  ]),
                            ))
                          ],
                        ),
                      ),
                    ),
                  );
                },
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
              ),
            )
          ]),
    );
  }
}
