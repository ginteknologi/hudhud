import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomCardItem extends StatelessWidget {
  CustomCardItem(
      {super.key,
      this.imgPath,
      this.chipText,
      this.title,
      this.kategori,
      this.width = 151,
      this.height = 112,
      this.chipColor = Colors.red,
      this.subtitle,
      this.network = false,
      this.islink = false,
      this.link,
      this.linkRoute,
      this.size = "small",
      this.positionChip = CrossAxisAlignment.end,
      this.chipTextStyle = const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
          fontSize: 9),
      this.isFullWidth = false});

  String? imgPath;
  CrossAxisAlignment positionChip;
  String? chipText;
  TextStyle? chipTextStyle;
  Color chipColor;
  String? title;
  String? subtitle;
  String? size;
  String? link;
  String? linkRoute;
  final String? kategori;
  double? width;
  double? height;
  bool isFullWidth;
  bool network;
  bool islink;

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Align(
          alignment: Alignment.centerRight,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              highlightColor: Colors.transparent,
              onTap: () async {
                if (islink) {
                  final Uri url = Uri.parse(link!);
                  if (!await launchUrl(url)) {
                    print('Tidak dapat membuka link YouTube.');
                  }
                }
                if (linkRoute != null) {
                  print(linkRoute);
                  Get.toNamed(linkRoute!);
                }
                //Get.toNamed(AppRoutes.detailEventScreen);
              },
              child: SizedBox(
                height: height,
                width: isFullWidth == true ? Get.width : 151,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        clipBehavior: Clip.antiAlias,
                        child: network
                            ? Image.network(
                                imgPath ??
                                    'https://masjidannimah.id/wp-admin/admin-ajax.php?action=imgedit-preview&_ajax_nonce=682b18d276&postid=2013&rand=30724',
                                height: height,
                                width: isFullWidth == true ? Get.width : 151,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                imgPath ?? 'assets/icons/doa.jpg',
                                height: height,
                                width: isFullWidth == true ? Get.width : 151,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: positionChip,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          chipText != null ? 
                          Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Visibility(
                                    //     visible: size == 'small',
                                    //     child: Container(
                                    //         margin:
                                    //             const EdgeInsets.only(right: 5),
                                    //         child: SvgPicture.asset(
                                    //             'assets/icons/live.svg',
                                    //             height: 10,
                                    //             width: 10))),
                                    Text('$chipText',
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.start,
                                        style: chipTextStyle
                                        // TextStyle(
                                        //     color: Colors.white,
                                        //     fontWeight: FontWeight.bold,
                                        //     fontStyle: size == 'small'
                                        //         ? FontStyle.italic
                                        //         : FontStyle.normal,
                                        //     fontSize: chipSize
                                        // ),
                                        )
                                    
                                  ],
                                ),
                              )) : Container(),
                          Container(
                            width: isFullWidth == true ? Get.width : 151,
                            clipBehavior: Clip.antiAlias,
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 15),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    // Colors.transparent,
                                    Colors.black.withOpacity(0.0),
                                    Colors.black.withOpacity(0.3),
                                    Colors.black.withOpacity(0.5),
                                    Colors.black.withOpacity(0.7)
                                  ]),
                              // color: Colors.black.withOpacity(0.5),
                              borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(7),
                                  bottomRight: Radius.circular(7)),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    width:
                                        isFullWidth == true ? Get.width : 151,
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
                                  width: isFullWidth == true ? Get.width : 151,
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
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
