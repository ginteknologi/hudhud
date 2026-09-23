import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class ListItemUiWidget extends StatelessWidget {
  const ListItemUiWidget(
      {super.key,
      required this.id,
      this.category,
      this.title = "title",
      this.titleStyle,
      this.subTitle,
      this.subtitleStyle,
      this.rightContent = const [],
      this.hasRightContent = false,
      this.justify = false,
      this.vjustify = false,
      this.start = false,
      this.iconLeft,
      this.iconRight,
      this.typeDivider = TypeDivider.line,
      this.listInset = false,
      this.typeList = TypeList.none,
      this.showIcon = IconPosition.none,
      this.onTap,
      this.minHeight,
      this.widthContent,
      this.activeColor,
      this.footerText,
      this.footerTextStyle,
      this.image});

  final int id;
  final String? category;
  final String? title;
  final TextStyle? titleStyle;
  final String? subTitle;
  final TextStyle? subtitleStyle;
  final String? footerText;
  final TextStyle? footerTextStyle;
  final List<Widget> rightContent;
  final Widget? iconLeft;
  final bool justify;
  final bool vjustify;
  final bool start;
  final IconPosition showIcon;
  final bool hasRightContent;
  final Widget? iconRight;
  final String? image;
  final TypeDivider typeDivider;
  final TypeList typeList;
  final bool listInset;
  final double? widthContent;
  final VoidCallback? onTap;
  final double? minHeight;
  final BoxDecoration? activeColor;

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        child: InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.green.withValues(alpha: 0.5),
          onTap: onTap,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                decoration: activeColor ?? BoxDecoration(),
                child: Padding(
                  padding: listInset
                      ? EdgeInsets.only(left: 0, top: 10, right: 0)
                      : EdgeInsets.only(left: 0, top: 10, right: 0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
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
                          : start
                              ? MainAxisAlignment.start
                              : MainAxisAlignment.center,
                      children: [
                        if (showIcon == IconPosition.left ||
                            showIcon == IconPosition.both)
                          Padding(
                            padding: const EdgeInsets.only(
                              right: 10,
                            ),
                            child: iconLeft,
                          ),
                        if (showIcon == IconPosition.leftFlex)
                          Expanded(
                            flex: 1,
                            child: iconLeft ?? Text(""),
                          ),
                        Expanded(
                            flex: 2,
                            child: Row(
                              mainAxisAlignment: hasRightContent
                                  ? MainAxisAlignment.spaceBetween
                                  : MainAxisAlignment.start,
                              children: [
                                Container(
                                  constraints:
                                      // BoxConstraints.loose(Size.infinite),
                                      BoxConstraints(
                                          minHeight: minHeight ?? 0,
                                          maxWidth: widthContent ??
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: vjustify
                                        ? MainAxisAlignment.spaceBetween
                                        : MainAxisAlignment.center,
                                    children: [
                                      if (category != null)
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
                                          minFontSize: 11,
                                          style: subtitleStyle ??
                                              TextStyle(
                                                  fontSize: Theme.of(context)
                                                      .textTheme
                                                      .titleSmall
                                                      ?.fontSize,
                                                  color: Colors.black87,
                                                  fontWeight: FontWeight.w500),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                      if (footerText != null)
                                        SizedBox(
                                          height: 10,
                                        ),
                                      if (footerText != null)
                                        AutoSizeText(
                                          '$footerText',
                                          textAlign: TextAlign.start,
                                          minFontSize: 14,
                                          style: footerTextStyle ??
                                              TextStyle(
                                                  fontSize: Theme.of(context)
                                                      .textTheme
                                                      .titleSmall
                                                      ?.fontSize,
                                                  color: Colors.black87,
                                                  fontWeight: FontWeight.w500),
                                          overflow: TextOverflow.ellipsis,
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

enum TypeDivider { line, dotted, dashed, none }

enum TypeList { solid, none }

enum IconPosition { left, right, both, none, leftFlex }
