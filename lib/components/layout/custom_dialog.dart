import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog(
      {super.key,
      this.imgPath,
      this.chipText,
      this.title,
      this.kategori,
      this.width = 151,
      this.height = 112,
      this.chipColor = Colors.red,
      this.subtitle,
      this.size = "small",
      this.positionChip = CrossAxisAlignment.end,
      this.chipTextStyle = const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
          fontSize: 9),
      this.isFullWidth = false});

  final String? imgPath;
  final CrossAxisAlignment positionChip;
  final String? chipText;
  final TextStyle? chipTextStyle;
  final Color chipColor;
  final String? title;
  final String? subtitle;
  final String? size;
  final String? kategori;
  final double? width;
  final double? height;
  final bool isFullWidth;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = isFullWidth ? screenWidth : (width ?? 151.0);

    return IntrinsicWidth(
      child: Align(
          alignment: Alignment.centerRight,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              highlightColor: Colors.transparent,
              onTap: () {},
              child: SizedBox(
                height: height,
                width: cardWidth,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        clipBehavior: Clip.antiAlias,
                        child: Image.asset(
                          imgPath ?? 'assets/icons/image-item1.png',
                          height: height,
                          width: cardWidth,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: positionChip,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                margin: positionChip == CrossAxisAlignment.end
                                    ? const EdgeInsets.only(right: 5, top: 10)
                                    : const EdgeInsets.only(left: 5, top: 10),
                                decoration: BoxDecoration(
                                  color: chipColor,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(7),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 3),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Visibility(
                                          visible: size == 'small',
                                          child: Container(
                                              margin: const EdgeInsets.only(
                                                  right: 5),
                                              child: SvgPicture.asset(
                                                  'assets/icons/live.svg',
                                                  height: 10,
                                                  width: 10))),
                                      Text('$chipText',
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.start,
                                          style: chipTextStyle),
                                    ],
                                  ),
                                )),
                            Container(
                              width: cardWidth,
                              clipBehavior: Clip.antiAlias,
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Color(0x80000000),
                                    ]),
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(7),
                                    bottomRight: Radius.circular(7)),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                      width: cardWidth,
                                      margin: const EdgeInsets.only(
                                          left: 6, top: 5, right: 12),
                                      child: Row(
                                        children: [
                                          Flexible(
                                            child: Text(
                                              '$title',
                                              maxLines: size == 'small' ? 1 : 2,
                                              softWrap: true,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w900,
                                                  height: 1.2,
                                                  fontSize: size == 'small'
                                                      ? Theme.of(context)
                                                          .textTheme
                                                          .bodySmall
                                                          ?.fontSize
                                                      : Theme.of(context)
                                                          .textTheme
                                                          .titleMedium
                                                          ?.fontSize),
                                            ),
                                          )
                                        ],
                                      )),
                                  Container(
                                    width: cardWidth,
                                    margin: const EdgeInsets.only(
                                        left: 6, right: 12, top: 2),
                                    child: Text(
                                      '$subtitle',
                                      maxLines: 1,
                                      softWrap: false,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.normal,
                                          fontSize: size == 'small'
                                              ? Theme.of(context)
                                                  .textTheme
                                                  .labelSmall
                                                  ?.fontSize
                                              : Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.fontSize),
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
