import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:masjid_app/configs/file_setup.dart';
import 'package:masjid_app/models/sedang_live_data.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SedangLiveWidget extends StatelessWidget {
  final List<SedangLiveData> listSedangLive;
  const SedangLiveWidget({super.key, this.listSedangLive = const []});

  @override
  Widget build(BuildContext context) {
    if (listSedangLive.isEmpty) {
      return const SizedBox();
    }
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFD5EDEA),
      ),
      height: screenHeight / 4.7,
      width: screenWidth,
      padding: EdgeInsets.symmetric(
        vertical: screenWidth / 30,
      ),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth / 30),
              child: AutoSizeText(
                "Sedang Live",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    fontSize:
                        Theme.of(context).textTheme.titleMedium?.fontSize),
              ),
            ),
            SizedBox(
              height: screenWidth / 40,
            ),
            SizedBox(
              width: screenWidth / 2.5,
              height: screenHeight / 8,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: listSedangLive.length,
                itemBuilder: (context, index) {
                  final SedangLiveData item = listSedangLive[index];
                  return Container(
                    width: screenWidth / 1.2,
                    margin: EdgeInsets.only(left: screenWidth / 80),
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                            useSafeArea: false,
                            context: context,
                            builder: (BuildContext dialogContext) {
                              return Dialog(
                                elevation: 3,
                                child: Stack(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(screenWidth / 30),
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(7)),
                                      ),
                                      height: screenHeight / 1.8,
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            AutoSizeText(item.masjid,
                                                maxLines: 2,
                                                presetFontSizes: [
                                                  screenWidth / 28
                                                ],
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    height: 0)),
                                            AutoSizeText(item.title,
                                                maxLines: 2,
                                                presetFontSizes: [
                                                  screenWidth / 28
                                                ],
                                                style: const TextStyle()),
                                            SizedBox(
                                              height: screenWidth / 30,
                                            ),
                                            AutoSizeText(
                                              item.keterangan,
                                              maxLines: 4,
                                              presetFontSizes: [screenWidth / 35],
                                            ),
                                            SizedBox(
                                              height: screenWidth / 30,
                                            ),
                                            AutoSizeText(
                                              item.subtittle,
                                              presetFontSizes: [screenWidth / 35],
                                              maxLines: 2,
                                            ),
                                            SizedBox(
                                              height: screenWidth / 30,
                                            ),
                                            Expanded(
                                              child: Container(
                                                width: screenWidth,
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        fit: BoxFit.fitHeight,
                                                        image:
                                                            CachedNetworkImageProvider(
                                                          item.image,
                                                        ))),
                                              ),
                                            ),
                                            SizedBox(
                                              height: screenWidth / 30,
                                            ),
                                            Row(
                                              children: [
                                                const Spacer(),
                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        const Color(0xFF0685FA),
                                                    foregroundColor:
                                                        Colors.white,
                                                    maximumSize:
                                                        Size(screenWidth / 3, 40),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        screenWidth /
                                                                            80)),
                                                  ),
                                                  onPressed: () async {
                                                    final String filePath =
                                                        await downloadAndSaveFile(
                                                      url: item.image,
                                                      pathsave: '/sedanglive',
                                                    );

                                                    final resultShare =
                                                        await SharePlus.instance
                                                            .share(
                                                      ShareParams(
                                                        files: [
                                                          XFile(filePath)
                                                        ],
                                                        text:
                                                            '${item.masjid}\n${item.title}\n${item.subtittle}\n${item.keterangan}\nBerikut adalah linknya: ${item.link}',
                                                      ),
                                                    );

                                                    if (resultShare.status ==
                                                        ShareResultStatus
                                                            .success) {
                                                      Fluttertoast.showToast(
                                                          msg:
                                                              "Berhasil dishare");
                                                    }
                                                    if (dialogContext.mounted) {
                                                      Navigator.of(dialogContext).pop();
                                                    }
                                                  },
                                                  child: AutoSizeText(
                                                    'Bagikan Live',
                                                    presetFontSizes: [
                                                      screenWidth / 32
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: screenWidth / 50,
                                                ),
                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        const Color(0xFF048C7C),
                                                    foregroundColor:
                                                        Colors.white,
                                                    maximumSize:
                                                        Size(screenWidth / 3, 40),
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    screenWidth /
                                                                        80)),
                                                  ),
                                                  onPressed: () async {
                                                    final Uri url =
                                                        Uri.parse(item.link);
                                                    if (!await launchUrl(url)) {
                                                      if (kDebugMode) {
                                                        debugPrint(
                                                            'Tidak dapat membuka link YouTube.');
                                                      }
                                                    }
                                                  },
                                                  child: AutoSizeText(
                                                    'Tonton Live',
                                                    presetFontSizes: [
                                                      screenWidth / 30
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            )
                                          ]),
                                    ),
                                  ],
                                ),
                              );
                            });
                      },
                      child: Card(
                        color: Colors.white,
                        child: Row(
                          children: [
                            Stack(
                              children: [
                                Container(
                                  width: screenWidth / 5,
                                  margin: EdgeInsets.all(screenWidth / 40),
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(7),
                                      ),
                                      image: DecorationImage(
                                          fit: BoxFit.fitHeight,
                                          image: CachedNetworkImageProvider(
                                            item.image,
                                          ))),
                                ),
                                Positioned(
                                    top: screenWidth / 30,
                                    left: screenWidth / 30,
                                    child: SvgPicture.asset(
                                        "assets/icons/live2.svg")),
                              ],
                            ),
                            Expanded(
                                child: Container(
                              padding: EdgeInsets.only(
                                  top: screenWidth / 40,
                                  right: screenWidth / 40,
                                  bottom: screenWidth / 40),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AutoSizeText(
                                      item.masjid,
                                      maxLines: 2,
                                      presetFontSizes: [
                                        screenWidth / 35,
                                        screenWidth / 40,
                                        screenWidth / 50
                                      ],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Spacer(),
                                    AutoSizeText(
                                      item.title,
                                      maxLines: 1,
                                      presetFontSizes: [screenWidth / 40],
                                    ),
                                    AutoSizeText(
                                      item.subtittle,
                                      maxLines: 1,
                                      presetFontSizes: [screenWidth / 45],
                                      style: const TextStyle(
                                          fontStyle: FontStyle.italic),
                                    )
                                  ]),
                            ))
                          ],
                        ),
                      ),
                    ),
                  );
                },
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
              ),
            )
          ]),
    );
  }
}
