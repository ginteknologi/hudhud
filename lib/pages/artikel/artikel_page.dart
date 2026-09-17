import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:masjid_app/components/layout/app_bar_ws.dart';
import 'package:masjid_app/components/partial/list_card_ui.dart';
import 'package:masjid_app/pages/artikel/artikel_controller.dart';
import 'package:masjid_app/routes/artikel/index.dart';

class ArtikelPage extends StatelessWidget {
  final ArtikelController ctrl = Get.put(ArtikelController());
  ArtikelPage({super.key});

  SafeArea layout(ArtikelController ctrl, BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Padding(
                padding: const EdgeInsets.only(left: 21, right: 21),
                child: Column(children: [
                  // getListCategory(ctrl),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  getListArtikel(ctrl, context),
                  SizedBox(
                    height: 20,
                  )
                ]))));
  }

  ListView getListArtikel(ArtikelController ctrl, BuildContext context) {
    return ListView.builder(
      physics: const ClampingScrollPhysics(),
      itemCount: ctrl.listArtikels.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        // Datum model = filteredEvents[index];
        return FadeInUp(
          child: ListCardUiWidget(
            id: ctrl.listArtikels[index].id,
            title: ctrl.listArtikels[index].judul,
            position: MainAxisAlignment.end,
            usingDivider: false,
            height: 170,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(ctrl.listArtikels[index].image),
                    fit: BoxFit.cover)),
            titleStyle: context.textTheme.titleSmall
                ?.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
            marginSeparator: 0,
            subtitleStyle: context.textTheme.labelMedium
                ?.copyWith(fontWeight: FontWeight.bold, color: Colors.black45),
            onTap: () {
              Get.toNamed(
                  '${RoutesArtikel.root}/${ctrl.listArtikels[index].id}');
            },
            hasFooter: true,
            footerContent: [
              Text(
                  DateFormat('dd MMMM yyyy HH:mm').format(
                      DateTime.parse(ctrl.listArtikels[index].publish_date)
                          .add(Duration(hours: 7))),
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
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBarWSWidget.getAppbarWidget(
          title: "Artikel / Informasi", context: context, elevation: 0),
      body: Obx(() => ctrl.isLoadingList.value
          ? Center(child: CircularProgressIndicator())
          : layout(ctrl, context)),
    );
  }
}
