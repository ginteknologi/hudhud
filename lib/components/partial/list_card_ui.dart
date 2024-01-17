import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masjid_app/routes/sedekah/index.dart';
import 'package:masjid_app/theme.dart';
import 'package:flutter_html/flutter_html.dart';

class ListCardUiWidget extends StatelessWidget {
  ListCardUiWidget(
      {required this.id,
      this.type,
      this.title,
      this.subtitle,
      this.titleStyle,
      this.subtitleStyle,
      this.onTap,
      this.decoration,
      this.elevation = 0,
      this.footerContent = const [],
      this.hasFooter = false,
      this.position,
      this.height,
      this.marginSeparator,
      this.usingDivider = true});

  int id;
  String? type;
  String? title;
  TextStyle? titleStyle;
  String? subtitle;
  TextStyle? subtitleStyle;
  BoxDecoration? decoration;
  bool hasFooter;
  bool usingDivider;
  VoidCallback? onTap;
  double? elevation;
  MainAxisAlignment? position;
  double? height;
  double? marginSeparator;
  final List<Widget> footerContent;

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        child: InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.green.withOpacity(0.5),
            onTap: onTap,
            child: Card(
              elevation: elevation,
              color: Colors.white,
              margin: const EdgeInsets.only(top: 20),
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: Color(0xFFDADADA),
                ),
                borderRadius: BorderRadius.circular(10),
                //set border radius more than 50% of height and width to make circle
              ),
              child: Container(
                  width: Get.width,
                  height: height,
                  constraints: BoxConstraints.loose(Size.infinite),
                  decoration: decoration,
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: 10, left: 10, right: 10, bottom: 5),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment:
                          position ?? MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: AutoSizeText(
                                title!,
                                textAlign: TextAlign.start,
                                style: titleStyle ??
                                    context.textTheme.titleMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                maxLines: 2,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            if (subtitle != null)
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: type == 'wp'
                                      ? Html(data: subtitle!, style: {
                                          "p": Style(fontSize: FontSize(13.0))
                                        })
                                      : AutoSizeText(
                                          subtitle!,
                                          textAlign: TextAlign.start,
                                          style: subtitleStyle ??
                                              context.textTheme.labelMedium
                                                  ?.copyWith(
                                                fontWeight: FontWeight.w300,
                                              ),
                                        ))
                          ],
                        ),
                        SizedBox(
                          height: marginSeparator ?? 10,
                        ),
                        if (hasFooter && usingDivider)
                          Divider(
                            color: Colors.black26,
                          ),
                        if (hasFooter)
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: footerContent,
                          )
                      ],
                    ),
                  )), //SizedBox
            )));
  }
}
