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

class ListAyatQuranPage extends StatelessWidget {
  const ListAyatQuranPage({super.key});

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
                        subTitle: item['name']['translation']['id'] +
                            ' - ' +
                            item['numberOfVerses'].toString() +
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

    return Theme(
        data: Theme.of(context).copyWith(
            tabBarTheme: TabBarTheme.of(context).copyWith(
                indicator: const UnderlineTabIndicator(
          borderSide: BorderSide(
            color: Colors.white,
            width: 4.0,
          ),
        ))),
        child: Obx(() => ctrl.detail.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Scaffold(
                backgroundColor: Color(0xFFF5F5F5),
                extendBodyBehindAppBar: false,
                resizeToAvoidBottomInset: false,
                appBar: AppBarWSWidget.getAppbarWidget(
                  title: ctrl.detail.isEmpty
                      ? "List Ayat : "
                      : ctrl.detail['name']['transliteration']['id'],
                  subtitle: AutoSizeText(
                      ctrl.detail.isEmpty
                          ? "Total Ayat :"
                          : "Jumlah Ayat : " +
                              ctrl.detail['numberOfVerses'].toString(),
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
                  bottom: listTabs(ctrl, context),
                  onTap: () => {showPopup(ctrl, context)},
                ),
                body: Obx(() => ctrl.isLoadingList.value
                    ? const Center(child: CircularProgressIndicator())
                    : tabContent(ctrl, gctrl, context)))));
  }
}
