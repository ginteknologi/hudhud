import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:masjid_app/controllers/countDownEvent_controller.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CountDown_Widget extends StatelessWidget {
  final CountDownEventController ctrl = Get.find<CountDownEventController>();
  CountDown_Widget({super.key});

  @override
  Widget build(BuildContext) {
    // Text(
    //                           '${ctrl.remainingTime.inDays} Hari ${ctrl.remainingTime.inHours % 24} Jam ${ctrl.remainingTime.inMinutes % 60} Menit ${ctrl.remainingTime.inSeconds % 60} Detik',
    //                           style: TextStyle(
    //                               fontSize: 24, fontWeight: FontWeight.bold),
    //                         )
    return Obx(() {
      return Skeletonizer(
        enabled: ctrl.isLoadingEvent.value,
        child: Container(
            decoration: BoxDecoration(
              // color: Colors.white,
              image: DecorationImage(
                image: CachedNetworkImageProvider(ctrl
                    .eventData.value.imageUrl), // Ganti dengan URL gambar Anda
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(Get.width / 50),
            ),
            width: Get.width,
            height: Get.height / 4,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AutoSizeText(ctrl.eventData.value.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: Get.width / 17,
                        // fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                        fontFamily: GoogleFonts.katibeh().fontFamily,
                      )),
                  // SizedBox(height: Get.height / 80),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      for (int i = 0; i < ctrl.countdownData.length; i++)
                        Row(
                          children: [
                            SizedBox(width: Get.width / 80),
                            Container(
                              // padding: EdgeInsets.only(top: Get.width / 25),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(Get.width / 50),
                                border: Border.all(
                                    width: 0.5,
                                    color: Color.fromRGBO(177, 116, 62, 1)),
                                // color: Colors.red,
                                gradient: LinearGradient(
                                    begin: Alignment(6.123234262925839e-17, 1),
                                    end: Alignment(-1, 6.123234262925839e-17),
                                    colors: [
                                      Color.fromRGBO(177, 116, 62, 0.3),
                                      Color.fromRGBO(215, 163, 92, 0.3)
                                    ]),
                              ),
                              width: Get.width / 5.5,
                              height: Get.width / 5.5,
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(Get.width / 50),
                                child: BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      AutoSizeText(
                                        '${ctrl.countdownData[i]['value']}',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: Get.width / 9,
                                          fontFamily:
                                              GoogleFonts.katibeh().fontFamily,
                                        ),
                                      ),
                                      Positioned(
                                        bottom: Get.width / 80,
                                        child: AutoSizeText(
                                          '${ctrl.countdownData[i]['label']}',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: Get.width / 25,
                                            fontFamily: GoogleFonts.katibeh()
                                                .fontFamily,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: Get.width / 80),
                          ],
                        )
                    ],
                  ),
                  SizedBox(height: Get.height / 80),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: Get.width / 10),
                    child: AutoSizeText(ctrl.eventData.value.description,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        presetFontSizes: [
                          9,
                        ],
                        style: TextStyle(
                          color: Colors.white,
                        )),
                  ),
                ],
              ),
            )),
      );
    });
  }
}
