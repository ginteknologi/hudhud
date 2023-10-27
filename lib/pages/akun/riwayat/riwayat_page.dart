import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mesjid_app/components/button/iconbutton.dart';
import 'package:mesjid_app/components/input/InputText.dart';
import 'package:mesjid_app/components/layout/app_bar_ws.dart';
import 'package:mesjid_app/components/partial/list_ui.dart';
import 'package:mesjid_app/pages/akun/riwayat/riwayat_controller.dart';
import 'package:mesjid_app/theme.dart';

class RiwayatPage extends StatelessWidget {
  const RiwayatPage({super.key});

  layout(RiwayatController ctrl, BuildContext context) {
    return SafeArea(
        child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(
                              left: 21, right: 21, top: 21),
                          child: Column(children: [
                            Card(
                              elevation: 0,
                              color: const Color(0xFFF5F5F5),
                              margin: const EdgeInsets.only(top: 20),
                              clipBehavior: Clip.antiAlias,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                                //set border radius more than 50% of height and width to make circle
                              ),
                              child: Container(
                                  width: Get.width,
                                  height: 135,
                                  constraints:
                                      BoxConstraints.loose(Size.infinite),
                                  decoration: const BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              "assets/img/bg_card_riwayat.png"),
                                          fit: BoxFit.fill)),
                                  child: Padding(
                                    padding: EdgeInsets.all(15),
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
                                            Text(
                                              "Bismillah,",
                                              style: context.textTheme.bodySmall
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color: Colors.white),
                                            ),
                                            Text(
                                              "Saya Niatkan untuk Bersedekah",
                                              style: context.textTheme.bodySmall
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color: Colors.white),
                                            )
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Align(
                                                alignment: Alignment.centerLeft,
                                                child: AutoSizeText(
                                                  "Total Sedekah",
                                                  textAlign: TextAlign.start,
                                                  style: context
                                                      .textTheme.bodySmall
                                                      ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.w300,
                                                          color: Colors.white),
                                                  maxLines: 2,
                                                )),
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: AutoSizeText(
                                                priceFormat.format(5000000000),
                                                textAlign: TextAlign.start,
                                                style: context
                                                    .textTheme.titleMedium
                                                    ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        color: Colors.white),
                                                maxLines: 2,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  )), //SizedBox
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: Text("Riwayat",
                                        style: context.textTheme.bodyLarge
                                            ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black))),
                                ButtonIcon(
                                  bgcolor: Theme.of(context).primaryColor,
                                  onTap: () {},
                                  icon: Icon(
                                    Icons.filter_alt_rounded,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            )
                          ])),
                      Container(
                        decoration: BoxDecoration(color: Colors.white),
                        child: Padding(
                            padding: const EdgeInsets.only(
                                left: 21, right: 21, top: 21),
                            child: Column(
                              children: [
                                ListView.builder(
                                  physics: const ClampingScrollPhysics(),
                                  itemCount: ctrl.listRiwayat.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    // Datum model = filteredEvents[index];
                                    return FadeInUp(
                                      child: ListItemUiWidget(
                                        typeDivider: TypeDivider.dashed,
                                        id: ctrl.listRiwayat[index]['id'],
                                        title: priceFormat.format(ctrl
                                                .listRiwayat[index]['title']) +
                                            ',-',
                                        onTap: () {
                                          ctrl.goToDetail(
                                              ctrl.listRiwayat[index]);
                                        },
                                        category: ctrl.listRiwayat[index]
                                            ['category'],
                                        titleStyle: context
                                            .textTheme.titleMedium
                                            ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context)
                                                    .primaryColor),
                                        hasRightContent: true,
                                        showIcon: IconPosition.left,
                                        rightContent: [
                                          Text(ctrl.listRiwayat[index]['type'],
                                              textAlign: TextAlign.end,
                                              style: context.textTheme.bodySmall
                                                  ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              )),
                                          Text(
                                              ctrl.listRiwayat[index]
                                                      ['tanggal'] +
                                                  ", " +
                                                  ctrl.listRiwayat[index]
                                                      ['jam'],
                                              textAlign: TextAlign.end,
                                              style: context.textTheme.bodySmall
                                                  ?.copyWith(
                                                fontWeight: FontWeight.normal,
                                              ))
                                        ],
                                      ),
                                    );
                                  },
                                )
                              ],
                            )),
                      )
                    ]))));
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(RiwayatController());

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      extendBodyBehindAppBar: false,
      resizeToAvoidBottomInset: false,
      body: layout(ctrl, context),
      appBar: AppBarWSWidget.getAppbarWidget(
          title: "Riwayat Sedekah", context: context, elevation: 0),
    );
  }
}
