import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mesjid_app/components/button/elevatedbutton.dart';
import 'package:mesjid_app/components/layout/app_bar_ws.dart';
import 'package:mesjid_app/components/partial/list_sedekah.dart';
import 'package:mesjid_app/pages/sedekah/detail/detailsedekah_controller.dart';

class DetailSedekahPage extends StatelessWidget {
  const DetailSedekahPage({super.key});

  layout(DetailSedekahController ctrl, BuildContext context) {
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
                          Divider(
                            color: Colors.black45,
                          ),
                          Row(
                            children: [
                              Flexible(
                                  flex: 1,
                                  child: Text(
                                      "Lorem ipsum dolor sit amet consectetur. Lacus sed eget ultrices faucibus nibh. Ac morbi aenean volutpat nisl vulputate. Quam neque amet eleifend fermentum nec. Tristique purus tristique in netus velit posuere tellus bibendum. Vulputate massa faucibus tellus nec risus tristique. Id cras consectetur vitae dapibus a pulvinar urna. Dictum quis a tellus lorem morbi congue.",
                                      style: TextStyle(
                                          fontSize: Theme.of(context)
                                              .textTheme
                                              .labelSmall
                                              ?.fontSize,
                                          fontWeight: FontWeight.w300)))
                            ],
                          ),
                          Row(
                            children: [
                              Flexible(
                                flex: 1,
                                child: LinearProgressIndicator(
                                  value: 0.8,
                                  minHeight: 10,
                                  backgroundColor: const Color(0xFF92E3A9),
                                  borderRadius: BorderRadius.circular(10),
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                          Color(0xFF048C7C)),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                "80%",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.fontSize,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black87),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("Dana Terkumpul",
                                      style: TextStyle(
                                          fontSize: Theme.of(context)
                                              .textTheme
                                              .labelMedium
                                              ?.fontSize,
                                          fontWeight: FontWeight.w500)),
                                  Text("Rp. 10.500.000",
                                      style: TextStyle(
                                          fontSize: Theme.of(context)
                                              .textTheme
                                              .labelLarge
                                              ?.fontSize,
                                          fontWeight: FontWeight.bold))
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("Dana Kebutuhan",
                                      style: TextStyle(
                                          fontSize: Theme.of(context)
                                              .textTheme
                                              .labelMedium
                                              ?.fontSize,
                                          fontWeight: FontWeight.w500)),
                                  Text("Rp. 10.500.000",
                                      style: TextStyle(
                                          fontSize: Theme.of(context)
                                              .textTheme
                                              .labelLarge
                                              ?.fontSize,
                                          fontWeight: FontWeight.bold))
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("Waktu",
                                      style: TextStyle(
                                          fontSize: Theme.of(context)
                                              .textTheme
                                              .labelMedium
                                              ?.fontSize,
                                          fontWeight: FontWeight.w500)),
                                  Text("90 Hari",
                                      style: TextStyle(
                                          fontSize: Theme.of(context)
                                              .textTheme
                                              .labelLarge
                                              ?.fontSize,
                                          fontWeight: FontWeight.bold))
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
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
      itemCount: 5,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        // Datum model = filteredEvents[index];
        return FadeInUp(
          child: ListItemSedekahWidget(
            id: '1}',
            title: 'Sedekah ${index}',
            dueDay: 20,
            targetPrice: 5000000,
            totalPrice: 1000000,
            image: 'assets/icons/image-item1.png',
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(DetailSedekahController());

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBarWSWidget.getAppbarWidget(
          title: "Detail Sedekah", context: context, elevation: 0),
      body: layout(ctrl, context),
    );
  }
}
