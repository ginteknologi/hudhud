import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mesjid_app/components/button/elevatedbutton.dart';
import 'package:mesjid_app/components/layout/app_bar_ws.dart';
import 'package:mesjid_app/components/partial/list_sedekah.dart';
import 'package:mesjid_app/pages/sedekah/sedekah_controller.dart';

class SedekahPage extends StatelessWidget {
  const SedekahPage({super.key});

  layout(SedekahController ctrl, BuildContext context) {
    return SafeArea(
        child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 21, right: 21),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              "https://picsum.photos/1000",
                              height: 146,
                              width: Get.width,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Flexible(
                                  flex: 1,
                                  child: Text(
                                    "Sedekah Mesjid",
                                    style: TextStyle(
                                        fontSize: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.fontSize,
                                        fontWeight: FontWeight.bold),
                                  ))
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Flexible(
                                  flex: 1,
                                  child: Text(
                                      "Disalurkan untuk biaya operasional dan pemeliharaan Masjid An-Ni’mah",
                                      style: TextStyle(
                                          fontSize: Theme.of(context)
                                              .textTheme
                                              .labelLarge
                                              ?.fontSize,
                                          fontWeight: FontWeight.w300)))
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      // height: 53,
                      width: Get.width,
                      decoration:
                          BoxDecoration(color: Theme.of(context).primaryColor),
                      padding:
                          EdgeInsets.symmetric(horizontal: 21, vertical: 7),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Sudah sedekah hari ini?",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .labelLarge
                                      ?.fontSize,
                                  fontWeight: FontWeight.normal)),
                          ButtonElevated(
                            title: 'Sedekah Sekarang!',
                            width: 150,
                            bgcolor: const Color(0xFF92E3A9),
                            height: 35,
                            color: Colors.black,
                            radius: 5,
                            onPressed: () {
                              ctrl.goToDetail('1');
                            },
                          )
                        ],
                      ),
                    ),
                    Padding(
                        padding:
                            const EdgeInsets.only(left: 21, right: 21, top: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Sedekah Lainnya",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.fontSize,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            getList(ctrl, context)
                          ],
                        )),
                  ],
                ))));
  }

  getList(ctrl, context) {
    return ListView.builder(
      physics: const ClampingScrollPhysics(),
      itemCount: ctrl.listSedekah.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        // Datum model = filteredEvents[index];
        return FadeInUp(
          child: ListItemSedekahWidget(
            id: ctrl.listSedekah[index]['id'],
            title: ctrl.listSedekah[index]['title'],
            dueDay: ctrl.listSedekah[index]['dueDay'],
            targetPrice: ctrl.listSedekah[index]['target'],
            totalPrice: ctrl.listSedekah[index]['total'],
            image: 'assets/icons/image-item1.png',
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(SedekahController());

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBarWSWidget.getAppbarWidget(
          title: "Sedekah", context: context, elevation: 0),
      body: layout(ctrl, context),
    );
  }
}
