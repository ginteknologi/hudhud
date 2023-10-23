import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mesjid_app/components/input/InputText.dart';
import 'package:mesjid_app/components/layout/app_bar_ws.dart';
import 'package:mesjid_app/components/partial/list_card_ui.dart';
import 'package:mesjid_app/components/partial/list_ui.dart';
import 'package:mesjid_app/pages/doa/detail/detail_doa_controller.dart';
import 'package:mesjid_app/theme.dart';

class DetailDoaPage extends StatelessWidget {
  const DetailDoaPage({super.key});

  layout(DetailDoaController ctrl, BuildContext context) {
    return SafeArea(
        child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(
                              left: 21, right: 21, top: 21),
                          child: Column(children: [
                            const SizedBox(height: 20),
                            InputText(
                              suffixIcon: Icon(Icons.search),
                              labelPosition: 'none',
                              placeholder: 'Cari',
                              radius: 5,
                              isFill: true,
                              fillColor: Colors.white,
                              placeholderStyle:
                                  Theme.of(context).textTheme.bodyMedium,
                              inputPadding: const EdgeInsets.all(15),
                              controller: ctrl.txtController,
                              onSubmit: (newValue) {},
                              onEditingComplete: () {},
                              onChanged: (newValue) {},
                              validator: (newValue) {
                                if (newValue!.isEmpty) {
                                  return "Mohon untuk diisi.";
                                }
                                return null;
                              },
                            )
                          ])),
                      Container(
                        decoration: BoxDecoration(color: Colors.white),
                        child: Padding(
                            padding: const EdgeInsets.only(
                                left: 21, right: 21, top: 21),
                            child: Column(
                              children: [
                                ListView.builder(
                                  physics: const ClampingScrollPhysics(),
                                  itemCount: ctrl.listDoa.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    // Datum model = filteredEvents[index];
                                    return FadeInUp(
                                      child: ListCardUiWidget(
                                        id: ctrl.listDoa[index]['id'],
                                        title: ctrl.listDoa[index]['title'],
                                        titleStyle: context.textTheme.titleSmall
                                            ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context)
                                                    .primaryColor),
                                        subtitleStyle: context
                                            .textTheme.labelMedium
                                            ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black45),
                                        onTap: () {
                                          ctrl.goToDetail(ctrl.listDoa[index]);
                                        },
                                        subtitle: ctrl.listDoa[index]
                                            ['subtitle'],
                                        hasFooter: true,
                                        footerContent: [
                                          Text(ctrl.listDoa[index]['kutipan'],
                                              textAlign: TextAlign.start,
                                              style: context
                                                  .textTheme.labelSmall
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      letterSpacing: 0,
                                                      color: Colors.black54)),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.remove_red_eye_rounded,
                                                color: Colors.black54,
                                                size: context.textTheme
                                                    .labelLarge?.fontSize,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                  ctrl.listDoa[index]['viewer'],
                                                  textAlign: TextAlign.end,
                                                  style: context
                                                      .textTheme.labelMedium
                                                      ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.w300,
                                                          color:
                                                              Colors.black54)),
                                            ],
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                )
                              ],
                            )),
                      )
                    ]))));
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(DetailDoaController());

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBarWSWidget.getAppbarWidget(
          title: "Do'a > Do'a Harian", context: context, elevation: 0),
      body: layout(ctrl, context),
    );
  }
}
