import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:masjid_app/components/partial/list_ui.dart';
import 'package:masjid_app/configs/file_setup.dart';
import 'package:masjid_app/models/kajian_model.dart';
import 'package:masjid_app/models/sosmed_data.dart';
import 'package:masjid_app/providers/akun_provider.dart';
import 'package:masjid_app/providers/kajian_provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart' as refresh;
import 'package:share_plus/share_plus.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';

class DkmPage extends ConsumerStatefulWidget {
  const DkmPage({super.key});

  @override
  ConsumerState<DkmPage> createState() => _DkmPageState();
}

class _DkmPageState extends ConsumerState<DkmPage> {
  final refreshController = refresh.RefreshController(initialRefresh: false);

  static final List<KajianModel> _placeholderQuotes = [
    KajianModel(
        id: 1,
        judul: 'judul',
        subjudul: 'subjudul',
        image: 'https://dummyimage.com/600x400/000/fff',
        link: 'link'),
    KajianModel(
        id: 1,
        judul: 'judul',
        subjudul: 'subjudul',
        image: 'https://dummyimage.com/600x400/000/fff',
        link: 'link'),
    KajianModel(
        id: 1,
        judul: 'judul',
        subjudul: 'subjudul',
        image: 'https://dummyimage.com/600x400/000/fff',
        link: 'link'),
  ];

  @override
  void dispose() {
    refreshController.dispose();
    super.dispose();
  }

