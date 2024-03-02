
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class ListAyatWidget extends StatelessWidget {
  ListAyatWidget({
    super.key,
    required this.id,
    this.nomor,
    this.ayat,
    this.descEN,
    this.descIDN,
    this.audioFile,
    this.onTap,
    this.activeColor,
    required this.bookmarked
  });

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
    return Column(children: [
      Container(
          width: Get.width,
          // height: 210,
          color: Color.fromARGB(255, 233, 233, 233),
          constraints: BoxConstraints.loose(Size.infinite),
          child: Row(
            children: [
              Container(
                width: 50,
                padding: EdgeInsets.only(left: 15, right: 15),
                constraints: BoxConstraints.loose(Size.infinite),
                color: Color.fromARGB(255, 233, 233, 233),
                child: Align(
                  alignment:
                      Alignment.center, // Align the content vertically center
                  child: Column(
                    children: <Widget>[
                      // Baris pertama
                      Container(
                        height: 42,
                        width: 42,
                        child: Stack(
                          children: <Widget>[
                            InkWell(
                                    onTap: onTap,
                                    child: SvgPicture.asset( bookmarked ? 'assets/icons/active_bookmark.svg' : 'assets/icons/bookmark.svg',
                                      alignment: Alignment.center,
                                      width: 28,
                                      height: 28,
                                    ),
                                  ),
                          ],
                        ),
                      ),
                      Container(
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
                            Positioned.fill(
                              child: Center(
                                child: Text(
                                  nomor!,
                                  style: context.textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Baris kedua
                      Container(
                        height: 42,
                        width: 42,
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Center(
                                child: InkWell(
                                    onTap: () async { 
                                      if (onplay.value) {
                                      print("clicked pause");
                                      audioPosition = audioPlayer.position;
                                      await audioPlayer.pause();
                                      onplay.value = false;
                                    } else {
                                      print("clicked play");
                                      if (audioPosition != null) {
                                        await audioPlayer.seek(audioPosition!);
                                      } else {
                                        await audioPlayer.setUrl(audioFile!);
                                      }
                                      await audioPlayer.play();
                                      onplay.value = true;

                                      audioPlayer.playerStateStream.listen((PlayerState state) {
                                        if (state.processingState == ProcessingState.completed) {
                                          // File selesai diputar
                                          print("Selesai");
                                          audioPosition = null;
                                          onplay.value = false;
                                        }
                                      });
                                    }
                                    },
                                    child: Obx(() => onplay.value
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
                                    )
                                  ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                  child: Container(
                padding: EdgeInsets.all(15),
                color: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
              ))
            ],
          )),
      Divider(
        color: Color.fromARGB(255, 226, 226, 226),
        thickness: 3,
        height: 2,
      ),
    ]);
  }
}
