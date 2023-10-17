import 'dart:ffi';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:get/get.dart';
import 'package:mesjid_app/routes/sedekah/index.dart';
import 'package:mesjid_app/theme.dart';

class ListItemUiWidget extends StatelessWidget {
  ListItemUiWidget(
      {required this.id,
      this.category = "category",
      this.title = "title",
      this.titleStyle,
      this.subTitle,
      this.rightContent = const [],
      this.hasRightContent = false,
      this.justify = false,
      this.iconLeft,
      this.iconRight,
      this.typeDivider = TypeDivider.line,
      this.listInset = false,
      this.typeList = TypeList.none,
      this.showIcon = IconPosition.none,
      this.image});

  int id;
  String? category;
  String title;
  TextStyle? titleStyle;
  String? subTitle;
  final List<Widget> rightContent;
  Icon? iconLeft;
  final bool justify;
  final IconPosition showIcon;
  bool hasRightContent;
  Widget? iconRight;
  String? image;
  TypeDivider typeDivider;
  TypeList typeList;
  bool listInset;

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        child: InkWell(
          highlightColor: Colors.transparent,
          onTap: () {},
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: listInset
                    ? EdgeInsets.only(left: 0, top: 10, right: 0)
                    : EdgeInsets.only(left: 0, top: 10, right: 0),
                child: Container(
                  width: Get.width,
                  margin: const EdgeInsets.only(right: 2, bottom: 11),
                  decoration: typeList == TypeList.solid
                      ? BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade300,
                              spreadRadius: 0,
                              blurRadius: 15,
                              offset: Offset(0, 4),
                            ),
                            BoxShadow(
                              color: Colors.white,
                              spreadRadius: 0,
                              blurRadius: 0,
                              offset: Offset(0, 4),
                            ),
                          ],
                        )
                      : BoxDecoration(),
                  child: Row(
                    mainAxisAlignment: justify
                        ? MainAxisAlignment.spaceBetween
                        : MainAxisAlignment.center,
                    children: [
                      if (showIcon == IconPosition.left ||
                          showIcon == IconPosition.both)
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 5,
                          ),
                          child: iconLeft,
                        ),
                      Expanded(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: hasRightContent
                                ? MainAxisAlignment.spaceBetween
                                : MainAxisAlignment.start,
                            children: [
                              Container(
                                constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width *
                                            0.6),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AutoSizeText(
                                      '$category',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.fontSize,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.normal),
                                      maxLines: 1,
                                    ),
                                    AutoSizeText(
                                      '$title',
                                      textAlign: TextAlign.start,
                                      style: titleStyle ??
                                          TextStyle(
                                              fontSize: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium
                                                  ?.fontSize,
                                              color: Colors.black54,
                                              fontWeight: FontWeight.bold),
                                      maxLines: 2,
                                    ),
                                    if (subTitle != null)
                                      AutoSizeText(
                                        '$subTitle',
                                        textAlign: TextAlign.start,
                                        minFontSize: 16,
                                        style: TextStyle(
                                            fontSize: Theme.of(context)
                                                .textTheme
                                                .titleSmall
                                                ?.fontSize,
                                            color: Colors.black87,
                                            fontWeight: FontWeight.w500),
                                        maxLines: 2,
                                      )
                                  ],
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: rightContent,
                              )
                            ],
                          )),
                      if (showIcon == IconPosition.right ||
                          showIcon == IconPosition.both)
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 5,
                          ),
                          child: iconRight,
                        ),
                    ],
                  ),
                ),
              ),
              if (typeDivider == TypeDivider.dashed)
                Row(
                  children: List.generate(
                      150 ~/ 2,
                      (index) => Expanded(
                            child: Container(
                              color: index % 2 == 0
                                  ? Colors.transparent
                                  : Colors.grey,
                              height: 2,
                            ),
                          )),
                ),
              if (typeDivider == TypeDivider.line)
                const Divider(color: Colors.black38),
            ],
          ),
        ));
  }
}

enum TypeDivider { line, dotted, dashed }

enum TypeList { solid, none }

enum IconPosition { left, right, both, none }
