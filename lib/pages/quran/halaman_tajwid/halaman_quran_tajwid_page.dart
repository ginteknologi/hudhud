import 'package:animate_do/animate_do.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:masjid_app/components/button/elevatedbutton.dart';
import 'package:masjid_app/components/input/InputText.dart';
import 'package:masjid_app/components/layout/custom_modal_bottom_sheet.dart';
import 'package:masjid_app/components/partial/list_ui.dart';
import 'package:masjid_app/pages/home/home_controller.dart';
import 'package:masjid_app/pages/quran/halaman_tajwid/component/image_viewer_widget.dart';
import 'package:masjid_app/pages/quran/halaman_tajwid/halaman_quran_tajwid_controller.dart';

class HalamanQuranTajwidPage extends StatefulWidget {
  const HalamanQuranTajwidPage({super.key});

  @override
  State<HalamanQuranTajwidPage> createState() => _HalamanQuranTajwidPageState();
}

class _HalamanQuranTajwidPageState extends State<HalamanQuranTajwidPage>
    with SingleTickerProviderStateMixin {
  layout(HalamanQuranTajwidController ctrl, BuildContext context,
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

  bool _visible = true;
  bool _show = true;
  late final AnimationController _controller;

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
                                  iconLeft: Text(item['number'].toString()),
                                  id: item['number'],
                                  title: item['name']['transliteration']['id'],
                                  subTitle:
                                      '${item['name']['translation']['id']} - ${item['numberOfVerses']} ayat',
                                  subtitleStyle: TextStyle(fontSize: 2),
                                  onTap: () async {
                                    await ctrl.goToData(item);
                                    Navigator.pop(context);
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

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
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
            )));
    // appBar: AppBarWSWidget.getAppbarWidget(
    //   title: Obx(() => ctrl.isLoadingList.value ? '' : ctrl.surahSaatIni.value),
    //   subtitle: AutoSizeText('Juz 3 - Hal.50',
    //       maxLines: 1,
    //       style: context.textTheme.bodySmall?.copyWith(
    //           fontWeight: FontWeight.normal, color: Colors.white)),
    //   haveSubtitle: true,
    //   context: context,
    //   iconTheme: IconThemeData(color: Colors.white),
    //   elevation: 0,
    //   color: Colors.white,
    //   titleAlign: Alignment.centerLeft,
    //   onTap: () => {showModal(ctrl, context)},
    //   backgroundColor: Color(0xFF048C7C),
    // ));
  }
}
