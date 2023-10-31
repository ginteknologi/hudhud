// import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mesjid_app/routes/sedekah/index.dart';
import 'package:mesjid_app/theme.dart';

class ListItemSedekahWidget extends StatelessWidget {
  ListItemSedekahWidget(
      {required this.id,
      this.kategori,
      this.title,
      this.dueDay = 0,
      this.targetPrice = 0,
      this.totalPrice = 0,
      this.percentage = 0.3,
      this.image});

  int id;
  String? kategori;
  String? title;
  int? targetPrice;
  int? totalPrice;
  int? dueDay;
  String? image;
  double? percentage;

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        child: InkWell(
          highlightColor: Colors.transparent,
          onTap: () {
            Get.toNamed('${RoutesSedekah.root}/$id');
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 0, top: 10, right: 0),
                child: Container(
                  width: Get.width,
                  margin: const EdgeInsets.only(right: 2, bottom: 11),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      // BoxShadow(
                      //   color: Colors.grey.shade300,
                      //   spreadRadius: 0,
                      //   blurRadius: 15,
                      //   offset: Offset(0, 4),
                      // ),
                      // BoxShadow(
                      //   color: Colors.white,
                      //   spreadRadius: 0,
                      //   blurRadius: 0,
                      //   offset: Offset(0, 4),
                      // ),
                    ],
                  ),
                  child: IntrinsicHeight(
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                image!,
                                height: 120,
                                width: 110,
                                fit: BoxFit.cover,
                              )),
                        ),
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    margin: const EdgeInsets.only(bottom: 4),
                                    child: Text('$title',
                                        maxLines: 2,
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: true,
                                        style: TextStyle(
                                            fontSize: Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.fontSize,
                                            height: 1,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black)),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.account_balance_outlined,
                                            size: Theme.of(context)
                                                .textTheme
                                                .labelMedium
                                                ?.fontSize,
                                          ),
                                          const SizedBox(width: 5),
                                          Text(priceFormat.format(targetPrice),
                                              style: TextStyle(
                                                  fontSize: Theme.of(context)
                                                      .textTheme
                                                      .labelMedium
                                                      ?.fontSize,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black))
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.timer_outlined,
                                            size: Theme.of(context)
                                                .textTheme
                                                .labelMedium
                                                ?.fontSize,
                                          ),
                                          const SizedBox(width: 5),
                                          Text("$dueDay Hari",
                                              style: TextStyle(
                                                  fontSize: Theme.of(context)
                                                      .textTheme
                                                      .labelMedium
                                                      ?.fontSize,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black))
                                        ],
                                      ),
                                    ],
                                  ),
                                  const Divider(
                                    color: Colors.black38,
                                    // thickness: 2,
                                  ),
                                  Text('Dana Terkumpul',
                                      maxLines: 1,
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                      style: TextStyle(
                                          fontSize: Theme.of(context)
                                              .textTheme
                                              .labelSmall
                                              ?.fontSize,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black54)),
                                  Text(priceFormat.format(totalPrice),
                                      maxLines: 1,
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                      style: TextStyle(
                                          fontSize: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.fontSize,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black)),
                                  Row(
                                    children: [
                                      Flexible(
                                        flex: 1,
                                        child: LinearProgressIndicator(
                                          value: percentage,
                                          minHeight: 10,
                                          backgroundColor:
                                              const Color(0xFF92E3A9),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          valueColor:
                                              const AlwaysStoppedAnimation<
                                                  Color>(Color(0xFF048C7C)),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "50%",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontSize: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.fontSize,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.black87),
                                      )
                                    ],
                                  )
                                ],
                              )),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const Divider(color: Colors.black38),
              // Row(
              //   children: List.generate(
              //       150 ~/ 2,
              //       (index) => Expanded(
              //             child: Container(
              //               color: index % 2 == 0
              //                   ? Colors.transparent
              //                   : Colors.grey,
              //               height: 2,
              //             ),
              //           )),
              // ),
            ],
          ),
        ));
  }
}
