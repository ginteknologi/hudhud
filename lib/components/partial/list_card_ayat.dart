// ignore_for_file: unnecessary_null_comparison

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class ListCardAyatWidget extends StatelessWidget {
  ListCardAyatWidget(
      {super.key,
      required this.id,
      this.nomor,
      this.ayat,
      this.descEN,
      this.descIDN,
      this.audioFile,
      this.onTap,
      this.activeColor,
      required this.bookmarked});

  int id;
  String? nomor;
  String? ayat;
  String? descEN;
  String? descIDN;
  String? audioFile;
  bool bookmarked;
  VoidCallback? onTap;
  RxBool onplay = false.obs;
  AudioPlayer audioPlayer = AudioPlayer();
  Duration? audioPosition;
  Color? activeColor;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Card(
          elevation: 3,
          color: activeColor ?? Colors.white,
          margin: const EdgeInsets.only(top: 20),
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            //set border radius more than 50% of height and width to make circle
          ),
          child: Container(
              width: Get.width,
              // height: 210,
              constraints: BoxConstraints.loose(Size.infinite),
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 45,
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Color(0xFF92E3A9),
                          borderRadius: BorderRadius.all(Radius.circular(7))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: 42,
                            width: 42,
                            child: Stack(
                              children: <Widget>[
                                SvgPicture.asset(
                                  'assets/icons/list_star.svg',
                                  alignment: Alignment.center,
                                  width: 42,
                                  height: 42,
                                ),
                                Container(
                                  child: Column(
                                    children: <Widget>[
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            nomor!,
                                            style: context.textTheme.bodySmall
                                                ?.copyWith(
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Material(
                              color: Colors.transparent,
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: onTap,
                                    child: SvgPicture.asset( bookmarked ? 'assets/icons/active_bookmark.svg' : 'assets/icons/bookmark.svg',
                                      alignment: Alignment.center,
                                      width: 28,
                                      height: 28,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      if (audioPlayer.position == null) {
                                        print("clicked play position null");
                                        audioPlayer.setUrl(audioFile!);
                                        audioPlayer.play();
                                        onplay.value = true;
                                      } else if (onplay.value) {
                                        print("clicked pause");
                                        audioPosition = audioPlayer.position;
                                        audioPlayer.pause();
                                        onplay.value = false;
                                      } else {
                                        print("clicked play");
                                        if (audioPosition != null) {
                                          audioPlayer.seek(audioPosition!);
                                        } else {
                                          audioPlayer.setUrl(audioFile!);
                                        }
                                        audioPlayer.play();
                                        onplay.value = true;

                                        audioPlayer.playerStateStream
                                            .listen((PlayerState state) {
                                          if (state.processingState ==
                                              ProcessingState.completed) {
                                            // File selesai diputar
                                            print("Selesai");
                                            audioPosition = null;
                                            onplay.value = false;
                                          }
                                        });
                                      }
                                    },
                                    child: onplay.value
                                        ? Icon(
                                            Icons.pause_rounded,
                                            color:
                                                Theme.of(context).primaryColor,
                                          )
                                        : Icon(
                                            Icons.play_arrow_rounded,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                  ),
                                ],
                              ))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    // Container(
                    //   height: 500,
                    //   decoration:
                    //       BoxDecoration(color: Colors.red),
                    // )
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: AutoSizeText(
                            ayat!,
                            textAlign: TextAlign.end,
                            style: context.textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                            maxLines: 15,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: AutoSizeText(
                              descEN!,
                              textAlign: TextAlign.start,
                              style: context.textTheme.labelMedium?.copyWith(
                                  fontWeight: FontWeight.w300,
                                  fontStyle: FontStyle.italic),
                            )),
                        SizedBox(
                          height: 20,
                        ),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: AutoSizeText(
                              descIDN!,
                              textAlign: TextAlign.start,
                              style: context.textTheme.labelMedium?.copyWith(
                                fontWeight: FontWeight.w300,
                              ),
                            ))
                      ],
                    )
                  ],
                ),
              )), //SizedBox
        ));
  }
}
