import 'package:animate_do/animate_do.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:masjid_app/components/button/elevatedbutton.dart';
import 'package:masjid_app/components/input/input_text.dart';
import 'package:masjid_app/components/layout/custom_modal_bottom_sheet.dart';
import 'package:masjid_app/components/partial/list_ui.dart';
import 'package:masjid_app/controllers/home_controller.dart';
import 'package:masjid_app/pages/quran/halaman_tajwid/component/image_viewer_widget.dart';
import 'package:masjid_app/pages/quran/halaman_tajwid/halaman_quran_tajwid_controller.dart';
import 'package:masjid_app/components/button/iconbutton.dart';

class HalamanQuranTajwidPage extends StatefulWidget {
  const HalamanQuranTajwidPage({super.key});

  @override
  State<HalamanQuranTajwidPage> createState() => _HalamanQuranTajwidPageState();
}

class _HalamanQuranTajwidPageState extends State<HalamanQuranTajwidPage>
    with SingleTickerProviderStateMixin {
  SafeArea layout(HalamanQuranTajwidController ctrl, BuildContext context,
      HomeController ctrlHome) {
    return SafeArea(
        child: Obx(() => ctrl.isLoadingList.value
            ? const Center(child: CircularProgressIndicator())
            : Container(
                constraints: BoxConstraints.loose(Size.infinite),
                child: Stack(
                  children: [
                    GestureDetector(
                        // onTap: () {
                        //   setState(() {
                        //     _visible = !_visible;
                        //     _show = !_show;
                        //   });
                        //   ctrlHome.visible.value = !ctrlHome.visible.value;
                        // },
                        child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                            child: EasyImageViewPager(
                                onTap: (int index) {
                                  showPopup(ctrl, context, ctrlHome);
                                },
                                // search: ctrl.toSurat > 0 ? true : false,
                                idxInitial: ctrl.toSurat > 0
                                    ? ctrl.toSurat
                                    : ctrl.lastReadPerhalaman['hal'],
                                imageProviders: ctrl.listSurah)),
                      ],
                    ))
                  ],
                ))));
  }

  void showPopup(
    HalamanQuranTajwidController ctrl,
    BuildContext context,
    HomeController ctrlHome,
  ) {
    showDialog(
        context: context,
        builder: (BuildContext bc) {
          return Dialog(
            elevation: 0,
            backgroundColor: Color(0xFFDADADA),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7.0)),
            child: Container(
                padding: EdgeInsets.all(10),
                height: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ButtonElevated(
                      title: 'Tandai Halaman ini',
                      width: Get.width,
                      bgcolor: Theme.of(bc).primaryColor,
                      height: 45,
                      color: Colors.white,
                      radius: 7,
                      shadow: false,
                      onPressed: () {
                        Navigator.pop(context);
                        ctrl.bookmarked.value = !ctrl.bookmarked.value;
                        ctrl.bookmark();
                      },
                    ),
                  ],
                )),
          );
        });
  }

  void showModal(HalamanQuranTajwidController ctrl, BuildContext context) {
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
                  child: Obx(
                    () => ctrl.isLoadingList.value
                        ? const Center(child: CircularProgressIndicator())
                        : ListView.builder(
                            physics: const ClampingScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemCount: ctrl.list.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              // Datum model = filteredEvents[index];
                              var item = ctrl.list[index];
                              return FadeInUp(
                                child: ListItemUiWidget(
                                  showIcon: IconPosition.left,
                                  iconLeft: Text(item['id'].toString()),
                                  id: item['id'],
                                  title: item['nama'],
                                  subTitle:
                                      '${item['arti']} - ${item['ayat']} ayat',
                                  subtitleStyle: TextStyle(fontSize: 2),
                                  onTap: () async {
                                    await ctrl.goToData(item);
                                    if (context.mounted) {
                                      Navigator.pop(context);
                                    }
                                  },
                                  titleStyle: context.textTheme.titleMedium
                                      ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                ),
                              );
                            },
                          ),
                  ))
            ],
          );
        });
  }

  void showDialogFilter(HalamanQuranTajwidController ctrl, flag) {
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
          Obx(() => ctrl.loadingFilter.value == true
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ButtonElevated(
                            title: 'Juz',
                            width: 120,
                            bgcolor: ctrl.selectedJuz.value == true
                                ? Get.theme.primaryColor
                                : Get.theme.secondaryHeaderColor,
                            height: 30,
                            color: ctrl.selectedJuz.value == true
                                ? Colors.white
                                : Colors.black,
                            radius: 0,
                            onPressed: () {
                              ctrl.selectedJuz.value = !ctrl.selectedJuz.value;
                            },
                          ),
                          ButtonElevated(
                            title: 'Halaman',
                            width: 120,
                            bgcolor: ctrl.selectedJuz.value == false
                                ? Get.theme.primaryColor
                                : Get.theme.secondaryHeaderColor,
                            height: 30,
                            color: ctrl.selectedJuz.value == false
                                ? Colors.white
                                : Colors.black,
                            radius: 0,
                            onPressed: () {
                              ctrl.selectedJuz.value = !ctrl.selectedJuz.value;
                            },
                          ),
                        ],
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: InputText(
                          inputType: TextInputType.number,
                          controller: ctrl.inputFilter,
                          labelPosition: "none",
                          placeholder:
                              ctrl.selectedJuz.value == true ? "1-30" : "1-604",
                          textAlign: TextAlign.center,
                          isFill: true,
                          placeholderStyle: Get.textTheme.bodyMedium,
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
                      ctrl.isMax.value != true
                          ? Container()
                          : SizedBox(
                              width: Get.width - 25,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ctrl.selectedJuz.value == true
                                      ? Text('Maks Juz 30',
                                          style: Get.textTheme.bodySmall
                                              ?.copyWith(color: Colors.red))
                                      : Text('Maks Halaman 604',
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
                            children: ctrl.selectedJuz.value
                                ? [
                                    SizedBox(
                                      width: 5,
                                    ),
                                    ButtonElevated(
                                      title: 'Buka Juz',
                                      width: Get.width / 2.5,
                                      size: Get.textTheme.bodySmall?.fontSize,
                                      bgcolor: Color(0xFF2128C2),
                                      height: 30,
                                      color: Colors.white,
                                      radius: 5,
                                      onPressed: () {
                                        if (ctrl.selectedJuz.value == true) {
                                          if (int.parse(ctrl.inputFilter.text) >
                                              30) {
                                            ctrl.isMax.value = true;
                                          } else {
                                            ctrl.isMax.value = false;
                                            ctrl.goToNumber(
                                                ctrl.inputFilter.text);
                                            Navigator.pop(context);
                                          }
                                        }
                                      },
                                    ),
                                  ]
                                : [
                                    SizedBox(
                                      width: 5,
                                    ),
                                    ButtonElevated(
                                      title: 'Buka Halaman',
                                      width: Get.width / 2.5,
                                      size: Get.textTheme.bodySmall?.fontSize,
                                      bgcolor: Color(0xFF2128C2),
                                      height: 30,
                                      color: Colors.white,
                                      radius: 5,
                                      onPressed: () {
                                        if (ctrl.selectedJuz.value != true) {
                                          if (int.parse(ctrl.inputFilter.text) >
                                              604) {
                                            ctrl.isMax.value = true;
                                          } else {
                                            ctrl.isMax.value = false;
                                            ctrl.goToHal(ctrl.inputFilter.text);
                                            Navigator.pop(context);
                                          }
                                        }
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(HalamanQuranTajwidController());
    final hctrl = Get.find<HomeController>();
    return WillPopScope(
        onWillPop: () async {
          // Logika yang dijalankan saat tombol kembali ditekan
          Get.back(result: 'refresh');
          return false; // Kembalikan false agar tidak melakukan pop secara otomatis
        },
        child: Scaffold(
            backgroundColor: Color(0xFFF5F5F5),
            extendBodyBehindAppBar: false,
            resizeToAvoidBottomInset: false,
            body: layout(ctrl, context, hctrl),
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.white),
              leading: GestureDetector(
                  onTap: () {
                    Get.back(result: 'refresh');
                  },
                  child: const Icon(Icons.arrow_back_rounded)),
              backgroundColor: Color(0xFF048C7C),
              elevation: 0,
              title: Align(
                alignment: Alignment.centerLeft,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    splashColor: Colors.white30,
                    onTap: () => {showModal(ctrl, context)},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Obx(() => Text(ctrl.surahSaatIni.value,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.fontSize,
                                      letterSpacing: 0.5,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white))),
                              Obx(() => Text("Halaman ${ctrl.halSaatIni.value}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 10,
                                      letterSpacing: 0.5,
                                      color: Colors.white))),
                            ]),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.expand_more_rounded,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                Material(
                    color: Colors.transparent,
                    child: Padding(
                      padding: EdgeInsets.only(right: 21),
                      child: InkWell(
                        onTap: () {
                          showDialogFilter(ctrl, true);
                        },
                        borderRadius: BorderRadius.circular(20),
                        splashColor: Colors.green.withValues(alpha: 0.5),
                        child: const Icon(
                          Icons.tune_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ))
              ],
            )));
  }
}
