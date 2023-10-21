import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mesjid_app/routes/sedekah/index.dart';
import 'package:mesjid_app/theme.dart';

class ListCardAyatWidget extends StatelessWidget {
  ListCardAyatWidget(
      {required this.id,
      this.nomor,
      this.ayat,
      this.descEN,
      this.descIDN,
      this.onTap,
      required this.bookmark,
      required this.bookmarked});

  int id;
  String? nomor;
  String? ayat;
  String? descEN;
  String? descIDN;
  bool bookmarked;
  VoidCallback? onTap;
  RxBool bookmark = false.obs;
  @override
  Widget build(BuildContext context) {
    return Obx(() => Card(
          elevation: 3,
          color: Colors.white,
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
                                    child: SvgPicture.asset(
                                      bookmark.value
                                          ? 'assets/icons/active_bookmark.svg'
                                          : 'assets/icons/bookmark.svg',
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
                                      print("clicked play");
                                    },
                                    child: Icon(
                                      Icons.play_arrow_rounded,
                                      color: Theme.of(context).primaryColor,
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
