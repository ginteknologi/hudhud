import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masjid_app/controllers/waktuSolat_controller.dart';
// import 'package:masjid_app/routes/alarm/index.dart';
import 'package:skeletonizer/skeletonizer.dart';
// import 'package:hijri/hijri_calendar.dart';

class WaktuSolat extends StatelessWidget {
  final WaktuSolatController ctrl = Get.find();
  WaktuSolat({super.key});

  layout(BuildContext context) {
    return Card(
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
        height: Get.height / 3,
        child: Column(
          children: [
            Expanded(
                flex: 1,
                child: Obx(() {
                  return Skeletonizer(
                    enabled: ctrl.isLoading.isTrue,
                    child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: Get.width / 30,
                            vertical: Get.width / 40),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                    "https://nos.wjv-1.neo.id/marbot/assets/waktusolat_backround.png"),
                                fit: BoxFit.cover)),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        AutoSizeText(
                                          "${ctrl.hijriahDate.value}",
                                          maxLines: 1,
                                          presetFontSizes: [Get.width / 37],
                                          style: context.textTheme.labelSmall
                                              ?.copyWith(
                                                  letterSpacing: 1,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                        ),
                                        AutoSizeText(ctrl.todayDate.value,
                                            maxLines: 1,
                                            presetFontSizes: [Get.width / 37],
                                            style: context.textTheme.labelSmall
                                                ?.copyWith(
                                                    height: 1,
                                                    letterSpacing: 1,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Colors.white)),
                                      ]),
                                  
                                            SizedBox(height: Get.height / 150),
                                  Expanded(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          AutoSizeText(
                                              ctrl.waktuSolat.value.label,
                                              maxLines: 1,
                                              style: context
                                                  .textTheme.headlineSmall
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color: Colors.white)),
                                                    SizedBox(height: 1),
                                          AutoSizeText(
                                              ctrl.waktuSolat.value.time24!,
                                              maxLines: 1,
                                              style: context
                                                  .textTheme.displayMedium
                                                  ?.copyWith(
                                                      fontWeight: FontWeight.w900,
                                                      color: Colors.white,
                                                      height: 1))
                                        ]),
                                  ),
                                            SizedBox(height: Get.height / 150),
                                  Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        AutoSizeText(
                                          ctrl.jarakWaktu.value,
                                          presetFontSizes: [Get.width / 37],
                                          style: context.textTheme.labelMedium
                                              ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                        ),
                                        AutoSizeText(
                                            "Menuju Waktu ${ctrl.waktuSolat.value.label}",
                                            presetFontSizes: [Get.width / 37],
                                            style: context.textTheme.labelMedium
                                                ?.copyWith(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Colors.white,
                                                    height: 1)),
                                      ]),
                                ],
                              ),
                            ),
                            // IconButton.filled(
                            //     onPressed: () {
                            //       Get.toNamed(RoutesAlarm.root);
                            //     },
                            //     color: Colors.black,
                            //     style: IconButton.styleFrom(
                            //       backgroundColor: Colors.white60,
                            //     ),
                            //     icon: Icon(Icons.alarm))
                          ],
                        )),
                  );
                })),
            Obx(() {
              return Skeletonizer(
                enabled: ctrl.isLoading.isTrue,
                child: SizedBox(
                    height: 62,
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                        child: GridView.count(
                          crossAxisCount: 5,
                          shrinkWrap: false,
                          mainAxisSpacing: 0,
                          crossAxisSpacing: 0,
                          padding: const EdgeInsets.all(0),
                          physics: const NeverScrollableScrollPhysics(),
                          childAspectRatio: 0.5,
                          children: List.generate(ctrl.list.length, (index) {
                            return SizedBox(
                                height: 20,
                                child: Container(
                                    decoration: BoxDecoration(
                                        border: Border(
                                            right: BorderSide(
                                                width: 1,
                                                color: index == 4
                                                    ? Colors.transparent
                                                    : const Color(
                                                        0xFFA5A5A5)))),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        AutoSizeText(
                                          ctrl.list[index].label,
                                          textAlign: TextAlign.center,
                                          style: ctrl.list[index].status
                                              ? context.textTheme.bodySmall
                                                  ?.copyWith(
                                                      letterSpacing: 1,
                                                      fontSize: Get.width / 32,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Color(0xFF1FC54E))
                                              : context.textTheme.bodySmall
                                                  ?.copyWith(
                                                      letterSpacing: 1,
                                                      fontSize: Get.width / 32,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.black54),
                                          maxLines: 1,
                                        ),
                                        AutoSizeText(
                                          ctrl.list[index].time,
                                          textAlign: TextAlign.center,
                                          style: ctrl.list[index].status
                                              ? context.textTheme.bodySmall
                                                  ?.copyWith(
                                                      letterSpacing: 1,
                                                      fontSize: Get.width / 33,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Color(0xFF1FC54E))
                                              : context.textTheme.bodySmall
                                                  ?.copyWith(
                                                      letterSpacing: 1,
                                                      fontSize: Get.width / 33,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.black),
                                          maxLines: 1,
                                        ),
                                      ],
                                    )));
                          }),
                        ))),
              );
            })
          ],
        ),
      ), //SizedBox
    );
  }

  @override
  Widget build(BuildContext context) {
    return layout(context);
  }
}
