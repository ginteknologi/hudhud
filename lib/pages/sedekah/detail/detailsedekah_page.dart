import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:masjid_app/components/button/elevatedbutton.dart';
import 'package:masjid_app/components/button/outlinebutton.dart';
import 'package:masjid_app/components/layout/app_bar_ws.dart';
import 'package:masjid_app/core/router/app_router.dart';
import 'package:masjid_app/pages/sedekah/detail/component/donatur_tab.dart';
import 'package:masjid_app/pages/sedekah/detail/component/laporan_tab.dart';
import 'package:masjid_app/providers/sedekah_provider.dart';
import 'package:masjid_app/theme.dart';

class DetailSedekahPage extends ConsumerStatefulWidget {
  const DetailSedekahPage({super.key});

  @override
  ConsumerState<DetailSedekahPage> createState() => _DetailSedekahPageState();
}

class _DetailSedekahPageState extends ConsumerState<DetailSedekahPage>
    with SingleTickerProviderStateMixin {
  final List<Tab> tabDetailSedekah = <Tab>[
    const Tab(
      text: 'Donatur',
    ),
    const Tab(text: 'Laporan'),
  ];

  late TabController tabController;
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: tabDetailSedekah.length);
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    tabController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  NestedScrollView layout(
      Map<String, dynamic> detail, String id, BuildContext context) {
    return NestedScrollView(
        controller: scrollController,
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
                    child: Image.network(detail['image'],
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
                          // child: Text(ctrl.detail['judul'],
                          child: Text(detail['judul'],
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
                          child: Text(detail['subjudul'],
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
                          child: Text(detail['isi'],
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
                          value: detail['lineprogress'],
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
                      Text('${detail['persentase']}%',
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
                          Text(priceFormat.format(detail['total']),
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
                          Text(priceFormat.format(detail['dana_kebutuhan']),
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
                          Text(detail['deadline'] != null ? "${detail['deadline']} Hari" : '∞',
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
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Row(children: [
                      Flexible(
                        flex: 1,
                        child: ButtonElevated(
                          title: 'Sedekah Sekarang',
                          width: MediaQuery.of(context).size.width,
                          bgcolor: Theme.of(context).primaryColor,
                          height: 45,
                          color: Colors.white,
                          radius: 5,
                          onPressed: () {
                            context.push(
                                '${AppRoutes.sedekah}/$id/transaksi',
                                extra: {"first": 'First data'});
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
                      labelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      indicatorColor: const Color.fromRGBO(4, 2, 46, 1),
                      unselectedLabelColor: Colors.grey,
                      controller: tabController,
                      tabs: tabDetailSedekah),
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: tabController,
          children: [
            Padding(
                padding: const EdgeInsets.only(left: 21, right: 21),
                child: detail['sedekahs'].length > 0 ? DonaturTab(listDonatur: detail['sedekahs']) :
                  const Align(
                    alignment: Alignment.center,
                    child: Text('Belum ada Donatur'),
                  )
            ),
            Padding(
                padding: const EdgeInsets.only(left: 21, right: 21),
                child: Align(
                  alignment: Alignment.center,
                  child: detail['penyalur_campaigns'].length > 0 ? LaporanTab(listPenyaluran: detail['penyalur_campaigns']) : const Text('Belum ada laporan dari DKM')
                  // Text("Belum Ada Laporan dari DKM")
                  ,
                )),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    final id = GoRouterState.of(context).pathParameters['id'] ?? '';
    final detailAsync = ref.watch(campaignDetailProvider(id));

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBarWSWidget.getAppbarWidget(
          title: "Detail Sedekah", context: context, elevation: 0),
      body: detailAsync.when(
          data: (detail) => layout(detail, id, context),
          loading: () => CircularProgressIndicator(),
          error: (error, stack) => layout(<String, dynamic>{}, id, context)),
    );
  }
}
