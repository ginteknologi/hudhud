import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:html/parser.dart';
import 'package:masjid_app/components/button/elevatedbutton.dart';
import 'package:masjid_app/components/layout/app_bar_ws.dart';
import 'package:masjid_app/models/doa_data.dart';
import 'package:masjid_app/providers/doa_providers.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:share_plus/share_plus.dart';

class ContentDoaPage extends ConsumerWidget {
  const ContentDoaPage({super.key});

  String _convertHtmlToText(String htmlString) {
    final document = parse(htmlString);
    return parse(document.body!.text).documentElement!.text;
  }

  String _buildShareText(DoaData data) {
    final String judul = data.judul.isNotEmpty ? '${data.judul}\n\n' : '';
    final String arabic = data.arabic != null ? '${data.arabic}\n\n' : '';
    final String transliteration = data.transliteration != null
        ? '${_convertHtmlToText(data.transliteration!)}\n\n'
        : '';
    final String translations = data.translations != null
        ? '${_convertHtmlToText(data.translations!)}\n\n'
        : '';
    final String isi = data.isi != null
        ? '${_convertHtmlToText(data.isi!)}\n\n'
        : '';

    const String link = 'Dibagikan dari aplikasi\n Marbot App';
    return '$judul $arabic $transliteration $translations $isi $link';
  }

  SafeArea layout(DoaData data, BuildContext context) {
    return SafeArea(
        child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        decoration: const BoxDecoration(color: Colors.white),
                        child: Padding(
                            padding: const EdgeInsets.only(
                                left: 21, right: 21, top: 21),
                            child: Column(
                              children: [
                                Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                        highlightColor: Colors.transparent,
                                        splashColor:
                                            Colors.green.withValues(alpha: 0.5),
                                        child: Card(
                                          elevation: 0,
                                          color: Colors.white,
                                          margin:
                                              const EdgeInsets.only(top: 20),
                                          clipBehavior: Clip.antiAlias,
                                          shape: RoundedRectangleBorder(
                                            side: const BorderSide(
                                              color: Color(0xFFDADADA),
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            //set border radius more than 50% of height and width to make circle
                                          ),
                                          child: Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              constraints: BoxConstraints.loose(
                                                  Size.infinite),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10,
                                                    left: 10,
                                                    right: 10,
                                                    bottom: 5),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: AutoSizeText(
                                                            data.judul,
                                                            textAlign:
                                                                TextAlign.start,
                                                            style: Theme.of(context)
                                                                .textTheme
                                                                .titleSmall
                                                                ?.copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .primaryColor),
                                                            maxLines: 2,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        data.arabic != null
                                                            ? Align(
                                                                alignment:
                                                                    Alignment
                                                                        .centerRight,
                                                                child:
                                                                    AutoSizeText(
                                                                  data.arabic!,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                  style: Theme.of(context)
                                                                      .textTheme
                                                                      .titleSmall
                                                                      ?.copyWith(
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                  maxLines: 2,
                                                                ))
                                                            : Container(),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        data.transliteration !=
                                                                null
                                                            ? Text(
                                                                data.transliteration!,
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                style: Theme.of(context)
                                                                    .textTheme
                                                                    .labelMedium
                                                                    ?.copyWith(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w300,
                                                                        color: Colors
                                                                            .black54))
                                                            : Container(),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        data.translations !=
                                                                null
                                                            ? Align(
                                                                alignment:
                                                                    Alignment
                                                                        .bottomRight,
                                                                child: HtmlWidget(
                                                                    data.translations!,
                                                                    textStyle: const TextStyle(fontSize: 13.0),
                                                                  ))
                                                            : Container(),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        data.isi != null
                                                            ? Align(
                                                                alignment: Alignment
                                                                    .bottomRight,
                                                                child: HtmlWidget(
                                                                    data.isi!,
                                                                    textStyle: const TextStyle(fontSize: 13.0),
                                                                  ))
                                                            : Container(),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        // Text(DateFormat('dd MMMM yyyy').format( DateTime.parse(list[index]['date'])),
                                                        // style: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w300),
                                                        // ),

                                                        // AutoSizeText(
                                                        //   list[index]['isi'],
                                                        //   textAlign: TextAlign.end,
                                                        //   style: Theme.of(context).textTheme.labelSmall
                                                        //       ?.copyWith(
                                                        //           fontWeight: FontWeight.bold,
                                                        //           letterSpacing: 0,
                                                        //           color: Colors.black54),
                                                        //   maxLines: 2,
                                                        // ),
                                                        // Text(list[index]['isi'],
                                                        //     textAlign: TextAlign.start,
                                                        //     style: context
                                                        //         .textTheme.labelSmall
                                                        //         ?.copyWith(
                                                        //             fontWeight:
                                                        //                 FontWeight.bold,
                                                        //             letterSpacing: 0,
                                                        //             color: Colors.black54)),
                                                        const Row(
                                                          children: [
                                                            // Icon(
                                                            //   Icons.remove_red_eye_rounded,
                                                            //   color: Colors.black54,
                                                            //   size: Theme.of(context).textTheme
                                                            //       .labelLarge?.fontSize,
                                                            // ),
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            // Text(
                                                            //     ctrl.listDoa[index]['viewer'],
                                                            //     textAlign: TextAlign.end,
                                                            //     style: context
                                                            //         .textTheme.labelMedium
                                                            //         ?.copyWith(
                                                            //             fontWeight:
                                                            //                 FontWeight.w300,
                                                            //             color:
                                                            //                 Colors.black54)),
                                                          ],
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              )), //SizedBox
                                        ))),
                                const SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  // height: 53,
                                  width:
                                      MediaQuery.of(context).size.width,
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Container(
                                          padding:
                                              const EdgeInsets.only(right: 13.0),
                                          child: AutoSizeText(
                                              "Yuk ingetin yang lain!",
                                              maxLines: 1,
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor,
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
                                            width:
                                                MediaQuery.of(context).size.width,
                                            bgcolor: const Color(0xFF92E3A9),
                                            height: 35,
                                            color: Colors.black,
                                            radius: 5,
                                            size: 12,
                                            // size: Theme.of(context)
                                            //     .textTheme
                                            //     .bodySmall
                                            //     ?.fontSize,
                                            showIcon: "right",
                                            iconRight: Icon(
                                              Icons.share,
                                              size: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.fontSize,
                                            ),
                                            onPressed: () {
                                              // Gunakan plugin share_plus untuk berbagi teks artikel
                                              SharePlus.instance.share(
                                                ShareParams(
                                                  text: _buildShareText(data),
                                                  subject: data.judul,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            )),
                      )
                    ]))));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contentId =
        GoRouterState.of(context).pathParameters['content'] ?? '';
    final doaAsync = ref.watch(doaDetailProvider(contentId));

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBarWSWidget.getAppbarWidget(
          title: "Do'a > Do'a Harian > Detail", context: context, elevation: 0),
      body: doaAsync.when(
        loading: () => const CircularProgressIndicator(),
        error: (_, __) => const SizedBox.shrink(),
        data: (data) => layout(
            data ?? DoaData(id: 1, judul: '', updatedAt: ''), context),
      ),
    );
  }
}
