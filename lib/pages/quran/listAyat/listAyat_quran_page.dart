// ignore_for_file: unnecessary_null_comparison
import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:masjid_app/components/input/InputText.dart';
import 'package:masjid_app/components/layout/app_bar_ws.dart';
import 'package:masjid_app/components/layout/custom_modal_bottom_sheet.dart';
import 'package:masjid_app/components/partial/list_ui.dart';
import 'package:masjid_app/configs/main_controller.dart';
import 'package:masjid_app/pages/quran/listAyat/listAyat_quran_controller.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_audio/just_audio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:masjid_app/components/button/iconbutton.dart';
import 'package:masjid_app/components/button/elevatedbutton.dart';

class ListAyatQuranPage extends StatelessWidget {
  ListAyatQuranPage({super.key});
  final dataStore = GetStorage();

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
    RxList<Duration?> audioPosition =
        RxList<Duration?>.generate(ctrl.detail['ayat'], (index) => null);
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
                              : ctrl.detail['nama'],
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
                        var item = ctrl.listAyat[index];
                        return FadeInUp(
                          child: Obx(
                            () => ctrl.isLoadingDetail.value
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : Column(
                                    children: [
                                      Container(
                                        width: Get.width,
                                        color:
                                            Color.fromARGB(255, 233, 233, 233),
                                        constraints:
                                            BoxConstraints.loose(Size.infinite),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 50,
                                              padding: EdgeInsets.only(
                                                  left: 15, right: 15),
                                              constraints: BoxConstraints.loose(
                                                  Size.infinite),
                                              color: Color.fromARGB(
                                                  255, 233, 233, 233),
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Column(
                                                  children: <Widget>[
                                                    Container(
                                                      height: 42,
                                                      width: 42,
                                                      child: Stack(
                                                        children: <Widget>[
                                                          InkWell(
                                                            onTap: () {
                                                              print(
                                                                dataStore.read(
                                                                  'perAyatLastRead',
                                                                ),
                                                              );
                                                              surahBookmarked[
                                                                  index] = dataStore
                                                                              .read('perAyatLastRead')[
                                                                          'ayatNumber'] ==
                                                                      item[
                                                                          'ayat']
                                                                  ? true
                                                                  : false;
                                                              ctrl.bookmark(
                                                                item,
                                                                surahBookmarked[
                                                                    index],
                                                                index,
                                                              );
                                                            },
                                                            child: dataStore.read('perAyatLastRead')[
                                                                            'ayatNumber'] ==
                                                                        item[
                                                                            'ayat'] &&
                                                                    ctrl.detail[
                                                                            'id'] ==
                                                                        dataStore
                                                                            .read(
                                                                          'perAyatLastRead',
                                                                        )['id']
                                                                ? SvgPicture
                                                                    .asset(
                                                                    'assets/icons/active_bookmark.svg',
                                                                    width: 28,
                                                                    height: 28,
                                                                  )
                                                                : SvgPicture
                                                                    .asset(
                                                                    'assets/icons/bookmark.svg',
                                                                    width: 28,
                                                                    height: 28,
                                                                  ),
                                                          ),
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
                                                            alignment: Alignment
                                                                .center,
                                                            width: 42,
                                                            height: 42,
                                                          ),
                                                          Positioned.fill(
                                                            child: Center(
                                                              child: Text(
                                                                item['ayat']
                                                                    .toString(),
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
                                                                  if (audioPlayer
                                                                          .position ==
                                                                      null) {
                                                                    print(
                                                                        "clicked play position null");
                                                                    audioPlayer
                                                                        .setUrl(
                                                                      item['audio']
                                                                          [
                                                                          'primary']!,
                                                                    );
                                                                    audioPlayer
                                                                        .play();
                                                                    onplay[index] =
                                                                        true;
                                                                  } else if (onplay[
                                                                      index]) {
                                                                    print(
                                                                        "clicked pause");
                                                                    audioPosition[
                                                                            index] =
                                                                        audioPlayer
                                                                            .position;
                                                                    audioPlayer
                                                                        .pause();
                                                                    onplay[index] =
                                                                        false;
                                                                  } else {
                                                                    print(
                                                                        "clicked play");
                                                                    if (audioPosition[
                                                                            index] !=
                                                                        null) {
                                                                      audioPlayer
                                                                          .seek(
                                                                        audioPosition[
                                                                            index]!,
                                                                      );
                                                                    } else {
                                                                      audioPlayer
                                                                          .setUrl(
                                                                        item['audio']
                                                                            [
                                                                            dataStore.read(
                                                                          'perAyatLastRead',
                                                                        )['audio']]!,
                                                                      );
                                                                    }
                                                                    onplay[index] =
                                                                        true;
                                                                    audioPlayer
                                                                        .play();
                                                                    audioPlayer
                                                                        .playerStateStream
                                                                        .listen(
                                                                      (PlayerState
                                                                          state) {
                                                                        if (state.processingState ==
                                                                            ProcessingState.completed) {
                                                                          // File selesai diputar
                                                                          print(
                                                                              "Selesai");
                                                                          audioPosition[index] =
                                                                              null;
                                                                          onplay[index] =
                                                                              false;
                                                                        }
                                                                      },
                                                                    );
                                                                  }
                                                                },
                                                                child: Obx(
                                                                  () => onplay[
                                                                          index]
                                                                      ? Icon(
                                                                          Icons
                                                                              .pause_rounded,
                                                                          color:
                                                                              Theme.of(context).primaryColor,
                                                                        )
                                                                      : Icon(
                                                                          Icons
                                                                              .play_arrow_rounded,
                                                                          color:
                                                                              Theme.of(context).primaryColor,
                                                                        ),
                                                                ),
                                                              ),
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
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      height: 20,
                                                    ),
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
                                                              fontFamily:
                                                                  'Roboto',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                            maxLines: 15,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 20,
                                                        ),
                                                        Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: AutoSizeText(
                                                            item[
                                                                'latin_karakter']!,
                                                            textAlign:
                                                                TextAlign.start,
                                                            style: context
                                                                .textTheme
                                                                .labelMedium
                                                                ?.copyWith(
                                                              fontFamily:
                                                                  'Roboto',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300,
                                                              fontStyle:
                                                                  FontStyle
                                                                      .italic,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 20,
                                                        ),
                                                        Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: AutoSizeText(
                                                            item['arti']
                                                                ['text']!,
                                                            textAlign:
                                                                TextAlign.start,
                                                            style: context
                                                                .textTheme
                                                                .labelMedium
                                                                ?.copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300,
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Divider(
                                        color:
                                            Color.fromARGB(255, 226, 226, 226),
                                        thickness: 3,
                                        height: 2,
                                      ),
                                    ],
                                  ),
                          ),
                        );
                      },
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

  showDialogFilter(ListAyatQuranController ctrl, BuildContext context, flag) {
    Get.defaultDialog(
      backgroundColor: Colors.transparent,
      barrierDismissible: true,
      radius: 7,
      contentPadding:
          const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 20),
      title: '',
      titleStyle: const TextStyle(height: 0),
      titlePadding: const EdgeInsets.all(0),
      content: Column(
        children: [
          Container(
            width: Get.width - 25,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Color(0xFF189A8C),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(7), topRight: Radius.circular(7))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Pergi Ke',
                  // "Q.S Al-Muthaffifiin :  34",
                  style: Get.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.normal, color: Colors.white),
                ),
                ButtonIcon(
                  onTap: () {
                    Get.back();
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
          Obx(() => ctrl.loadingFilter == true
              ? Text("data")
              : Container(
                  width: Get.width - 25,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(7),
                          bottomRight: Radius.circular(7))),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      ButtonElevated(
                        title: 'Ayat',
                        width: Get.width / 3.5,
                        bgcolor: Get.theme.primaryColor,
                        height: 30,
                        color: Colors.white,
                        radius: 5,
                        onPressed: () {},
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: Get.width / 3,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Autocomplete<Map<String, dynamic>>(
                                    optionsBuilder:
                                        (TextEditingValue textEditingValue) {
                                      final query =
                                          textEditingValue.text.toLowerCase();
                                      return ctrl.list
                                          .where((data) => data['nama']
                                              .toString()
                                              .toLowerCase()
                                              .contains(query))
                                          .map((data) =>
                                              data as Map<String, dynamic>)
                                          .toList();
                                    },
                                    onSelected:
                                        (Map<String, dynamic> selectedValue) {
                                      final selectedItem = ctrl.getSelectedItem(
                                          selectedValue['nama']);
                                      if (selectedItem != null) {
                                        // Lakukan sesuatu dengan objek yang dipilih
                                        print('Selected: $selectedItem');
                                        ctrl.inputSurah.value = selectedItem;
                                      }
                                    },
                                    fieldViewBuilder: (BuildContext context,
                                        TextEditingController
                                            textEditingController,
                                        FocusNode focusNode,
                                        VoidCallback onFieldSubmitted) {
                                      textEditingController.addListener(() {
                                        ctrl.search(textEditingController.text);
                                      });
                                      return TextField(
                                        controller: textEditingController,
                                        focusNode: focusNode,
                                        decoration: InputDecoration(
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            borderSide: BorderSide(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onBackground
                                                    .withOpacity(.1)),
                                          ),
                                          fillColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          hintText: 'Cari surah',
                                          hintStyle: Get.textTheme.bodySmall!
                                              .copyWith(
                                                  color: Get.textTheme
                                                      .bodySmall!.color!
                                                      .withOpacity(.5)),
                                          contentPadding: EdgeInsets.all(10.0),
                                          border: OutlineInputBorder(),
                                        ),
                                      );
                                    },
                                    displayStringForOption:
                                        (Map<String, dynamic> option) =>
                                            option['nama'].toString(),
                                  ),
                                ),
                              ],
                            ),
                            // child: InputText(
                            //   controller: ctrl.inputFilterSurah,
                            //   labelPosition: "none",
                            //   placeholder: "Cari Surah",
                            //   textAlign: TextAlign.center,
                            //   isFill: true,
                            //   placeholderStyle: Get.textTheme.bodyMedium,
                            //   inputAction: TextInputAction.next,
                            //   onSubmit: (newValue) {},
                            //   onEditingComplete: () {},
                            //   onChanged: (newValue) {},
                            //   validator: (newValue) {
                            //     if (newValue!.isEmpty) {
                            //       return "Mohon untuk diisi.";
                            //     }
                            //     return null;
                            //   },
                            // ),
                          ),
                          Container(
                            width: Get.width / 3,
                            child: InputText(
                              inputType: TextInputType.number,
                              controller: ctrl.inputFilterAyat,
                              labelPosition: "none",
                              placeholder: "Nomor ayat",
                              textAlign: TextAlign.center,
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
                          ),
                        ],
                      ),
                      ctrl.textError.value.isEmpty
                          ? Container()
                          : Container(
                              width: Get.width - 25,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(ctrl.textError.value,
                                      style: Get.textTheme.bodySmall
                                          ?.copyWith(color: Colors.red))
                                ],
                              ),
                            ),
                      Container(
                        width: Get.width - 25,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 15),
                        decoration: BoxDecoration(
                            color: Color(0xFFDCDCDC),
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(7),
                                bottomRight: Radius.circular(7))),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ButtonElevated(
                                title: 'Buka Ayat',
                                width: Get.width / 2.5,
                                // width: 160,
                                size: Get.textTheme.bodySmall?.fontSize,
                                bgcolor: Color(0xFF2128C2),
                                height: 30,
                                color: Colors.white,
                                radius: 5,
                                onPressed: () {
                                  if (ctrl.inputSurah.isEmpty) {
                                    ctrl.textError.value = 'Pilih Surah !';
                                  } else {
                                    if (ctrl.inputFilterAyat.text.isNotEmpty) {
                                      if (int.parse(ctrl.inputFilterAyat.text) > ctrl.inputSurah['ayat']) {
                                        ctrl.textError.value = 'Maks Ayat ${ctrl.inputSurah['ayat']}';
                                      }else{
                                        ctrl.textError.value = '';  
                                        ctrl.dataGoTo(ctrl.inputSurah, ctrl.inputFilterAyat.text);
                                        Navigator.pop(context);
                                      }
                                    }else{
                                      ctrl.textError.value = 'Masukan Ayat !';
                                    }
                                  }
                                  // ctrl.dataGoTo(ctrl.inputSurah, ctrl.inputFilterAyat.text);
                                },
                              ),
                            ]),
                      ),
                    ],
                  ))),
        ],
      ),
    );
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
                                  showDialogFilter(ctrl, context, false);
                                },
                                borderRadius: BorderRadius.circular(20),
                                splashColor: Colors.green.withOpacity(0.5),
                                child: const Icon(
                                  Icons.tune_rounded,
                                  color: Colors.white,
                                ),
                              ),
                            ))),
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
