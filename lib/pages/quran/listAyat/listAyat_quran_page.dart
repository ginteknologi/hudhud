import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:masjid_app/pages/quran/listAyat/listAyat_quran_controller.dart';

class ListAyatQuranPage extends StatelessWidget {
  final ListAyatQuranController ctrl = Get.put(ListAyatQuranController());
  ListAyatQuranPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          return Column(
            children: [
              AutoSizeText(
                  ctrl.detail.isEmpty ? "List Ayat : " : ctrl.detail['nama']),
              AutoSizeText(
                ctrl.detail.isEmpty
                    ? "Total Ayat :"
                    : "Jumlah Ayat : " + ctrl.detail['ayat'].toString(),
                maxLines: 1,
                style: context.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.normal,
                  color: const Color.fromARGB(255, 173, 41, 41),
                ),
              )
            ],
          );
        }),
        actions: [IconButton(icon: Icon(Icons.search), onPressed: () {})],
        elevation: 0,
      ),
      body: Obx(() {
        if (ctrl.isLoadingList.isTrue) {
          return Center(child: CircularProgressIndicator());
        }
        return Column(
          children: [
            Container(
              color: Color(0xFF048C7C),
              child: TabBar(
                indicator: BoxDecoration(
                  border:
                      Border(bottom: BorderSide(color: Colors.white, width: 3)),
                  // color: Colors.orange,
                ),
                labelColor: Colors.white,
                splashBorderRadius: BorderRadius.circular(20),
                unselectedLabelColor: Color(0xFFD0D0D0),
                isScrollable: true,
                controller: ctrl.tabController,
                tabs: ctrl.myTabs.reversed.toList(),
                onTap: (index) {
                  var newindex = ctrl.myTabs.length - index - 1;
                  ctrl.pageController.animateToPage(
                    newindex,
                    duration: Duration(milliseconds: 10),
                    curve: Curves.ease,
                  );
                },
              ),
            ),
            Expanded(
              child: PageView(
                onPageChanged: (index) {
                  var newindex = ctrl.myTabs.length - index - 1;
                  ctrl.changeTabIndex(newindex);
                  ctrl.tabController.animateTo(
                    newindex,
                    duration: Duration(milliseconds: 100),
                    curve: Curves.ease,
                  );
                },
                reverse: true,
                children: ctrl.myTabs.map((tab) {
                  return Obx(() {
                    if (ctrl.isLoadingDetail.isTrue) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return ListView.builder(
                        shrinkWrap: true,
                        primary: true,
                        itemCount: ctrl
                            .contentTab[ctrl.myTabs.indexOf(tab)]['list']
                            .length,
                        itemBuilder: (context, index) {
                          final item = ctrl.contentTab[ctrl.myTabs.indexOf(tab)]
                              ['list'][index];
                          return Column(children: [
                            Container(
                                color: Color.fromARGB(255, 233, 233, 233),
                                child: Row(
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Stack(
                                          children: <Widget>[
                                            SvgPicture.asset(
                                              'assets/icons/list_star.svg',
                                              alignment: Alignment.center,
                                              height: 35,
                                              width: 35,
                                            ),
                                            Positioned.fill(
                                              child: Center(
                                                child: AutoSizeText(
                                                  item['ayat'].toString(),
                                                  maxLines: 1,
                                                  presetFontSizes: [11, 10, 9],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        // Baris kedua
                                        Container(
                                          height: 42,
                                          width: 42,
                                          child: Stack(
                                            children: [],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                        child: Container(
                                      padding: EdgeInsets.all(15),
                                      color: Colors.white,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: Get.height / 100,
                                          ),
                                          Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: AutoSizeText(
                                                  item['madinah']!,
                                                  textAlign: TextAlign.end,
                                                  style: context
                                                      .textTheme.titleMedium
                                                      ?.copyWith(
                                                          fontFamily: GoogleFonts
                                                                  .amiriQuran()
                                                              .fontFamily,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                  maxLines: 15,
                                                ),
                                              ),
                                              SizedBox(
                                                height: Get.height / 100,
                                              ),
                                              Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: AutoSizeText(
                                                    item['latin_karakter']!,
                                                    textAlign: TextAlign.start,
                                                    style: context
                                                        .textTheme.labelMedium
                                                        ?.copyWith(
                                                            fontFamily:
                                                                'Roboto',
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            fontStyle: FontStyle
                                                                .italic),
                                                  )),
                                              SizedBox(
                                                height: Get.height / 100,
                                              ),
                                              Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: AutoSizeText(
                                                    item['arti']['text']!,
                                                    textAlign: TextAlign.start,
                                                    style: context
                                                        .textTheme.labelMedium
                                                        ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w300,
                                                    ),
                                                  ))
                                            ],
                                          )
                                        ],
                                      ),
                                    ))
                                  ],
                                )),
                            Divider(
                              color: Color.fromARGB(255, 226, 226, 226),
                              thickness: 3,
                              height: 2,
                            ),
                          ]);
                        });
                  });
                }).toList(),
                controller: ctrl.pageController,
              ),
            )
          ],
        );
      }),
    );
  }
}
