import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:masjid_app/components/button/outlinebutton.dart';
import 'package:masjid_app/components/layout/app_bar_ws.dart';
import 'package:masjid_app/components/partial/list_ui.dart';
import 'package:masjid_app/providers/quran_settings_providers.dart';

class AlquranPengaturanPage extends ConsumerWidget {
  const AlquranPengaturanPage({super.key});

  Widget _layout(WidgetRef ref, BuildContext context) {
    return SafeArea(
      top: false,
      child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 21, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        "Umum",
                        maxLines: 1,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize:
                              Theme.of(context).textTheme.titleSmall?.fontSize,
                        ),
                      ),
                      AutoSizeText(
                        "Pengaturan umum Al Quran",
                        maxLines: 1,
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: const Color(0xFF929292),
                          fontSize:
                              Theme.of(context).textTheme.bodySmall?.fontSize,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 21, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AutoSizeText(
                              "Qori Murotal",
                              maxLines: 1,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.fontSize,
                              ),
                            ),
                            AutoSizeText(
                              "Pilih Qori untuk murotal Quran",
                              maxLines: 1,
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                color: const Color(0xFF929292),
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.fontSize,
                              ),
                            ),
                          ],
                        ),
                        ButtonOutline(
                            onPressed: () {},
                            radius: 5,
                            title: "Mishari",
                            shadow: false,
                            width: MediaQuery.of(context).size.width / 3.5)
                      ],
                    )),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 21, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        "Quran Media",
                        maxLines: 1,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize:
                              Theme.of(context).textTheme.titleSmall?.fontSize,
                        ),
                      ),
                      AutoSizeText(
                        "Download data quran & murotal untuk pemkaian tanpa internet",
                        maxLines: 2,
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: const Color(0xFF929292),
                          fontSize:
                              Theme.of(context).textTheme.bodySmall?.fontSize,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 21, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        "Mushaf",
                        maxLines: 1,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize:
                              Theme.of(context).textTheme.titleSmall?.fontSize,
                        ),
                      ),
                      ListItemUiWidget(
                        showIcon: IconPosition.both,
                        iconLeft: const Icon(
                          Icons.import_contacts_rounded,
                          color: Color(0xFFADADAD),
                        ),
                        id: 1,
                        typeDivider: TypeDivider.none,
                        title: "Mushaf Indonesia",
                        titleStyle: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(
                                fontWeight: FontWeight.w300,
                                color: Colors.black),
                        iconRight: Row(
                          children: [
                            Icon(
                              Icons.check_circle_outline_rounded,
                              color: Theme.of(context).primaryColor,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                  onTap: () {},
                                  borderRadius: BorderRadius.circular(20),
                                  splashColor:
                                      Colors.green.withValues(alpha: 0.5),
                                  child: const Icon(
                                    Icons.delete_rounded,
                                    color: Colors.black,
                                  )),
                            )
                          ],
                        ),
                      ),
                      ListItemUiWidget(
                        showIcon: IconPosition.both,
                        iconLeft: const Icon(
                          Icons.import_contacts_rounded,
                          color: Color(0xFFADADAD),
                        ),
                        id: 1,
                        typeDivider: TypeDivider.none,
                        title: "Mushaf Indonesia Tajwid",
                        titleStyle: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(
                                fontWeight: FontWeight.w300,
                                color: Colors.black),
                        iconRight: Row(
                          children: [
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                  onTap: () async {
                                    _showPopup(context);
                                    ref
                                        .read(quranDownloadProvider.notifier)
                                        .downloadFile("halaman");
                                  },
                                  borderRadius: BorderRadius.circular(20),
                                  splashColor:
                                      Colors.green.withValues(alpha: 0.5),
                                  child: const Icon(
                                    Icons.download_rounded,
                                    color: Colors.black,
                                  )),
                            )
                          ],
                        ),
                      ),
                      ListItemUiWidget(
                        showIcon: IconPosition.both,
                        iconLeft: const Icon(
                          Icons.import_contacts_rounded,
                          color: Color(0xFFADADAD),
                        ),
                        id: 1,
                        typeDivider: TypeDivider.none,
                        title: "Mushaf Indonesia",
                        titleStyle: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(
                                fontWeight: FontWeight.w300,
                                color: Colors.black),
                        iconRight: Row(
                          children: [
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                  onTap: () {
                                    _showPopup(context);
                                  },
                                  borderRadius: BorderRadius.circular(20),
                                  splashColor:
                                      Colors.green.withValues(alpha: 0.5),
                                  child: const Icon(
                                    Icons.download_rounded,
                                    color: Colors.black,
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 21, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        "Murotal",
                        maxLines: 1,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize:
                              Theme.of(context).textTheme.titleSmall?.fontSize,
                        ),
                      ),
                      ListItemUiWidget(
                        showIcon: IconPosition.both,
                        iconLeft: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              "assets/img/murotal/mishari.jpg",
                              height: 80,
                              width: 80,
                              fit: BoxFit.cover,
                            )),
                        id: 1,
                        typeDivider: TypeDivider.none,
                        title: "Mishari Alafasy",
                        subTitle: "Mishari bin Rashed Alafasy",
                        titleStyle: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }

  void _showPopup(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext bc) {
          return Consumer(builder: (c, consumerRef, child) {
            final state = consumerRef.watch(quranDownloadProvider);
            return Dialog(
              elevation: 0,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7.0)),
              child: Container(
                  padding: const EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width,
                  height: 170,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Mendownload",
                        style: Theme.of(bc).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      LinearProgressIndicator(
                        borderRadius: const BorderRadius.all(Radius.zero),
                        color: Theme.of(bc).primaryColor,
                        backgroundColor: const Color(0xFFD9D9D9),
                        value: state.progresDownload,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AutoSizeText(
                            "${state.totalTerDownload}/604",
                            maxLines: 1,
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              color: Colors.black,
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.fontSize,
                            ),
                          ),
                          AutoSizeText(
                            "${state.persenDownload}%",
                            maxLines: 1,
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              color: Colors.black,
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.fontSize,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Align(
                          alignment: Alignment.centerRight,
                          child: state.paused
                              ? Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                      onTap: () {
                                        consumerRef
                                            .read(quranDownloadProvider.notifier)
                                            .resumeDownload();
                                      },
                                      borderRadius: BorderRadius.circular(20),
                                      splashColor:
                                          Colors.green.withValues(alpha: 0.5),
                                      child: Text("Lanjutkan",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            color: Colors.black,
                                            fontSize: Theme.of(context)
                                                .textTheme
                                                .titleSmall
                                                ?.fontSize,
                                          ))),
                                )
                              : Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                      onTap: () {
                                        consumerRef
                                            .read(quranDownloadProvider.notifier)
                                            .cancelDownload();
                                      },
                                      borderRadius: BorderRadius.circular(20),
                                      splashColor:
                                          Colors.green.withValues(alpha: 0.5),
                                      child: Text("Pause",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            color: Colors.black,
                                            fontSize: Theme.of(context)
                                                .textTheme
                                                .titleSmall
                                                ?.fontSize,
                                          ))),
                                ))
                    ],
                  )),
            );
          });
        });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light));
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      extendBodyBehindAppBar: false,
      resizeToAvoidBottomInset: false,
      appBar: AppBarWSWidget.getAppbarWidget(
          title: "Pengaturan Alquran",
          context: context,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          color: Colors.white,
          titleAlign: Alignment.centerLeft,
          backgroundColor: const Color(0xFF048C7C)),
      body: ref.watch(quranDownloadProvider).isLoadingList
          ? const Center(child: CircularProgressIndicator())
          : _layout(ref, context),
    );
  }
}
