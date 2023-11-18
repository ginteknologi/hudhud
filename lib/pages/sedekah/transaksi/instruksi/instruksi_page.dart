import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mesjid_app/components/button/buttonvariant.dart';
import 'package:mesjid_app/components/button/elevatedbutton.dart';
import 'package:mesjid_app/components/layout/app_bar_ws.dart';
import 'package:mesjid_app/components/layout/custom_bottom_bar.dart';
import 'package:mesjid_app/components/partial/list_ui.dart';
import 'package:mesjid_app/pages/akun/akun_controller.dart';
import 'package:mesjid_app/pages/sedekah/transaksi/instruksi/instruksi_controller.dart';
import 'package:mesjid_app/routes/akun/index.dart';
import 'package:mesjid_app/routes/auth/index.dart';
import 'package:mesjid_app/routes/home/index.dart';

class InstruksiPage extends StatelessWidget {
  const InstruksiPage({super.key});

  layout(BuildContext context, InstruksiController ctrl) {
    return SafeArea(
        child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Padding(
                padding: const EdgeInsets.only(left: 21, right: 21),
                child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Card(
                            clipBehavior: Clip.antiAlias,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              //set border radius more than 50% of height and width to make circle
                            ),
                            color: const Color(0xFFDADADA),
                            child: ExpansionTile(
                              title: Text("ATM Mandiri",
                                  style: context.textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0,
                                      color: Colors.black)),
                              children: [
                                Container(
                                  width: Get.width - 40,
                                  padding: EdgeInsets.only(
                                      top: 20, left: 20, right: 20, bottom: 20),
                                  color: Colors.white,
                                  child: ListView.builder(
                                    physics: const ClampingScrollPhysics(),
                                    itemCount: ctrl.dataintruksi.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      // Datum model = filteredEvents[index];
                                      var item = ctrl.dataintruksi[index];
                                      var no = index + 1;
                                      return Padding(
                                          padding: EdgeInsets.only(bottom: 5),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("$no. "),
                                              // r
                                              Flexible(
                                                  child: AutoSizeText(
                                                      item['label'],
                                                      maxLines: 4,
                                                      style: context
                                                          .textTheme.bodySmall
                                                          ?.copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              letterSpacing: 0,
                                                              height: 0,
                                                              color: Colors
                                                                  .black)))
                                            ],
                                          ));
                                    },
                                  ),
                                )
                              ],
                              // Container(
                              //     color: Colors.white,
                              //     padding: const EdgeInsets.all(20),
                              //     width: double.infinity,
                              //     child: AutoSizeText(
                              //         "Lorem ipsum dolor sit amet consectetur. Imperdiet porttitor cras viverra odio massa. Aliquam interdum et etiam elementum viverra ullamcorper a aliquam. Morbi odio orci sed ut massa in at. Vel egestas quam pellentesque eget magnis posuere. Donec netus fringilla sem hendrerit turpis amet ac. Sit sed maecenas est sit nec donec risus. Rhoncus leo tellus libero at cras mattis habitasse lacus. Lacus sem tempus cursus eget habitant at ultrices arcu duis. Morbi morbi egestas risus pellentesque velit. Non sed eu mauris orci nunc id lorem nibh ultrices. Habitant in hendrerit arcu enim diam dignissim enim ultricies. Sit adipiscing etiam. Rhoncus leo tellus libero at cras mattis habitasse lacus. Lacus sem tempus cursus eget habitant at ultrices arcu duis. Morbi morbi egestas risus pellentesque ",
                              //         style: context.textTheme.bodySmall
                              //             ?.copyWith(
                              //                 fontWeight: FontWeight.normal,
                              //                 letterSpacing: 0,
                              //                 height: 0,
                              //                 color: Colors.black)),
                              //   )
                            )),
                        SizedBox(
                          height: 20,
                        ),
                        Card(
                            clipBehavior: Clip.antiAlias,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              //set border radius more than 50% of height and width to make circle
                            ),
                            color: const Color(0xFFDADADA),
                            child: ExpansionTile(
                              title: Text("Mandiri Internet Banking",
                                  style: context.textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0,
                                      color: Colors.black)),
                              children: [
                                Container(
                                  width: Get.width - 40,
                                  padding: EdgeInsets.only(
                                      top: 20, left: 20, right: 20, bottom: 20),
                                  color: Colors.white,
                                  child: ListView.builder(
                                    physics: const ClampingScrollPhysics(),
                                    itemCount: ctrl.dataintruksi.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      // Datum model = filteredEvents[index];
                                      var item = ctrl.dataintruksi[index];
                                      var no = index + 1;
                                      return Padding(
                                          padding: EdgeInsets.only(bottom: 5),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("$no. "),
                                              // r
                                              Flexible(
                                                  child: AutoSizeText(
                                                      item['label'],
                                                      maxLines: 4,
                                                      style: context
                                                          .textTheme.bodySmall
                                                          ?.copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              letterSpacing: 0,
                                                              height: 0,
                                                              color: Colors
                                                                  .black)))
                                            ],
                                          ));
                                    },
                                  ),
                                )
                              ],
                              // Container(
                              //     color: Colors.white,
                              //     padding: const EdgeInsets.all(20),
                              //     width: double.infinity,
                              //     child: AutoSizeText(
                              //         "Lorem ipsum dolor sit amet consectetur. Imperdiet porttitor cras viverra odio massa. Aliquam interdum et etiam elementum viverra ullamcorper a aliquam. Morbi odio orci sed ut massa in at. Vel egestas quam pellentesque eget magnis posuere. Donec netus fringilla sem hendrerit turpis amet ac. Sit sed maecenas est sit nec donec risus. Rhoncus leo tellus libero at cras mattis habitasse lacus. Lacus sem tempus cursus eget habitant at ultrices arcu duis. Morbi morbi egestas risus pellentesque velit. Non sed eu mauris orci nunc id lorem nibh ultrices. Habitant in hendrerit arcu enim diam dignissim enim ultricies. Sit adipiscing etiam. Rhoncus leo tellus libero at cras mattis habitasse lacus. Lacus sem tempus cursus eget habitant at ultrices arcu duis. Morbi morbi egestas risus pellentesque ",
                              //         style: context.textTheme.bodySmall
                              //             ?.copyWith(
                              //                 fontWeight: FontWeight.normal,
                              //                 letterSpacing: 0,
                              //                 height: 0,
                              //                 color: Colors.black)),
                              //   )
                            ))
                      ],
                    )))));
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(InstruksiController());

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBarWSWidget.getAppbarWidget(
          title: "Instruksi Pembayaran", context: context, elevation: 0),
      body: layout(context, ctrl),
    );
  }
}
