import 'package:animate_do/animate_do.dart';
// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:masjid_app/components/button/elevatedbutton.dart';
import 'package:masjid_app/components/layout/app_bar_ws.dart';
import 'package:masjid_app/components/partial/list_sedekah.dart';
import 'package:masjid_app/core/router/app_router.dart';
import 'package:masjid_app/providers/sedekah_provider.dart';

class SedekahPage extends ConsumerWidget {
  const SedekahPage({super.key});

  SafeArea layout(List<dynamic> list, BuildContext context) {
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
                              width: MediaQuery.of(context).size.width,
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
                      width: MediaQuery.of(context).size.width,
                      decoration:
                          BoxDecoration(color: Theme.of(context).primaryColor),
                      padding:
                          EdgeInsets.symmetric(horizontal: 21, vertical: 7),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Container(
                              padding: EdgeInsets.only(right: 13.0),
                              child: Text("Sudah sedekah hari ini?",
                                  maxLines: 2,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: Theme.of(context)
                                          .textTheme
                                          .labelLarge
                                          ?.fontSize,
                                      fontWeight: FontWeight.normal)),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: SizedBox(
                              width: double.infinity,
                              child: ButtonElevated(
                                title: 'Sedekah!',
                                width: MediaQuery.of(context).size.width,
                                bgcolor: const Color(0xFF92E3A9),
                                height: 35,
                                color: Colors.black,
                                radius: 5,
                                size: 14,
                                onPressed: () {
                                  context.push('${AppRoutes.sedekah}/1');
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   crossAxisAlignment: CrossAxisAlignment.center,
                      //   children: [
                      //     Text("Sudah sedekah hari ini?",
                      //         style: TextStyle(
                      //             color: Colors.white,
                      //             fontSize: Theme.of(context)
                      //                 .textTheme
                      //                 .labelLarge
                      //                 ?.fontSize,
                      //             fontWeight: FontWeight.normal)),
                      //     ButtonElevated(
                      //       title: 'Sedekah Sekarang!',
                      //       width: 150,
                      //       bgcolor: const Color(0xFF92E3A9),
                      //       height: 35,
                      //       color: Colors.black,
                      //       radius: 5,
                      //       onPressed: () {
                      //         ctrl.goToDetail('1');
                      //       },
                      //     )
                      //   ],
                      // ),
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
                            getList(list, context)
                          ],
                        )),
                  ],
                ))));
  }

  ListView getList(List<dynamic> list, BuildContext context) {
    return ListView.builder(
      physics: const ClampingScrollPhysics(),
      itemCount: list.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        // Datum model = filteredEvents[index];
        return FadeInUp(
          child: ListItemSedekahWidget(
            id: list[index]['id'],
            title: list[index]['judul'],
            dueDay: list[index]['deadline'],
            targetPrice: list[index]['dana_kebutuhan'],
            totalPrice: list[index]['total'],
            image: list[index]['image'],
            lineProgress: list[index]['lineprogress'],
            persentase: list[index]['persentase'],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listAsync = ref.watch(campaignRawListProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBarWSWidget.getAppbarWidget(
          title: "Sedekah", context: context, elevation: 0),
      body: listAsync.when(
          data: (list) => layout(list, context),
          loading: () => CircularProgressIndicator(),
          error: (error, stack) => layout(<dynamic>[], context)),
    );
  }
}
