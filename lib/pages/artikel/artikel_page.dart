import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:masjid_app/components/layout/app_bar_ws.dart';
import 'package:masjid_app/components/partial/list_card_ui.dart';
import 'package:masjid_app/pages/artikel/artikel_controller.dart';
class ArtikelPage extends StatelessWidget {
  const ArtikelPage({super.key});

  layout(ArtikelController ctrl, BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Padding(
                padding: const EdgeInsets.only(left: 21, right: 21),
                child: Column(children: [
                  SizedBox(
                    height: 20,
                  ),
                  getListCategory(ctrl),
                  SizedBox(
                    height: 10,
                  ),
                  getListArtikel(ctrl, context)
                ]))));
  }

  getListCategory(ArtikelController ctrl) {
    return Container(
      height: 40,
      constraints: BoxConstraints.loose(Size.infinite),
      child: ListView.separated(
        // padding: EdgeInsets.only(left: 24, right: 24),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: ctrl.listCategoryFilter.length,
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          return Obx(() => ChoiceChip(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(width: 1, color: Colors.black12)),
                selected: ctrl.listCategoryFilterSelected[index].value,
                label: Text(
                  ctrl.listCategoryFilter[index]['name'],
                  style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.labelMedium?.fontSize,
                      color: ctrl.listCategoryFilterSelected[index].value
                          ? Colors.white
                          : Colors.black),
                ),
                labelPadding: EdgeInsets.symmetric(horizontal: 10),
                labelStyle: TextStyle(
                    color: Colors.grey[300], fontWeight: FontWeight.w500),
                backgroundColor: Colors.transparent,
                pressElevation: 1,
                selectedColor: Theme.of(context).primaryColor,
                padding: EdgeInsets.all(8),
                onSelected: (selected) {
                  for (RxBool b in ctrl.listCategoryFilterSelected) {
                    if (b.isTrue) b.value = false;
                  }
                  ctrl.listCategoryFilterSelected[index].value =
                      !ctrl.listCategoryFilterSelected[index].value;
                },
              ));
        },
      ),
    );
  }

  getListArtikel(ArtikelController ctrl, BuildContext context) {
    return ListView.builder(
      physics: const ClampingScrollPhysics(),
      itemCount: ctrl.listArtikels.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        // Datum model = filteredEvents[index];
        return FadeInUp(
          child: ListCardUiWidget(
            id: ctrl.listArtikels[index]['id'],
            title: ctrl.listArtikels[index]['title']['rendered'],
            position: MainAxisAlignment.end,
            usingDivider: false,
            height: 170,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(ctrl.listArtikels[index]['_embedded']['wp:featuredmedia'][0]['source_url']),
                    fit: BoxFit.cover)),
            titleStyle: context.textTheme.titleSmall
                ?.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
            marginSeparator: 0,
            subtitleStyle: context.textTheme.labelMedium
                ?.copyWith(fontWeight: FontWeight.bold, color: Colors.black45),
            onTap: () {
              ctrl.goToDetail(ctrl.listArtikels[index]);
            },
            hasFooter: true,
            footerContent: [
              Text(DateFormat('dd MMMM yyyy HH:mm').format(DateTime.parse(ctrl.listArtikels[index]['date'])),
                  textAlign: TextAlign.start,
                  style: context.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w300,
                      letterSpacing: 0,
                      color: Colors.white)),
              Row(
                children: [
                  // Icon(
                  //   Icons.remove_red_eye_rounded,
                  //   color: Colors.white,
                  //   size: context.textTheme.labelLarge?.fontSize,
                  // ),
                  SizedBox(
                    width: 5,
                  ),
                  // Text(ctrl.listArtikels[index]['viewer'],
                  //     textAlign: TextAlign.end,
                  //     style: context.textTheme.labelMedium?.copyWith(
                  //         fontWeight: FontWeight.w300, color: Colors.white)),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(ArtikelController());

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBarWSWidget.getAppbarWidget(
          title: "Artikel / Informasi", context: context, elevation: 0),
      body: Obx(() => ctrl.isLoadingList.value ? CircularProgressIndicator() : layout(ctrl, context)),
    );
  }
}
