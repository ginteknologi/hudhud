import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:masjid_app/components/button/elevatedbutton.dart';
import 'package:masjid_app/components/layout/app_bar_ws.dart';
import 'package:masjid_app/components/partial/list_card_ui.dart';
import 'package:masjid_app/configs/file_setup.dart';
import 'package:masjid_app/core/router/app_router.dart';
import 'package:masjid_app/models/artikel_data.dart';
import 'package:masjid_app/providers/artikel_provider.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:share_plus/share_plus.dart';

class DetailArtikelPage extends ConsumerWidget {
  const DetailArtikelPage({super.key});

  SafeArea layout(BuildContext context, ArtikelDetailResult result) {
    final detail = result.detail;
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
        child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: width / 30),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                          elevation: 0,
                          color: const Color(0xFFF5F5F5),
                          margin: const EdgeInsets.only(top: 20),
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            //set border radius more than 50% of height and width to make circle
                          ),
                          child: Container(
                            width: width,
                            height: 170,
                            constraints: BoxConstraints.loose(Size.infinite),
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(detail.image),
                                    fit: BoxFit.cover)),
                          )),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 5),
                        child: Text(
                          detail.categoryArtikel?['name'] ?? '',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 12),
                        ),
                      ),
                      AutoSizeText(
                        detail.judul,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold, color: Colors.black),
                        maxLines: 4,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                          DateFormat('HH:mm | dd MMMM yyyy').format(
                              DateTime.parse(detail.updatedAt)
                                  .add(Duration(hours: 7))),
                          // '17:40' +
                          //     "  |  " +
                          //     '17 Agustus 2023',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0,
                              color: Colors.black)),
                      const SizedBox(
                        height: 20,
                      ),
                      // Html(
                      //   data: (ctrl.detail.value.isi ?? '')
                      //       .replaceAllMapped(
                      //           RegExp(r'\n{2,}'), (match) => '\n')
                      //       .replaceAll('<br><br>', '<br>')
                      //       .replaceAll('<p></p>', '')
                      //       .trim(),
                      //   style: {
                      //     'body': Style(
                      //         margin: Margins.zero, padding: HtmlPaddings.zero),
                      //     'h2': Style(
                      //         fontSize: FontSize(18.0),
                      //         fontWeight: FontWeight.bold,
                      //         margin: Margins.zero),
                      //     'h3': Style(
                      //         fontSize: FontSize(18.0),
                      //         fontWeight: FontWeight.bold,
                      //         margin: Margins.zero),
                      //     'p': Style(
                      //         fontSize: FontSize.medium,
                      //         margin: Margins.zero,
                      //         padding: HtmlPaddings.zero,
                      //         lineHeight: LineHeight(1.2),
                      //         textAlign: TextAlign.justify),
                      //     'br': Style(margin: Margins.only(bottom: 0.1)),
                      //     'b': Style(
                      //       fontWeight: FontWeight.bold,
                      //     ),
                      //     'i': Style(
                      //       fontStyle: FontStyle.italic,
                      //     ),
                      //     'a': Style(
                      //       color: Colors.blue,
                      //     ),
                      //   },
                      // ),
                      HtmlWidget(
                        detail.isi ?? '',
                        customStylesBuilder: (element) {
                          if (element.localName == 'p') {
                            return {
                              'margin': '0px 0px 2px 0px',
                              'padding': '0px 0px 0px 0px',
                              'text-align': 'justify',
                              'font-size': '14px',
                            };
                          }
                          if (element.localName == 'br') {
                            return {
                              'margin': '0px 0px 0px 0px',
                              'padding': '0px 0px 0px 0px'
                            };
                          }
                          if (element.localName == 'h2' ||
                              element.localName == 'h3') {
                            return {'font-size': '18px', 'font-weight': 'bold'};
                          }
                          return null;
                        },
                        textStyle: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Divider(
                        color: Colors.black38,
                      ),
                      Container(
                        // height: 53,
                        width: width,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.only(right: 13.0),
                                child: AutoSizeText("Yuk ingetin yang lain!",
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: Theme.of(context)
                                            .textTheme
                                            .labelLarge
                                            ?.fontSize,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                            Flexible(
                              child: SizedBox(
                                width: double.infinity,
                                child: ButtonElevated(
                                  title: 'Bagikan',
                                  width: width,
                                  bgcolor: const Color(0xFF92E3A9),
                                  height: 35,
                                  color: Colors.black,
                                  radius: 5,
                                  size: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.fontSize,
                                  showIcon: "right",
                                  iconRight: Icon(
                                    Icons.share,
                                    size: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.fontSize,
                                  ),
                                  onPressed: () async {
                                    final file = await downloadAndSaveFile(
                                      url: detail.image,
                                      pathsave: '/artikel',
                                    );
                                    final resultshare =
                                        await SharePlus.instance.share(
                                      ShareParams(
                                          files: [XFile(file)],
                                          text: result.share,
                                          subject: detail.judul),
                                    );
                                    if (resultshare.status ==
                                        ShareResultStatus.success) {
                                      Fluttertoast.showToast(
                                          msg: "Berhasil dishare");
                                    }
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const Divider(
                        color: Colors.black38,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Artikel Lainnya",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      getListArtikel(result.lainnya, context),
                      SizedBox(
                        height: 20,
                      )
                    ]))));
  }

  ListView getListArtikel(List<ArtikelData> listArtikels, BuildContext context) {
    return ListView.builder(
      physics: const ClampingScrollPhysics(),
      itemCount: listArtikels.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        // Datum model = filteredEvents[index];
        final artikel = listArtikels[index];
        return FadeInUp(
          child: ListCardUiWidget(
            id: artikel.id,
            title: artikel.judul,
            position: MainAxisAlignment.end,
            usingDivider: false,
            height: 170,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(artikel.image), fit: BoxFit.cover)),
            titleStyle: Theme.of(context).textTheme.titleSmall
                ?.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
            marginSeparator: 0,
            subtitleStyle: Theme.of(context).textTheme.labelMedium
                ?.copyWith(fontWeight: FontWeight.bold, color: Colors.black45),
            onTap: () {
              context.push('${AppRoutes.artikel}/${artikel.id}');
              // Get.offAllNamed(
              //     '${RoutesArtikel.root}/${ctrl.listArtikels[index].id}');
            },
            hasFooter: true,
            footerContent: [
              Text(
                  DateFormat('HH:mm | dd MMMM yyyy').format(
                      DateTime.parse(artikel.updatedAt)
                          .add(const Duration(hours: 7))),
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w300,
                      letterSpacing: 0,
                      color: Colors.white)),
              Row(
                children: [
                  // Icon(
                  //   Icons.remove_red_eye_rounded,
                  //   color: Colors.white,
                  //   size: Theme.of(context).textTheme.labelLarge?.fontSize,
                  // ),
                  const SizedBox(
                    width: 5,
                  ),
                  // Text(ctrl.listArtikels[index]['viewer'],
                  //     textAlign: TextAlign.end,
                  //     style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  //         fontWeight: FontWeight.w300, color: Colors.white)),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = int.tryParse(GoRouterState.of(context).pathParameters['id'] ?? '') ?? 0;
    final detailAsync = ref.watch(artikelDetailProvider(id));
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBarWSWidget.getAppbarWidget(
          title: "Artikel Detail", context: context, elevation: 0),
      body: detailAsync.when(
        data: (result) => layout(context, result),
        loading: () => Center(child: CircularProgressIndicator()),
        error: (err, stack) => layout(
            context,
            ArtikelDetailResult(
              detail: ArtikelData(
                id: id,
                judul: '',
                image: '',
                updatedAt: DateTime.now().toIso8601String(),
                publishDate: '',
              ),
              lainnya: const [],
              share: '',
            )),
      ),
    );
  }
}
