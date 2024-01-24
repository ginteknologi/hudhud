import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:masjid_app/components/button/iconbutton.dart';
import 'package:masjid_app/components/input/InputText.dart';
import 'package:masjid_app/components/layout/app_bar_ws.dart';
import 'package:masjid_app/components/layout/custom_modal_bottom_sheet.dart';
import 'package:masjid_app/components/partial/list_ayat.dart';
import 'package:masjid_app/components/partial/list_card_ayat.dart';
import 'package:masjid_app/components/partial/list_ui.dart';
import 'package:masjid_app/configs/main_controller.dart';
import 'package:masjid_app/pages/quran/listAyat/listAyat_quran_controller.dart';
// import 'package:masjid_app/theme.dart';
import 'package:masjid_app/routes/quran/index.dart';

class ListAyatQuranPage extends StatelessWidget {
  const ListAyatQuranPage({super.key});

  // layout(ListAyatQuranController ctrl, MainController gctrl,
  //     BuildContext context) {
  //   var lasRead = gctrl.perAyatLastRead['id'] ?? 0;
  //   return SafeArea(
  //       child: SizedBox(
  //           height: MediaQuery.of(context).size.height,
  //           child: SingleChildScrollView(
  //               physics: const ClampingScrollPhysics(),
  //               child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   mainAxisSize: MainAxisSize.max,
  //                   children: [
  //                     Padding(
  //                         padding: const EdgeInsets.only(
  //                             left: 21, right: 21, top: 21),
  //                         child: Column(children: [
  //                           Card(
  //                             elevation: 0,
  //                             color: const Color(0xFFF5F5F5),
  //                             margin: const EdgeInsets.only(top: 20),
  //                             clipBehavior: Clip.antiAlias,
  //                             shape: RoundedRectangleBorder(
  //                               borderRadius: BorderRadius.circular(15),
  //                               //set border radius more than 50% of height and width to make circle
  //                             ),
  //                             child: Container(
  //                                 width: Get.width,
  //                                 height: 135,
  //                                 constraints:
  //                                     BoxConstraints.loose(Size.infinite),
  //                                 decoration: const BoxDecoration(
  //                                     image: DecorationImage(
  //                                         image: AssetImage(
  //                                             "assets/img/card_quran.png"),
  //                                         fit: BoxFit.fill)),
  //                                 child: Padding(
  //                                   padding: EdgeInsets.all(15),
  //                                   child: Column(
  //                                     mainAxisAlignment:
  //                                         MainAxisAlignment.spaceBetween,
  //                                     crossAxisAlignment:
  //                                         CrossAxisAlignment.start,
  //                                     children: [
  //                                       Row(
  //                                         children: [
  //                                           Icon(
  //                                             Icons.menu_book_rounded,
  //                                             color: Colors.white,
  //                                           ),
  //                                           SizedBox(
  //                                             width: 10,
  //                                           ),
  //                                           Text(
  //                                             lasRead > 0
  //                                                 ? '${gctrl.perAyatLastRead['id']}'
  //                                                 : '-',
  //                                             style: context
  //                                                 .textTheme.titleSmall
  //                                                 ?.copyWith(
  //                                                     fontWeight:
  //                                                         FontWeight.bold,
  //                                                     color: Colors.white),
  //                                           )
  //                                         ],
  //                                       ),
  //                                       Column(
  //                                         children: [
  //                                           Align(
  //                                             alignment: Alignment.centerLeft,
  //                                             child: AutoSizeText(
  //                                               gctrl.perAyatLastRead[
  //                                                           'ayatNumber'] >
  //                                                       0
  //                                                   ? '${gctrl.perAyatLastRead['suratName']}'
  //                                                   : 'Belum baca',
  //                                               textAlign: TextAlign.start,
  //                                               style: context
  //                                                   .textTheme.titleMedium
  //                                                   ?.copyWith(
  //                                                       fontWeight:
  //                                                           FontWeight.bold,
  //                                                       color: Colors.white),
  //                                               maxLines: 2,
  //                                             ),
  //                                           ),
  //                                           Align(
  //                                               alignment: Alignment.centerLeft,
  //                                               child: AutoSizeText(
  //                                                 'Ayat No : '
  //                                                 "${gctrl.perAyatLastRead['ayatNumber'] > 0 ? '${gctrl.perAyatLastRead['ayatNumber']}' : '-'}",
  //                                                 textAlign: TextAlign.start,
  //                                                 style: context
  //                                                     .textTheme.titleSmall
  //                                                     ?.copyWith(
  //                                                         fontWeight:
  //                                                             FontWeight.w300,
  //                                                         color: Colors.white),
  //                                                 maxLines: 2,
  //                                               )),
  //                                         ],
  //                                       )
  //                                     ],
  //                                   ),
  //                                 )), //SizedBox
  //                           ),
  //                           const SizedBox(height: 20),
  //                           InputText(
  //                             suffixIcon: Icon(Icons.search),
  //                             labelPosition: 'none',
  //                             placeholder: 'Cari',
  //                             radius: 5,
  //                             isFill: true,
  //                             fillColor: Colors.white,
  //                             placeholderStyle:
  //                                 Theme.of(context).textTheme.bodyMedium,
  //                             inputPadding: const EdgeInsets.all(15),
  //                             controller: ctrl.searchController,
  //                             onSubmit: (newValue) {},
  //                             onEditingComplete: () {},
  //                             onChanged: (newValue) {
  //                               print('asdasdsad');
  //                               ctrl.getDataSearch();
  //                             },
  //                             validator: (newValue) {
  //                               if (newValue!.isEmpty) {
  //                                 return "Mohon untuk diisi.";
  //                               }
  //                               return null;
  //                             },
  //                           )
  //                         ])),
  //                     Container(
  //                       decoration: const BoxDecoration(color: Colors.white),
  //                       child: Padding(
  //                           padding: const EdgeInsets.only(
  //                               left: 21, right: 21, top: 21),
  //                           child: Column(
  //                             children: [
  //                               const Align(
  //                                 alignment: Alignment.centerLeft,
  //                                 child: Text("Surat"),
  //                               ),
  //                               Obx(() => !ctrl.isLoadingList.value
  //                                   ? ListView.builder(
  //                                       physics: const BouncingScrollPhysics(),
  //                                       itemCount: ctrl.list.length,
  //                                       // itemCount: 114,
  //                                       shrinkWrap: true,
  //                                       itemBuilder: (context, index) {
  //                                         var item = ctrl.list[index];
  //                                         return FadeInUp(
  //                                           child: ListItemUiWidget(
  //                                             id: item['number'],
  //                                             title: item['name']
  //                                                 ['transliteration']['id'],
  //                                             onTap: () {
  //                                               // print(item);
  //                                               Get.toNamed(
  //                                                   '${RoutesQuran.detail.replaceAll(':id', item['number'].toString())}?nama_surah=${item['name']['transliteration']['id']}');
  //                                               // ctrl.goToDetail(item['number']);
  //                                             },
  //                                             titleStyle: context
  //                                                 .textTheme.titleMedium
  //                                                 ?.copyWith(
  //                                                     fontWeight:
  //                                                         FontWeight.bold,
  //                                                     color: Theme.of(context)
  //                                                         .primaryColor),
  //                                             subTitle: item['name']
  //                                                 ['translation']['id'],
  //                                             hasRightContent: true,
  //                                             showIcon: IconPosition.left,
  //                                             activeColor: gctrl
  //                                                             .perAyatLastRead[
  //                                                         'suratName'] ==
  //                                                     item['name'][
  //                                                             'transliteration']
  //                                                         ['id']
  //                                                 ? BoxDecoration(
  //                                                     color: Colors.green[50])
  //                                                 : BoxDecoration(),
  //                                             iconLeft: SizedBox(
  //                                               height: 42,
  //                                               width: 42,
  //                                               child: Stack(
  //                                                 children: <Widget>[
  //                                                   SvgPicture.asset(
  //                                                     'assets/icons/start_list.svg',
  //                                                     alignment:
  //                                                         Alignment.center,
  //                                                     width: 42,
  //                                                     height: 42,
  //                                                   ),
  //                                                   Column(
  //                                                     children: <Widget>[
  //                                                       Expanded(
  //                                                         child: Align(
  //                                                           alignment: Alignment
  //                                                               .center,
  //                                                           child: Text(ctrl
  //                                                               .list[index]
  //                                                                   ['number']
  //                                                               .toString()),
  //                                                         ),
  //                                                       )
  //                                                     ],
  //                                                   ),
  //                                                 ],
  //                                               ),
  //                                             ),
  //                                             // Container(
  //                                             //   height: 42,
  //                                             //   width: 42,
  //                                             //   decoration: BoxDecoration(
  //                                             //       image: DecorationImage(
  //                                             //     image: Svg(
  //                                             //       'assets/example.svg',
  //                                             //     ),
  //                                             //   )),
  //                                             //   child: Align(
  //                                             //     alignment: Alignment.center,
  //                                             //     child: Text("999"),
  //                                             //   ),
  //                                             // ),
  //                                             rightContent: [
  //                                               Text(
  //                                                   item['revelation']['id'] +
  //                                                       '\n' +
  //                                                       item['numberOfVerses']
  //                                                           .toString() +
  //                                                       ' Ayat',
  //                                                   textAlign: TextAlign.end,
  //                                                   style: context
  //                                                       .textTheme.bodySmall
  //                                                       ?.copyWith(
  //                                                     fontWeight:
  //                                                         FontWeight.normal,
  //                                                   ))
  //                                             ],
  //                                           ),
  //                                         );
  //                                       },
  //                                     )
  //                                   : const Center(
  //                                       child: CircularProgressIndicator(),
  //                                     ))
  //                             ],
  //                           )),
  //                     )
  //                   ]))));
  // }

