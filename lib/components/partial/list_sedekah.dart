import 'package:flutter/material.dart';
import 'package:masjid_app/theme.dart';

class ListItemSedekahWidget extends StatelessWidget {
  const ListItemSedekahWidget(
      {super.key,
      required this.id,
      this.kategori,
      this.title,
      this.dueDay = 0,
      this.targetPrice = 0,
      this.totalPrice = 0,
      this.lineProgress = 0,
      this.persentase = 0,
      this.image});

  final int id;
  final String? kategori;
  final String? title;
  final int? targetPrice;
  final int? totalPrice;
  final int? dueDay;
  final String? image;
  final double? lineProgress;
  final int? persentase;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Material(
        color: Colors.transparent,
        child: InkWell(
          highlightColor: Colors.transparent,
          onTap: () {
            // Can be opened or tapped
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 0, top: 10, right: 0),
                child: Container(
                  width: screenWidth,
                  margin: const EdgeInsets.only(right: 2, bottom: 11),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
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
                              child: Image.network(
                                image!,
                                height: 130,
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
                                          Text(
                                              dueDay != null
                                                  ? "$dueDay Hari"
                                                  : '∞',
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
                                  // SizedBox(
                                  //   height: 10,
                                  // ),
                                  Row(
                                    children: [
                                      Flexible(
                                        flex: 1,
                                        child: LinearProgressIndicator(
                                          value: lineProgress,
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
                                        '$persentase%',
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
