import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mesjid_app/components/button/elevatedbutton.dart';
import 'package:mesjid_app/components/button/outlinebutton.dart';
import 'package:mesjid_app/components/layout/app_bar_ws.dart';
import 'package:mesjid_app/components/partial/list_sedekah.dart';
import 'package:mesjid_app/pages/sedekah/detail/component/donatur_tab.dart';
import 'package:mesjid_app/pages/sedekah/detail/component/laporan_tab.dart';
import 'package:mesjid_app/pages/sedekah/detail/detailsedekah_controller.dart';
import 'package:mesjid_app/routes/sedekah/index.dart';
import 'package:mesjid_app/theme.dart';

class DetailSedekahPage extends StatelessWidget {
  const DetailSedekahPage({super.key});

  layout(DetailSedekahController ctrl, BuildContext context) {
    print(ctrl.detail['sedekahs'] != []);
    return NestedScrollView(
        controller: ctrl.scrollController,
        headerSliverBuilder: (context, value) {
          return [
            SliverToBoxAdapter(
                child: SafeArea(
                    child: Padding(
              padding: const EdgeInsets.only(left: 21, right: 21),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(ctrl.detail['image'],
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
                          // child: Text(ctrl.detail['judul'],
                          child: Text(ctrl.detail['judul'],
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
                          child: Text(ctrl.detail['subjudul'],
                              style: TextStyle(
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .labelLarge
                                      ?.fontSize,
                                  fontWeight: FontWeight.w300)))
                    ],
                  ),
                  const Divider(
                    color: Colors.black45,
                  ),
                  Row(
                    children: [
                      Flexible(
                          flex: 1,
                          child: Text(ctrl.detail['isi'],
                              style: TextStyle(
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .labelMedium
                                      ?.fontSize,
                                  fontWeight: FontWeight.w300)))
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child: LinearProgressIndicator(
                          value: ctrl.detail['lineprogress'],
                          minHeight: 10,
                          backgroundColor: const Color(0xFF92E3A9),
                          borderRadius: BorderRadius.circular(10),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFF048C7C)),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text('${ctrl.detail['persentase']}%',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize:
                                Theme.of(context).textTheme.bodySmall?.fontSize,
                            fontWeight: FontWeight.normal,
                            color: Colors.black87),
                      )
                    ],
                  ),
                  const SizedBox(
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
                          Text(priceFormat.format(ctrl.detail['total']),
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
                          Text(priceFormat.format(ctrl.detail['dana_kebutuhan']),
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
                          Text(ctrl.detail['deadline'] != null ? "${ctrl.detail['deadline']} Hari" : '∞',
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
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: Get.width,
                    child: Row(children: [
                      Flexible(
                        flex: 1,
                        child: ButtonElevated(
                          title: 'Sedekah Sekarang',
                          width: Get.width,
                          bgcolor: Theme.of(context).primaryColor,
                          height: 45,
                          color: Colors.white,
                          radius: 5,
                          onPressed: () {
                            Get.toNamed('${RoutesSedekah.root}/${Get.parameters['id']}/transaksi',
                                arguments: {"first": 'First data'});
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      ButtonOutline(
                        // title: 'Sedekah Sekarang',
                        width: 60,
                        iconOnly: true,
                        iconLeft: const Icon(Icons.share),
                        // bgcolor: Theme.of(context).primaryColor,
                        height: 45,
                        radius: 5,

                        onPressed: () {},
                      ),
                    ]),
                  )
                ],
              ),
            ))),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(left: 21, right: 21, top: 30),
                child: Container(
                  height: 50,
                  decoration: const BoxDecoration(
                      border: Border(
                          top: BorderSide(width: 1, color: Colors.black54))),
                  child: TabBar(
                      labelColor: Theme.of(context).primaryColor,
                      labelStyle: context.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      indicatorColor: const Color.fromRGBO(4, 2, 46, 1),
                      unselectedLabelColor: Colors.grey,
                      controller: ctrl.tabController,
                      tabs: ctrl.tabDetailSedekah),
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: ctrl.tabController,
          children: [
            Padding(
                padding: const EdgeInsets.only(left: 21, right: 21),
                child: ctrl.detail['sedekahs'].length > 0 ? const DonaturTab() : 
                  const Align(
                    alignment: Alignment.center,
                    child: Text('Belum ada Donatur'),
                  )                
            ),
            Padding(
                padding: const EdgeInsets.only(left: 21, right: 21),
                child: Align(
                  alignment: Alignment.center,
                  child: ctrl.detail['penyalur_campaigns'].length > 0 ? const LaporanTab() : const Text('Belum ada laporan dari DKM')
                  // Text("Belum Ada Laporan dari DKM")
                  ,
                )),
          ],
        ));
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
            id: 1,
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
      body: Obx(() => ctrl.isLoadingList.value ? const Text('Loading') : layout(ctrl, context)),
    );
  }
}
