import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:masjid_app/core/router/app_router.dart';
import 'package:masjid_app/providers/ruangan_provider.dart';
import 'package:table_calendar/table_calendar.dart';

class RuanganPage extends ConsumerStatefulWidget {
  const RuanganPage({super.key});

  @override
  ConsumerState<RuanganPage> createState() => _RuanganPageState();
}

class _RuanganPageState extends ConsumerState<RuanganPage> {
  final DateTime selectedDay = DateTime.now();

  Stack layout(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        SizedBox(
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
            decoration: const BoxDecoration(
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
                    padding: const EdgeInsets.only(
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
                                color: const Color(0xFFF5F5F5),
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
                                  width: screenWidth,
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
                                  SizedBox(
                                      width: screenWidth,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
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
                                                  decoration: const BoxDecoration(
                                                      image: DecorationImage(
                                                          image: AssetImage(
                                                              "assets/img/logo-splash.png"),
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
                                                          style: Theme.of(context).textTheme
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
                                                      const Align(
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
                                            const SizedBox(
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
                                                  const SizedBox(
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
                                                  const SizedBox(
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
                    decoration: const BoxDecoration(color: Color(0xFFF5F5F5)),
                    width: screenWidth,
                    constraints: BoxConstraints.loose(Size.infinite),
                    child: Padding(
                        padding: const EdgeInsets.only(top: 70),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 21),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text("Jenis Kegiatan",
                                    style: Theme.of(context).textTheme.titleMedium
                                        ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black)),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              height: 180,
                              width: screenWidth,
                              // constraints:
                              //     BoxConstraints.loose(Size.infinite),
                              child: ListView.separated(
                                // padding: EdgeInsets.only(left: 24, right: 24),
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                itemCount: ruanganKegiatanList.length,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(width: 10),
                                itemBuilder: (context, index) {
                                  return Container(
                                    width: 140,
                                    constraints:
                                        BoxConstraints.loose(Size.infinite),
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.only(left: 10),
                                    clipBehavior: Clip.antiAlias,
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12))),
                                    child: Column(
                                      children: [
                                        ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(12)),
                                          child: Image.asset(
                                            'assets/img/masjidRuangan.png',
                                            height: 90,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              ruanganKegiatanList[index]['label'],
                                              textAlign: TextAlign.left,
                                              maxLines: 2,
                                              style: Theme.of(context).textTheme.bodySmall
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Theme.of(context)
                                                          .primaryColor),
                                              softWrap: true,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: AutoSizeText(
                                            ruanganKegiatanList[index]
                                                ['subtitle'],
                                            textAlign: TextAlign.left,
                                            maxLines: 3,
                                            style: const TextStyle(
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
                            const SizedBox(
                              height: 20,
                            ),
                            const AutoSizeText("Cek tanggal",
                            style: TextStyle(
                                fontWeight: FontWeight.bold
                            ),),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 21),
                              decoration: const BoxDecoration(color: Colors.white),
                              child: TableCalendar(
                                headerStyle: const HeaderStyle(
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
                                  return isSameDay(selectedDay, day);
                                },
                                onDaySelected: (daySelected, focusedDay) {
                                      context.push(
                                          '${AppRoutes.ruanganJadwal}?tanggal=$daySelected');
                                },
                                onFormatChanged: (format) {},
                                onPageChanged: (focusedDay) {},
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.symmetric(horizontal: 21),
                            //   child: Align(
                            //     alignment: Alignment.bottomRight,
                            //     child: Material(
                            //       color: Colors.transparent,
                            //       child: InkWell(
                            //         onTap: () {
                            //           Get.toNamed(RoutesRuangan.jadwal);
                            //         },
                            //         borderRadius: BorderRadius.circular(20),
                            //         splashColor: Colors.green.withValues(alpha: 0.5),
                            //         child: Text(
                            //           "Lihat Detail",
                            //           style: TextStyle(
                            //               color: Colors.blue[700],
                            //               decoration: TextDecoration.underline),
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            const SizedBox(
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
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: layout(context),
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