  tabMaker(data) {
    List<Tab> tabs = [];
    for (var i = 0; i < data.length; i++) {
      tabs.add(Tab(
        text: data[i]['name']['transliteration']['id'],
      ));
    }
    return tabs;
  }

  listTabs(ListAyatQuranController ctrl, BuildContext context) {
    return PreferredSize(
        child: Obx(() => ctrl.isLoadingList.value
            ? const Center(child: CircularProgressIndicator())
            : TabBar(
                onTap: (selectedIndex) async {
                  print(ctrl.list[selectedIndex]['number']);
                  await ctrl.getDetailData(ctrl.list[selectedIndex]['number']);
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
      controller: ctrl.tabController,
      children: <Widget>[
        for (var i in ctrl.list)
          Obx(() => ctrl.isLoadingDetail.value
              ? const Center(child: CircularProgressIndicator())
              : listAyat(ctrl, context, ctrl.list))
      ],
    );
  }

  listAyat(ListAyatQuranController ctrl, BuildContext context, data) {
    return Obx(() => !ctrl.isLoadingDetail.value
        ? ListView.builder(
            physics: const ClampingScrollPhysics(),
            itemCount: ctrl.detail['numberOfVerses'],
            shrinkWrap: true,
            itemBuilder: (context, index) {
              // Datum model = filteredEvents[index];
              var item = ctrl.listAyat[index];
              return FadeInUp(
                  child: Obx(
                () => ctrl.isLoadingDetail.value
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListAyatWidget(
                        id: item['number']['inSurah'],
                        ayat: item['text']['arab'],
                        descEN: item['text']['transliteration']['en'],
                        descIDN: item['translation']['id'],
                        nomor: item['number']['inSurah'].toString(),
                        audioFile: item['audio']['primary'],
                        onTap: () {},
                      ),
              ));
            },
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
                  print('asdasdsad');
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
                        iconLeft: Text(item['number'].toString()),
                        id: item['number'],
                        title: item['name']['transliteration']['id'],
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

    return Theme(
        data: Theme.of(context).copyWith(
            tabBarTheme: TabBarTheme.of(context).copyWith(
                indicator: const UnderlineTabIndicator(
          borderSide: BorderSide(
            color: Colors.white,
            width: 4.0,
          ),
        ))),
        child: Scaffold(
            backgroundColor: Color(0xFFF5F5F5),
            extendBodyBehindAppBar: false,
            resizeToAvoidBottomInset: false,
            appBar: AppBarWSWidget.getAppbarWidget(
                title: "Surah Ali Imran",
                subtitle: AutoSizeText('Juz 3 - Hal.50',
                    maxLines: 1,
                    style: context.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.normal, color: Colors.white)),
                haveSubtitle: true,
                context: context,
                iconTheme: IconThemeData(color: Colors.white),
                elevation: 0,
                color: Colors.white,
                titleAlign: Alignment.centerLeft,
                backgroundColor: Color(0xFF048C7C),
                onTap: () => {showPopup(ctrl, context)},
                bottom: listTabs(ctrl, context)),
            body: Obx(() => ctrl.isLoadingList.value
                ? const Center(child: CircularProgressIndicator())
                : tabContent(ctrl, gctrl, context))));
  }
}
