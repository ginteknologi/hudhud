import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mesjid_app/components/partial/list_ui.dart';
import 'package:mesjid_app/pages/dkm/dkm_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class DkmPage extends StatelessWidget {
  const DkmPage({super.key});

  layout(DkmController ctrl, BuildContext context) {
    return SafeArea(
      top: false,
      child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              children: [
                Container(
                  width: Get.width,
                  height: 260,
                  constraints: BoxConstraints.loose(Size.infinite),
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15)),
                      image: DecorationImage(
                          image: AssetImage("assets/img/bg_dkm.png"),
                          fit: BoxFit.fill)),
                  child: Padding(
                    padding: EdgeInsets.only(left: 25, right: 25, bottom: 25),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/img/logo_only_white.png",
                          height: 80,
                          width: 80,
                        ),
                        Text(
                          "Masjid An-Ni'mah",
                          style: context.textTheme.titleLarge?.copyWith(
                              fontFamily: "DMSerifDisplay",
                              fontWeight: FontWeight.normal,
                              color: Colors.white),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: AutoSizeText(
                              "Di bawah Naungan Allah, kita bersatu dalam keimanan di Masjid An-Ni’mah, tempat keberkahan dan ketenangan merajut jalinan kasih dan do’a",
                              maxLines: 4,
                              textAlign: TextAlign.center,
                              style: context.textTheme.labelSmall?.copyWith(
                                  fontWeight: FontWeight.normal,
                                  letterSpacing: -1,
                                  color: Colors.white)),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                getListCategory(ctrl),
                SizedBox(
                  height: 20,
                ),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 21),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Member DKM Kami",
                              style: context.textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black38)),
                        ),
                        ListView.builder(
                          physics: const ClampingScrollPhysics(),
                          itemCount: ctrl.listMemberDkm.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            // Datum model = filteredEvents[index];
                            return FadeInUp(
                              child: ListItemUiWidget(
                                id: ctrl.listMemberDkm[index]['id'],
                                title: ctrl.listMemberDkm[index]['nama'],
                                widthContent: MediaQuery.of(context).size.width,
                                showIcon: IconPosition.left,
                                iconLeft: Row(children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(90),
                                    child: Image.asset("assets/icons/app_icon.png",
                                      height: 60,
                                      width: 60,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ]),
                                titleStyle: context.textTheme.bodyMedium
                                    ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                subTitle: ctrl.listMemberDkm[index]['role'],
                                subtitleStyle: context.textTheme.bodySmall
                                    ?.copyWith(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black),
                              ),
                            );
                          },
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Kontak Kami",
                              style: context.textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black38)),
                        ),
                        ListView.builder(
                          physics: const ClampingScrollPhysics(),
                          itemCount: ctrl.listKontak.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            // Datum model = filteredEvents[index];
                            return FadeInUp(
                              child: ListItemUiWidget(
                                id: ctrl.listKontak[index]['id'],
                                title: ctrl.listKontak[index]['title'],
                                widthContent:
                                    MediaQuery.of(context).size.width * 0.7,
                                showIcon: IconPosition.left,
                                iconLeft: SvgPicture.asset(
                                    ctrl.listKontak[index]['icon'],
                                    height: 30,
                                    width: 30),
                                titleStyle: context.textTheme.bodySmall
                                    ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                category: ctrl.listKontak[index]['category'],
                                onTap: () async {
                                    final Uri url = Uri.parse(ctrl.listKontak[index]['link']);
                                    if (!await launchUrl(url)) {
                                      print('Tidak dapat membuka link YouTube.');
                                    }
                                },                                
                                // subtitleStyle: context.textTheme.bodySmall
                                //     ?.copyWith(
                                //         fontWeight: FontWeight.normal,
                                //         color: Colors.black),
                              ),
                            );
                          },
                        )
                      ],
                    ))
              ],
            ),
          )),
    );
  }

  getListCategory(DkmController ctrl) {
    return Container(
      height: 92,
      constraints: BoxConstraints.loose(Size.infinite),
      child: ListView.separated(
        // padding: EdgeInsets.only(left: 24, right: 24),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: ctrl.listDkm.length,
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          return Container(
            width: 140,
            alignment: Alignment.center,
            margin: EdgeInsets.only(left: 10),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
                color: Color(0xFF92E3A9),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Text(
              ctrl.listDkm[index]['label'],
              textAlign: TextAlign.center,
              maxLines: 2,
              style: context.textTheme.bodySmall
                  ?.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
              softWrap: true,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(DkmController());

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: layout(ctrl, context),
    );
  }
}
