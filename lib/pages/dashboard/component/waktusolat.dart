import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masjid_app/configs/main_controller.dart';

class WaktuSolat extends StatelessWidget {
  const WaktuSolat({super.key});

  layout(BuildContext context) {
    MainController ctrl = Get.find<MainController>();

    var activeCard;
    for (var element in ctrl.listWaktu) {
      if (element['active']) {
        activeCard = element;
      }
    }

    return Obx(() {
      if (ctrl.loadingwaktusolat.isTrue) {
        return SizedBox(
            width: Get.width,
            height: 220,
            child: Center(
              child: CircularProgressIndicator(),
            ));
      }
      return Card(
        elevation: 0,
        color: const Color(0xFFF5F5F5),
        margin: const EdgeInsets.only(top: 20),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Get.width / 20)),
        child: activeCard == null
            ? SizedBox(
                width: Get.width,
                height: 220,
              )
            : SizedBox(
                width: Get.width,
                height: 220,
                child: Column(
                  children: [
                    Expanded(
                        flex: 1,
                        child: Container(
                            width: Get.width,
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5),
                            constraints: BoxConstraints.loose(Size.infinite),
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(activeCard['cardImage']),
                                    fit: BoxFit.fill)),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: (MediaQuery.of(context).size.width *
                                          0.5) -
                                      10,
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
                                            AutoSizeText(
                                              ctrl.HijriDate,
                                              maxLines: 1,
                                              style: context
                                                  .textTheme.labelSmall
                                                  ?.copyWith(
                                                      letterSpacing: 1,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          activeCard['label'] ==
                                                                  'Dzuhur'
                                                              ? Colors.black
                                                              : Colors.white),
                                            ),
                                            AutoSizeText(ctrl.todayDate.value,
                                                maxLines: 1,
                                                style: context
                                                    .textTheme.labelSmall
                                                    ?.copyWith(
                                                        height: 1,
                                                        letterSpacing: 1,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color: activeCard[
                                                                    'label'] ==
                                                                'Dzuhur'
                                                            ? Colors.black
                                                            : Colors.white)),
                                          ]),
                                      Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            AutoSizeText(activeCard['label'],
                                                maxLines: 1,
                                                style: context
                                                    .textTheme.headlineSmall
                                                    ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color: activeCard[
                                                                    'label'] ==
                                                                'Dzuhur'
                                                            ? Colors.black
                                                            : Colors.white)),
                                            AutoSizeText(
                                                activeCard['waktu'] + " WIB",
                                                maxLines: 1,
                                                style: context
                                                    .textTheme.displayMedium
                                                    ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        color: activeCard[
                                                                    'label'] ==
                                                                'Dzuhur'
                                                            ? Colors.black
                                                            : Colors.white,
                                                        height: 1))
                                          ]),
                                      // SizedBox(
                                      //   height: 2,
                                      // ),
                                      Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Obx(() => Text(
                                                  ctrl.txttime.value,
                                                  style: context
                                                      .textTheme.labelMedium
                                                      ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: activeCard[
                                                                      'label'] ==
                                                                  'Dzuhur'
                                                              ? Colors.black
                                                              : Colors.white),
                                                )),
                                            Text(
                                                "Menuju " + activeCard['label'],
                                                style: context
                                                    .textTheme.labelMedium
                                                    ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color: activeCard[
                                                                    'label'] ==
                                                                'Dzuhur'
                                                            ? Colors.black
                                                            : Colors.white,
                                                        height: 1)),
                                          ]),
                                    ],
                                  ),
                                )
                              ],
                            ))),
                    SizedBox(
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
                              children:
                                  List.generate(ctrl.listWaktu.length, (index) {
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
                                              ctrl.listWaktu[index]['label'],
                                              textAlign: TextAlign.center,
                                              style: ctrl.listWaktu[index]
                                                      ['active']
                                                  ? context.textTheme.bodySmall
                                                      ?.copyWith(
                                                          letterSpacing: 1,
                                                          fontSize:
                                                              Get.width / 32,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Color(0xFF1FC54E))
                                                  : context.textTheme.bodySmall
                                                      ?.copyWith(
                                                          letterSpacing: 1,
                                                          fontSize:
                                                              Get.width / 32,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color:
                                                              Colors.black54),
                                              maxLines: 1,
                                            ),
                                            AutoSizeText(
                                              ctrl.listWaktu[index]['waktu'],
                                              textAlign: TextAlign.center,
                                              style: ctrl.listWaktu[index]
                                                      ['active']
                                                  ? context.textTheme.bodySmall
                                                      ?.copyWith(
                                                          letterSpacing: 1,
                                                          fontSize:
                                                              Get.width / 33,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Color(0xFF1FC54E))
                                                  : context.textTheme.bodySmall
                                                      ?.copyWith(
                                                          letterSpacing: 1,
                                                          fontSize:
                                                              Get.width / 33,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.black),
                                              maxLines: 1,
                                            ),
                                          ],
                                        )));
                              }),
                            )))
                  ],
                ),
              ), //SizedBox
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return layout(context);
  }
}