  Future<void> _share(KajianModel item) async {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(screenWidth / 50),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                item.judul,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: screenWidth / 25),
              ),
            ),
            Container(
              width: screenWidth / 1.4,
              height: screenHeight / 4.5,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(screenWidth / 50),
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(item.image),
                    fit: BoxFit.fitWidth,
                  )),
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFF92E3A9),
                foregroundColor: Colors.black,
              ),
              onPressed: () async {
                final result = await downloadAndSaveFile(
                  url: item.image,
                  pathsave: '/quote',
                );
                final resultShare = await SharePlus.instance.share(
                  ShareParams(
                    files: [XFile(result)],
                    text: '#Dikirim dari Marbot app https://s.id/downloadmarbotapp',
                  ),
                );

                if (resultShare.status == ShareResultStatus.success) {
                  Fluttertoast.showToast(msg: "Berhasil dishare");
                }
                if (dialogContext.mounted) {
                  Navigator.of(dialogContext).pop();
                }
              },
              child: const Text('Share Sekarang'),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  refresh.SmartRefresher layout(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final kontakAsync = ref.watch(dkmKontakProvider);
    final version = ref.watch(appVersionProvider).valueOrNull ?? '0.0.0';

    return refresh.SmartRefresher(
      enablePullDown: true,
      controller: refreshController,
      onLoading: () async {
        ref.invalidate(kajianSliderProvider('quotes'));
        ref.invalidate(dkmKontakProvider);
        await ref.read(kajianSliderProvider('quotes').future);
        await ref.read(dkmKontakProvider.future);
        refreshController.loadComplete();
      },
      onRefresh: () async {
        refreshController.refreshCompleted();
      },
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            Container(
              width: screenWidth,
              height: screenWidth / 2,
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
                      "assets/img/new-logo-text.png",
                      fit: BoxFit.contain,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Align(
                        alignment: Alignment.center,
                        child: AutoSizeText(
                            "Di bawah Naungan Allah, kita bersatu dalam keimanan di Masjid, tempat keberkahan dan ketenangan merajut jalinan kasih dan do'a.",
                            maxLines: 4,
                            presetFontSizes: [screenWidth / 35],
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                    fontWeight: FontWeight.normal,
                                    letterSpacing: 0.5,
                                    color: Colors.white)),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                // TODO(migrasi): route '/quote' (QuotePage) belum terdaftar di
                // GoRouter; halaman tersebut masih memakai GetX.
              },
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth / 20),
                  child: Text(
                    "Lihat Semua",
                    style: TextStyle(
                        color: Colors.black87, fontSize: screenWidth / 30),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            getListCategory(context),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Kontak Kami",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black38)),
                    ),
                    kontakAsync.isLoading
                        ? SizedBox(
                            height: 30,
                          )
                        : ListView.builder(
                            physics: const ClampingScrollPhysics(),
                            itemCount: kontakAsync.valueOrNull?.length ?? 0,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final SosmedData item =
                                  kontakAsync.valueOrNull![index];
                              return ListItemUiWidget(
                                id: item.id,
                                title: item.nama,
                                widthContent:
                                    MediaQuery.of(context).size.width * 0.7,
                                showIcon: IconPosition.left,
                                // iconLeft: SvgPicture.network(item.icon,
                                //     height: 30, width: 30),
                                iconLeft: Image.network(item.icon,
                                    height: 40, width: 40),
                                titleStyle: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                category: item.type,
                                onTap: () async {
                                  final Uri url = Uri.parse(item.link);
                                  if (!await launchUrl(url)) {
                                    // print('Tidak dapat membuka link');
                                    Fluttertoast.showToast(
                                      msg: "Tidak dapat membuka link",
                                    );
                                  }
                                },
                              );
                            },
                          ),
                    SizedBox(
                      height: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Align(
                        //   alignment: Alignment.center,
                        //   child: Text(
                        //     "Marbot Apps Supporting Formasi Satu",
                        //     style: context.textTheme.bodySmall?.copyWith(
                        //         fontWeight: FontWeight.bold,
                        //         color: Colors.black),
                        //   ),
                        // ),
                        // Image.asset(
                        //   "assets/img/formasi-satu.png",
                        //   // height: 85,
                        //   width: 180,
                        //   alignment: Alignment.centerLeft,
                        // ),
                        SizedBox(
                          height: 5,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Marbot App version $version",
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                    fontSize: screenWidth / 35,
                                    color: Colors.black),
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                      ],
                    ),
                    // ListView.builder(
                    //   physics: const ClampingScrollPhysics(),
                    //   itemCount: ctrl.listKontakv2.length,
                    //   shrinkWrap: true,
                    //   itemBuilder: (context, index) {
                    //     // Datum model = filteredEvents[index];
                    //     return FadeInUp(
                    //       child: ListItemUiWidget(
                    //         id: ctrl.listKontakv2[index]['id'],
                    //         title: ctrl.listKontakv2[index]['title'],
                    //         widthContent:
                    //             MediaQuery.of(context).size.width * 0.7,
                    //         showIcon: IconPosition.left,
                    //         iconLeft: SvgPicture.asset(
                    //             ctrl.listKontakv2[index]['icon'],
                    //             height: 30,
                    //             width: 30),
                    //         titleStyle: context.textTheme.bodySmall
                    //             ?.copyWith(
                    //                 fontWeight: FontWeight.bold,
                    //                 color: Colors.black),
                    //         category: ctrl.listKontakv2[index]['category'],
                    //         onTap: () async {
                    //           final Uri url = Uri.parse(
                    //               ctrl.listKontakv2[index]['link']);
                    //           if (!await launchUrl(url)) {
                    //             print('Tidak dapat membuka link.');
                    //           }
                    //         },
                    //         // subtitleStyle: context.textTheme.bodySmall
                    //         //     ?.copyWith(
                    //         //         fontWeight: FontWeight.normal,
                    //         //         color: Colors.black),
                    //       ),
                    //     );
                    //   },
                    // )
                  ],
                ))
          ],
        ),
      ),
    );
  }

  Container getListCategory(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final sliderAsync = ref.watch(kajianSliderProvider('quotes'));
    final listQuotes = sliderAsync.valueOrNull ?? _placeholderQuotes;

    return Container(
      height: screenHeight / 4.5,
      margin: const EdgeInsets.only(left: 15),
      child: Skeletonizer(
        ignoreContainers: false,
        enabled: sliderAsync.isLoading,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemCount: listQuotes.length,
          separatorBuilder: (context, index) => const SizedBox(width: 5),
          itemBuilder: (context, index) {
            final KajianModel item = listQuotes[index];
            return GestureDetector(
              onTap: () {
                _share(item);
              },
              child: Container(
                width: screenWidth / 1.4,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(screenWidth / 50),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(item.image),
                      fit: BoxFit.fitWidth,
                    )),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: layout(context),
    );
  }
}
