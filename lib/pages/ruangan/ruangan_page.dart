import 'package:auto_size_text/auto_size_text.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mesjid_app/pages/ruangan/ruangan_controller.dart';
import 'package:mesjid_app/routes/ruangan/index.dart';
import 'package:table_calendar/table_calendar.dart';

class RuanganPage extends StatelessWidget {
  const RuanganPage({super.key});

  layout(RuanganController ctrl, BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          child: Image.asset(
            'assets/img/masjidRuangan.png',
            fit: BoxFit.cover,
            height: 200,
          ),
          //color: Colors.green,
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            //width: MediaQuery.of(context).size.width * 0.9,
            //margin: EdgeInsets.symmetric(horizontal: kBigBoxPadding),
            decoration: BoxDecoration(
                //color: Colors.pink,
                // borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
            child: ClipRRect(
              // borderRadius: BorderRadius.all(Radius.circular(30)),
              child: CustomScrollView(
                //physics: FixedExtentScrollPhysics(),
                anchor: 0,
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.only(
                      top: 160,
                    ),
                    sliver: SliverPersistentHeader(
                      pinned: false,
                      floating: false,
                      delegate: _SliverPersistentHeaderDelegate(Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            top: 10,
                            child: Card(
                                elevation: 0,
                                color: Color(0xFFF5F5F5),
                                margin: const EdgeInsets.only(
                                    top: 10, right: 0, bottom: 0, left: 0),
                                clipBehavior: Clip.antiAlias,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15)),
                                  //set border radius more than 50% of height and width to make circle
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(15),
                                  width: Get.width,
                                  height: 150,
                                ) //SizedBox
                                ),
                          ),
                          Positioned(
                              top: 0,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      width: Get.width,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 21),
                                        child: Row(
                                          children: [
                                            Card(
                                                elevation: 0,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                margin: const EdgeInsets.only(
                                                    right: 0,
                                                    bottom: 0,
                                                    left: 0),
                                                clipBehavior: Clip.antiAlias,
                                                shape:
                                                    const RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(15)),
                                                  //set border radius more than 50% of height and width to make circle
                                                ),
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 10),
                                                  width: 120,
                                                  height: 120,
                                                  decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                          image: AssetImage(
                                                              "assets/img/logo_only_white.png"),
                                                          fit: BoxFit.contain)),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          "Masjid An-Ni'mah",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: context
                                                              .textTheme
                                                              .labelSmall
                                                              ?.copyWith(
                                                                  fontFamily:
                                                                      "DMSerifDisplay",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  letterSpacing:
                                                                      0,
                                                                  color: Colors
                                                                      .white),
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          "CITRAGRAN-CIBUBUR",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontSize: 7,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                )),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                                child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                  SizedBox(
                                                    height: 30,
                                                  ),
                                                  AutoSizeText(
                                                    "Ruang Serbaguna",
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black,
                                                        fontSize:
                                                            Theme.of(context)
                                                                .textTheme
                                                                .titleMedium
                                                                ?.fontSize),
                                                    maxLines: 1,
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  AutoSizeText(
                                                    "Kami mendukung kegiatan komunitas Muslim dan pelayanan untuk masyarakat sekitar",
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color: Colors.black,
                                                        height: 1,
                                                        letterSpacing: 0,
                                                        fontSize:
                                                            Theme.of(context)
                                                                .textTheme
                                                                .labelSmall
                                                                ?.fontSize),
                                                    maxLines: 4,
                                                  )
                                                ])),
                                          ],
                                        ),
                                      )),
                                ],
                              )),
                        ],
                      )),
                    ),
                  ),
                  SliverToBoxAdapter(
                      child: Container(
                    decoration: BoxDecoration(color: Color(0xFFF5F5F5)),
                    width: Get.width,
                    constraints: BoxConstraints.loose(Size.infinite),
                    child: Padding(
                        padding: EdgeInsets.only(top: 70),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 21),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text("Jenis Kegiatan",
                                    style: context.textTheme.titleMedium
                                        ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black)),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              height: 180,
                              width: Get.width,
                              // constraints:
                              //     BoxConstraints.loose(Size.infinite),
                              child: ListView.separated(
                                // padding: EdgeInsets.only(left: 24, right: 24),
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                itemCount: ctrl.listKegiatan.length,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(width: 10),
                                itemBuilder: (context, index) {
                                  return Container(
                                    width: 140,
                                    constraints:
                                        BoxConstraints.loose(Size.infinite),
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(left: 10),
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12))),
                                    child: Column(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12)),
                                          child: Image.asset(
                                            'assets/img/masjidRuangan.png',
                                            height: 90,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              ctrl.listKegiatan[index]['label'],
                                              textAlign: TextAlign.left,
                                              maxLines: 2,
                                              style: context.textTheme.bodySmall
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Theme.of(context)
                                                          .primaryColor),
                                              softWrap: true,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: AutoSizeText(
                                            ctrl.listKegiatan[index]
                                                ['subtitle'],
                                            textAlign: TextAlign.left,
                                            maxLines: 3,
                                            style: TextStyle(
                                                height: 1,
                                                fontSize: 8,
                                                fontWeight: FontWeight.normal,
                                                letterSpacing: 0,
                                                color: Colors.black45),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 21),
                              decoration: BoxDecoration(color: Colors.white),
                              child: TableCalendar(
                                headerStyle: HeaderStyle(
                                    rightChevronMargin:
                                        EdgeInsets.only(right: 0),
                                    leftChevronMargin:
                                        EdgeInsets.only(left: 0)),
                                daysOfWeekHeight: 40,
                                firstDay: DateTime.utc(2010, 10, 16),
                                lastDay: DateTime.utc(2030, 3, 14),
                                focusedDay: DateTime.now(),
                                // calendarFormat: _calendarFormat,
                                selectedDayPredicate: (day) {
                                  // Use `selectedDayPredicate` to determine which day is currently selected.
                                  // If this returns true, then `day` will be marked as selected.

                                  // Using `isSameDay` is recommended to disregard
                                  // the time-part of compared DateTime objects.
                                  return isSameDay(ctrl.selectedDay.value, day);
                                },
                                onDaySelected: (selectedDay, focusedDay) {},
                                onFormatChanged: (format) {},
                                onPageChanged: (focusedDay) {},
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 21),
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      Get.toNamed(RoutesRuangan.jadwal);
                                    },
                                    borderRadius: BorderRadius.circular(20),
                                    splashColor: Colors.green.withOpacity(0.5),
                                    child: Text(
                                      "Lihat Detail",
                                      style: TextStyle(
                                          color: Colors.blue[700],
                                          decoration: TextDecoration.underline),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 100,
                            ),
                          ],
                        )),
                  )),
                  // SliverList(
                  //   delegate: SliverChildBuilderDelegate(
                  //     (_, int index) {
                  //       return ListTile(
                  //         leading: Container(
                  //             padding: EdgeInsets.all(8),
                  //             width: 100,
                  //             child: Placeholder()),
                  //         title: Text('Place ${index + 1}', textScaleFactor: 2),
                  //       );
                  //     },
                  //     childCount: 20,
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(RuanganController());

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: layout(ctrl, context),
    );
  }
}

class _SliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  _SliverPersistentHeaderDelegate(this.child);

  final Widget child;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 100;

  @override
  double get minExtent => 100;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
}
