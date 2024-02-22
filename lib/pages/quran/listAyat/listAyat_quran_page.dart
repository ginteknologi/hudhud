// ignore_for_file: unnecessary_null_comparison

import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:masjid_app/components/input/InputText.dart';
import 'package:masjid_app/components/layout/app_bar_ws.dart';
import 'package:masjid_app/components/layout/custom_modal_bottom_sheet.dart';
import 'package:masjid_app/components/partial/list_ayat.dart';
import 'package:masjid_app/components/partial/list_ui.dart';
import 'package:masjid_app/configs/main_controller.dart';
import 'package:masjid_app/pages/quran/listAyat/listAyat_quran_controller.dart';
// import 'package:masjid_app/theme.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_audio/just_audio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ListAyatQuranPage extends StatelessWidget {
  ListAyatQuranPage({super.key});
  final dataStore = GetStorage();
  // final ItemScrollController itemScrollController = ItemScrollController();
  // void scrollToIndex(
  //     BuildContext context, ListAyatQuranController ctrl, int index) {
  //   ctrl.isLoadingDetail.value == true;
  //   ctrl.isLoadingList.value == true;
  //   if (itemScrollController != null && itemScrollController.isAttached) {
  //     itemScrollController.scrollTo(
  //       index: index - 1,
  //       duration: Duration(milliseconds: 500),
  //       curve: Curves.easeInOut,
  //     );
  //     ctrl.isLoadingDetail.value = false;
  //   ctrl.isLoadingList.value == false;
  //   } else {
  //     print('ScrollController tidak berhasil diperoleh');
  //     Timer(Duration(seconds: 1), () {
  //       // Tunggu 1 detik (bisa disesuaikan) dan lakukan scrollToIndex lagi
  //       scrollToIndex(context, ctrl, index);
  //     });
  //   }
  // }

  tabMaker(data) {
    List<Tab> tabs = [];
    for (var i = 0; i < data.length; i++) {
      tabs.add(Tab(
        text: data[i]['nama'],
      ));
    }
    return tabs;
  }

  listTabs(ListAyatQuranController ctrl, MainController gctrl,
      BuildContext context) {
    return PreferredSize(
        child: Obx(() => ctrl.isLoadingList.value
            ? const Center(child: CircularProgressIndicator())
            : TabBar(
                onTap: (selectedIndex) async {
                  await ctrl.getDetailData(ctrl.list[selectedIndex]['id']);
                },
                isScrollable: true,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white.withOpacity(0.3),
                indicatorSize: TabBarIndicatorSize.label,
                controller: ctrl.tabController,
                tabs: tabMaker(ctrl.list))),
        preferredSize: Size.fromHeight(40.0));
  }

  tabContent(ListAyatQuranController ctrl, MainController gctrl,
      BuildContext context) {
    return TabBarView(
      physics: const NeverScrollableScrollPhysics(),
      controller: ctrl.tabController,
      children: <Widget>[
        for (var i in ctrl.list)
          Obx(() => ctrl.isLoadingDetail.value
              ? const Center(child: CircularProgressIndicator())
              : listAyat(ctrl, gctrl, context))
      ],
    );
  }

  listAyat(ListAyatQuranController ctrl, MainController gctrl,
      BuildContext context) {
    AudioPlayer audioPlayer = AudioPlayer();
    // List<List<int>> onplay = List.generate(ctrl.detail['numberOfVerses'], (index) => []);
    RxList<bool> onplay =
        RxList<bool>.generate(ctrl.detail['ayat'], (index) => false);
    RxList<bool> surahBookmarked =
        RxList<bool>.generate(ctrl.detail['ayat'], (index) => false);
    RxList<Duration?> audioPosition = RxList<Duration?>.generate(
        ctrl.detail['ayat'], (index) => null);
    // var onplay = [].obs;
    // Duration? audioPosition;
// WidgetsBinding.instance.addPostFrameCallback((_) {
//       print(dataStore.read('perAyatLastRead')['suratName']);
//       print(ctrl.detail['name']['transliteration']['id']);
//       if (ctrl.isLoadingDetail.value) {
//         if (dataStore.read('perAyatLastRead')['suratName'] ==
//             ctrl.detail['name']['transliteration']['id']) {
//           scrollToIndex(
//               context,
//               ctrl,
//               dataStore.read('perAyatLastRead')[
//                   'ayatNumber']); // Ganti 5 dengan indeks yang diinginkan
//         }
//       }
//     });
    return Obx(() => !ctrl.isLoadingDetail.value
        ? Container(
            constraints: BoxConstraints.loose(Size.infinite),
            child: Column(
              children: [
                Container(
                  width: Get.width,
                  height: 55,
                  padding: EdgeInsets.symmetric(horizontal: 21, vertical: 5),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color(0xFF189A8C),
                          Color(0xFF20B3A3),
                        ]),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoSizeText(
                            ctrl.detail.isEmpty
                                ? "List Ayat : "
                                : ctrl.detail['nama'],
                            maxLines: 1,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.fontSize,
                            ),
                          ),
                          AutoSizeText(
                            ctrl.detail.isEmpty
                                ? "List Ayat : "
                                : ctrl.detail['ayat'].toString() +
                                    ' Ayat - ' +
                                    ctrl.detail['tipe'],
                            maxLines: 1,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.fontSize),
                          )
                        ],
                      ),
                      AutoSizeText(
                          ctrl.detail.isEmpty
                              ? "List Ayat : "
                              : ctrl.detail['nama'] ,
                          maxLines: 1,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.fontSize))
                    ],
                  ),
                ),
                Container(
                    width: Get.width,
                    height: MediaQuery.of(context).size.height -
                        kBottomNavigationBarHeight -
                        kToolbarHeight -
                        kTextTabBarHeight -
                        17,
                    padding: EdgeInsets.symmetric(horizontal: 0),
                    child: ScrollablePositionedList.builder(
                      itemScrollController: ctrl.itemScrollController,
                      itemCount: ctrl.detail['ayat'],
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        // Datum model = filteredEvents[index];
                        var item = ctrl.listAyat[index];
                        return FadeInUp(
                            child: Obx(() => ctrl.isLoadingDetail.value
                                    ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : Column(children: [
                                        Container(
                                            width: Get.width,
                                            // height: 210,
                                            color: Color.fromARGB(
                                                255, 233, 233, 233),
                                            constraints: BoxConstraints.loose(
                                                Size.infinite),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 50,
                                                  padding: EdgeInsets.only(
                                                      left: 15, right: 15),
                                                  constraints:
                                                      BoxConstraints.loose(
                                                          Size.infinite),
                                                  color: Color.fromARGB(
                                                      255, 233, 233, 233),
                                                  child: Align(
                                                    alignment: Alignment
                                                        .center, // Align the content vertically center
                                                    child: Column(
                                                      children: <Widget>[
                                                        // Baris pertama
                                                        Container(
                                                          height: 42,
                                                          width: 42,
                                                          child: Stack(
                                                            children: <Widget>[
                                                              InkWell(
                                                                  onTap: () {
                                                                    print(dataStore.read('perAyatLastRead'));
                                                                    surahBookmarked[index] = dataStore.read('perAyatLastRead')['ayatNumber'] == item['ayat']  ? true : false;
                                                                    ctrl.bookmark( item, surahBookmarked[ index], index);
                                                                  },
                                                                  child: dataStore.read('perAyatLastRead')['ayatNumber'] == item['ayat'] &&
                                                                          ctrl.detail['id'] == dataStore.read('perAyatLastRead')['id']
                                                                      ? SvgPicture.asset(
                                                                          'assets/icons/active_bookmark.svg',
                                                                          width:
                                                                              28,
                                                                          height:
                                                                              28)
                                                                      : SvgPicture.asset(
                                                                          'assets/icons/bookmark.svg',
                                                                          width:
                                                                              28,
                                                                          height:
                                                                              28)),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          height: 42,
                                                          width: 42,
                                                          child: Stack(
                                                            children: <Widget>[
                                                              SvgPicture.asset(
                                                                'assets/icons/list_star.svg',
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                width: 42,
                                                                height: 42,
                                                              ),
                                                              Positioned.fill(
                                                                child: Center(
                                                                  child: Text(
                                                                    item['ayat'].toString(),
                                                                    style: context
                                                                        .textTheme
                                                                        .bodySmall
                                                                        ?.copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        // Baris kedua
                                                        Container(
                                                          height: 42,
                                                          width: 42,
                                                          child: Stack(
                                                            children: [
                                                              Positioned.fill(
                                                                child: Center(
                                                                  child: InkWell(
                                                                      onTap: () {
                                                                        print(
                                                                            audioPosition);
                                                                        if (audioPlayer.position == null) {
                                                                          print(
                                                                              "clicked play position null");
                                                                          audioPlayer.setUrl(item['audio']
                                                                              [
                                                                              'primary']!);
                                                                          audioPlayer
                                                                              .play();
                                                                          onplay[index] =
                                                                              true;
                                                                        } else if (onplay[
                                                                            index]) {
                                                                          print(
                                                                              "clicked pause");
                                                                          audioPosition[index] =
                                                                              audioPlayer.position;
                                                                          audioPlayer
                                                                              .pause();
                                                                          onplay[index] =
                                                                              false;
                                                                        } else {
                                                                          print(
                                                                              "clicked play");
                                                                          if (audioPosition[index] !=
                                                                              null) {
                                                                            audioPlayer.seek(audioPosition[index]!);
                                                                          } else {
                                                                            audioPlayer.setUrl(item['audio'][dataStore.read('perAyatLastRead')['audio']]!);
                                                                          }
                                                                          onplay[index] =
                                                                              true;
                                                                          audioPlayer
                                                                              .play();
                                                                          audioPlayer
                                                                              .playerStateStream
                                                                              .listen((PlayerState state) {
                                                                            if (state.processingState == ProcessingState.completed) {
                                                                              // File selesai diputar
                                                                              print("Selesai");
                                                                              audioPosition[index] = null;
                                                                              onplay[index] = false;
                                                                            }
                                                                          });
                                                                        }
                                                                      },
                                                                      child: Obx(
                                                                        () => onplay[index]
                                                                            ? Icon(
                                                                                Icons.pause_rounded,
                                                                                color: Theme.of(context).primaryColor,
                                                                              )
                                                                            : Icon(
                                                                                Icons.play_arrow_rounded,
                                                                                color: Theme.of(context).primaryColor,
                                                                              ),
                                                                      )),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                    child: Container(
                                                  padding: EdgeInsets.all(15),
                                                  color: Colors.white,
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      // Container(
                                                      //   height: 500,
                                                      //   decoration:
                                                      //       BoxDecoration(color: Colors.red),
                                                      // )
                                                      Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Align(
                                                            alignment: Alignment
                                                                .centerRight,
                                                            child: AutoSizeText(
                                                              item['madinah']!,
                                                              textAlign:
                                                                  TextAlign.end,
                                                              style: context
                                                                  .textTheme
                                                                  .titleMedium
                                                                  ?.copyWith(
                                                                      fontFamily: 'Roboto',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                              maxLines: 15,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 20,
                                                          ),
                                                          Align(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child:
                                                                  AutoSizeText(
                                                                item['latin_karakter']!,
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                style: context
                                                                    .textTheme
                                                                    .labelMedium
                                                                    ?.copyWith(
                                                                      fontFamily: 'Roboto',
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w300,
                                                                        fontStyle:
                                                                            FontStyle.italic),
                                                              )),
                                                          SizedBox(
                                                            height: 20,
                                                          ),
                                                          Align(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child:
                                                                  AutoSizeText(
                                                                item['arti']['text']!,
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
                                          color: Color.fromARGB(
                                              255, 226, 226, 226),
                                          thickness: 3,
                                          height: 2,
                                        ),
                                      ])
                                // ListAyatWidget(
                                //     id: item['number']['inSurah'],
                                //     ayat: item['text']['arab'],
                                //     descEN: item['text']['transliteration']['en'],
                                //     descIDN: item['translation']['id'],
                                // bookmarked: ctrl.surahBookmarked.value
                                //     ? gctrl.perAyatLastRead['ayatNumber'] ==
                                //             item['number']['inSurah']
                                //         ? true
                                //         : false
                                //     : false,
                                //     nomor: item['number']['inSurah'].toString(),
                                //     audioFile: item['audio']['primary'],
                                //     onTap: () {
                                //       ctrl.ayatBookmarked.value =
                                //           gctrl.perAyatLastRead['ayatNumber'] ==
                                //                   item['number']['inSurah']
                                //               ? true
                                //               : false;
                                //       ctrl.bookmark(item, index);
                                //     },
                                //   ),
                                )
                                );
                      },
                      // OnEndReached: () => ctrl.getDetailData(ctrl.detail[])
                    ))
              ],
            ),
          )
        : const Center(
            child: CircularProgressIndicator(),
          ));
  }

  void showPopup(ListAyatQuranController ctrl, BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        showDragHandle: false,
        enableDrag: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(0.0),
          ),
        ),
        builder: (BuildContext bc) {
          return CustomModalBottomSheet(
            typeSheet: TypeBottomSheet.typeFullscreenSheet,
            content: [
              InputText(
                suffixIcon: Icon(Icons.search),
                labelPosition: 'none',
                placeholder: 'Cari',
                radius: 5,
                isFill: true,
                fillColor: Colors.white,
                placeholderStyle: Theme.of(context).textTheme.bodyMedium,
                inputPadding: const EdgeInsets.all(15),
                controller: ctrl.searchController,
                onSubmit: (newValue) {},
                onEditingComplete: () {},
                onChanged: (newValue) {
                  ctrl.getDataSearch();
                },
                validator: (newValue) {
                  if (newValue!.isEmpty) {
                    return "Mohon untuk diisi.";
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 30,
                child: Text(
                  "Surah".tr,
                  textAlign: TextAlign.start,
                  style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height -
                    kBottomNavigationBarHeight -
                    kToolbarHeight -
                    60,
                child: ListView.builder(
                  physics: const ClampingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: ctrl.listReverse.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    // Datum model = filteredEvents[index];
                    var item = ctrl.listReverse[index];
                    return FadeInUp(
                      child: ListItemUiWidget(
                        showIcon: IconPosition.left,
                        iconLeft: Text(item['id'].toString()),
                        id: item['id'],
                        title: item['nama'],
                        subTitle: item['arti'] +
                            ' - ' +
                            item['ayat'].toString() +
                            ' Ayat',
                        onTap: () {
                          Navigator.pop(context);
                        },
                        titleStyle: context.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    );
                  },
                ),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(ListAyatQuranController());
    final gctrl = Get.find<MainController>();

    return WillPopScope(
        onWillPop: () async {
          // Logika yang dijalankan saat tombol kembali ditekan
          Get.back(result: 'refresh');
          return false; // Kembalikan false agar tidak melakukan pop secara otomatis
        },
        child: Theme(
          data: Theme.of(context).copyWith(
            tabBarTheme: TabBarTheme.of(context).copyWith(
              indicator: const UnderlineTabIndicator(
                borderSide: BorderSide(
                  color: Colors.white,
                  width: 4.0,
                ),
              ),
            ),
          ),
          child: Obx(
            () => ctrl.detail.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : Scaffold(
                    backgroundColor: Color(0xFFF5F5F5),
                    extendBodyBehindAppBar: false,
                    resizeToAvoidBottomInset: false,
                    appBar: AppBarWSWidget.getAppbarWidget(
                        title: ctrl.detail.isEmpty
                            ? "List Ayat : "
                            : ctrl.detail['nama'],
                        subtitle: AutoSizeText(
                          ctrl.detail.isEmpty
                              ? "Total Ayat :"
                              : "Jumlah Ayat : " +
                                  ctrl.detail['ayat'].toString(),
                          maxLines: 1,
                          style: context.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                          ),
                        ),
                        haveSubtitle: true,
                        context: context,
                        iconTheme: IconThemeData(color: Colors.white),
                        elevation: 0,
                        color: Colors.white,
                        titleAlign: Alignment.centerLeft,
                        backgroundColor: Color(0xFF048C7C),
                        bottom: listTabs(ctrl, gctrl, context),
                        iconRight: Material(
                            color: Colors.transparent,
                            child: Padding(
                              padding: EdgeInsets.only(right: 21),
                              child: InkWell(
                                onTap: () {
                                  gctrl.showDialogFilter(false);
                                },
                                borderRadius: BorderRadius.circular(20),
                                splashColor: Colors.green.withOpacity(0.5),
                                child: const Icon(
                                  Icons.tune_rounded,
                                  color: Colors.white,
                                ),
                              ),
                            ))
                        // onTap: () => {showPopup(ctrl, context)},
                        ),
                    body: Obx(
                      () => ctrl.isLoadingList.value
                          ? const Center(child: CircularProgressIndicator())
                          : tabContent(ctrl, gctrl, context),
                    ),
                  ),
          ),
        ));
  }
}
