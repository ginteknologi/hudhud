// ignore_for_file: must_be_immutable

import 'package:auto_size_text/auto_size_text.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:masjid_app/components/button/elevatedbutton.dart';
import 'package:masjid_app/components/button/iconbutton.dart';
import 'package:masjid_app/components/input/InputText.dart';
import 'package:masjid_app/models/listayatData.dart';
import 'package:masjid_app/pages/quran/listAyat/listAyat_quran_controller.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:share_plus/share_plus.dart';

class ListAyatQuranPage extends StatelessWidget {
  @override
  GlobalKey<AutoCompleteTextFieldState<String>> key = GlobalKey();
  final ListAyatQuranController ctrl = Get.put(ListAyatQuranController());

  ListAyatQuranPage({super.key});

  void _showBottomSheet(listayatData item) {
    var data = ctrl.list.where((p0) => p0['id'] == item.surat).toList()[0];
    Get.bottomSheet(
      Container(
        color: Colors.white,
        child: Wrap(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "${data['nama']} ${item.ayat}:${data['ayat']}",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.play_arrow),
              title: Text('Play Murotal'),
              onTap: () {
                ctrl.playMurotal(item);
                Get.back();
              },
            ),
            ListTile(
              leading: Icon(Icons.bookmark),
              title: Text('Bookmark'),
              onTap: () async {
                await ctrl.bookmark(item);
                Get.back();
              },
            ),
            ListTile(
              leading: Icon(Icons.share),
              title: Text('Bagikan Ayat'),
              onTap: () {
                // Lakukan sesuatu saat menu bagikan ayat dipilih
                // Get.back();
                Share.share('${item.arab}\n\n${item.arti}',
                    subject: "${data['nama']} ${data['ayat']}:${item.ayat}");
              },
            ),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  void showDialogFilter() {
    Get.defaultDialog(
      onWillPop: () {
        ctrl.inputSurah.text = "";
        ctrl.inputAyat.text = "";
        return Future.value(true);
      },
      backgroundColor: Colors.transparent,
      barrierDismissible: true,
      radius: 0,
      contentPadding:
          const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 20),
      title: '',
      titleStyle: const TextStyle(height: 0),
      titlePadding: const EdgeInsets.all(0),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Color(0xFF189A8C),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(7), topRight: Radius.circular(7))),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color(0xFF189A8C),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Pergi Ke Ayat',
                    style: Get.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.normal, color: Colors.white),
                  ),
                  ButtonIcon(
                    onTap: () {
                      Get.back();
                      ctrl.inputSurah.text = "";
                      ctrl.inputAyat.text = "";
                    },
                    bgcolor: Colors.transparent,
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
              padding: EdgeInsets.all(Get.width / 40),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SimpleAutoCompleteTextField(
                    key: key,
                    controller: ctrl.inputSurah,
                    suggestions:
                        ctrl.list.map((e) => e['nama'].toString()).toList(),
                    textChanged: (text) {
                      // Handle when text is changed
                    },
                    textSubmitted: (text) {
                      // Handle when text is submitted
                    },
                    clearOnSubmit: false,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide:
                            BorderSide(color: Color(0xFFDCDCDC), width: 1.0),
                      ),
                      fillColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hintText: 'Cari surah',
                      hintStyle: Get.textTheme.bodySmall!.copyWith(
                          color:
                              Get.textTheme.bodySmall!.color!.withValues(alpha: .5)),
                      contentPadding: EdgeInsets.all(13),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  InputText(
                    inputType: TextInputType.number,
                    controller: ctrl.inputAyat,
                    labelPosition: "none",
                    placeholder: "Nomor ayat",
                    isFill: true,
                    placeholderStyle: Get.textTheme.bodySmall,
                    inputAction: TextInputAction.next,
                    onSubmit: (newValue) {},
                    onEditingComplete: () {},
                    onChanged: (newValue) {},
                    validator: (newValue) {
                      if (newValue!.isEmpty) {
                        return "Mohon untuk diisi.";
                      }
                      return null;
                    },
                  ),
                ],
              )),
          Container(
              padding: EdgeInsets.all(Get.width / 40),
              decoration: BoxDecoration(
                color: Color(0xFFDCDCDC),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(7),
                    bottomRight: Radius.circular(7)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ButtonElevated(
                    title: 'Buka Ayat',
                    width: Get.width / 2.5,
                    size: Get.textTheme.bodySmall?.fontSize,
                    bgcolor: Color(0xFF2128C2),
                    height: 30,
                    color: Colors.white,
                    radius: 5,
                    onPressed: () {
                      ctrl.prosesPencarian();
                    },
                  )
                ],
              )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Color(0xFF048C7C),
        title: Obx(() {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AutoSizeText(
                ctrl.detail.isEmpty ? "List Ayat : " : ctrl.detail['nama'],
                textAlign: TextAlign.left,
              ),
              AutoSizeText(
                ctrl.detail.isEmpty
                    ? "Total Ayat :"
                    : "Jumlah Ayat : ${ctrl.detail['ayat']}",
                maxLines: 1,
                textAlign: TextAlign.left,
                style: context.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.normal,
                  color: const Color.fromARGB(255, 173, 41, 41),
                ),
              )
            ],
          );
        }),
        actions: [
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showDialogFilter();
              })
        ],
        elevation: 0,
      ),
      body: Obx(() {
        if (ctrl.isLoadingList.isTrue) {
          return Center(child: CircularProgressIndicator());
        }
        return Column(
          children: [
            Container(
              decoration: BoxDecoration(color: Color(0xFF048C7C), boxShadow: [
                BoxShadow(
                    color: Colors.black12, spreadRadius: 10, blurRadius: 15)
              ]),
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
            Container(
              padding: EdgeInsets.all(Get.width / 40),
              decoration: BoxDecoration(color: Color(0xFF20B3A3)),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      if (ctrl.listAudio.isNotEmpty) {
                        if (ctrl.isPlaySound.isTrue) {
                          ctrl.isPlaySound.value = false;
                          ctrl.player.pause();
                        } else {
                          ctrl.isPlaySound.value = true;
                          ctrl.player.play();
                        }
                      } else {
                        // print(ctrl.detail);
                        // print();
                        var getlist = ctrl.contentTab
                            .where((element) =>
                                element['idContent'] == ctrl.detail['id'])
                            .toList();
                        ctrl.playMurotal(getlist[0]["list"][0]);
                      }
                    },
                    icon: Icon(
                      ctrl.isPlaySound.isTrue ? Icons.pause : Icons.play_arrow,
                    ),
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: Get.width / 20,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${ctrl.detail['nama']}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: Get.width / 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                            "${ctrl.detail['ayat']} Ayat - ${ctrl.detail['tipe']} ",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: Get.width / 30,
                            )),
                      ],
                    ),
                  ),
                  Text("${ctrl.detail['arab']}",
                      style: TextStyle(
                        color: Colors.white,
                      )),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
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
                itemCount: ctrl.myTabs.length,
                itemBuilder: (context, index) {
                  return Obx(() {
                    final banyakAyat = ctrl.contentTab[index]['list'].length;
                    final indexPage = index;
                    if (ctrl.isLoadingDetail.isTrue) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return listAyat(banyakAyat, indexPage,
                        ctrl.itemScrollController[index]);
                  });
                },
                controller: ctrl.pageController,
              ),
            )
          ],
        );
      }),
    );
  }

  ScrollablePositionedList listAyat(banyakAyat, int indexPage, itemScrollController) {
    return ScrollablePositionedList.builder(
        itemScrollController: itemScrollController,
        // itemPositionsListener: ctrl.itemPositionsListener,
        // scrollOffsetController: ctrl.scrollOffsetController,
        shrinkWrap: true,
        // primary: true,
        itemCount: banyakAyat,
        itemBuilder: (context, index) {
          final listayatData item = ctrl.contentTab[indexPage]['list'][index];
          return InkWell(
            onTap: () {
              _showBottomSheet(item);
            },
            child: Stack(
              fit: StackFit.passthrough,
              children: [
                Column(children: [
                  Container(
                      color: Color.fromARGB(255, 233, 233, 233),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(Get.width / 40),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
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
                                          item.ayat.toString(),
                                          maxLines: 1,
                                          presetFontSizes: [11, 10, 9],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                // Baris kedua
                                SizedBox(
                                  height: 42,
                                  width: 42,
                                  child: Stack(
                                    children: [],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                              child: Container(
                            padding: EdgeInsets.all(15),
                            color: Colors.white,
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: Get.height / 50,
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: AutoSizeText(
                                        item.madinah,
                                        textAlign: TextAlign.end,
                                        style: context.textTheme.titleMedium
                                            ?.copyWith(
                                                fontFamily:
                                                    GoogleFonts.amiriQuran()
                                                        .fontFamily,
                                                fontWeight: FontWeight.bold),
                                        maxLines: 15,
                                      ),
                                    ),
                                    SizedBox(
                                      height: Get.height / 50,
                                    ),
                                    Align(
                                        alignment: Alignment.centerLeft,
                                        child: AutoSizeText(
                                          item.latin_karakter,
                                          textAlign: TextAlign.start,
                                          style: context.textTheme.labelMedium
                                              ?.copyWith(
                                                  fontFamily: 'Roboto',
                                                  fontWeight: FontWeight.w300,
                                                  fontStyle: FontStyle.italic),
                                        )),
                                    SizedBox(
                                      height: Get.height / 50,
                                    ),
                                    Align(
                                        alignment: Alignment.centerLeft,
                                        child: AutoSizeText(
                                          item.arti,
                                          textAlign: TextAlign.start,
                                          style: context.textTheme.labelMedium
                                              ?.copyWith(
                                            fontWeight: FontWeight.w300,
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
                ]),
                if (item.book.isTrue) ...[
                  Positioned(
                    top: -4,
                    left: Get.width * 0.12,
                    child: Icon(
                      Icons.bookmark,
                      color: Colors.red,
                      size: Get.width * 0.09,
                    ),
                  ),
                ]
              ],
            ),
          );
        });
  }
}
