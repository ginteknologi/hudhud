import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:masjid_app/components/layout/app_bar_ws.dart';
import 'package:masjid_app/components/partial/list_card_ui.dart';
import 'package:masjid_app/providers/doa_providers.dart';

class DzikirPage extends ConsumerStatefulWidget implements PreferredSizeWidget {
  const DzikirPage({super.key});

  @override
  ConsumerState<DzikirPage> createState() => _DzikirPageState();

  @override
  Size get preferredSize => const Size.fromHeight(55.0);
}

class _DzikirPageState extends ConsumerState<DzikirPage> {
  // false = dzikir pagi, true = dzikir petang
  bool _flagDzikir = false;

  SafeArea layout(List<Map<String, dynamic>> pagi,
      List<Map<String, dynamic>> petang, BuildContext context) {
    return SafeArea(
        child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.center,
                    end: Alignment.bottomCenter,
                    colors: _flagDzikir
                        ? const [Color(0xFF49132A), Color(0xFF892E33)]
                        : const [Color(0xFF050301), Color(0xFF303D58)])),
            child: _flagDzikir
                ? screenPetang(petang, context)
                : screenPagi(pagi, context)));
  }

  Stack screenPetang(List<Map<String, dynamic>> petang, BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Stack(children: [
      Container(
        height: 240,
        width: width,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/img/banner_dzikir_petang.png"),
                fit: BoxFit.cover)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 60,
            ),
            AutoSizeText(
              "Dzikir Petang",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge
                  ?.copyWith(fontWeight: FontWeight.bold, color: Colors.black),
              maxLines: 1,
            ),
            AutoSizeText(
              "Kumpulan dzikir di waktu sore",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge
                  ?.copyWith(fontWeight: FontWeight.w300, color: Colors.black),
              maxLines: 1,
            )
          ],
        ),
      ),
      CustomScrollView(
        // physics: FixedExtentScrollPhysics(),
        anchor: 0,
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.only(
              top: 20,
            ),
            sliver: SliverPersistentHeader(
              pinned: false,
              floating: false,
              delegate: _SliverPersistentHeaderDelegate(
                  Stack(clipBehavior: Clip.none, children: [
                Positioned(
                  top: 10,
                  child: Card(
                      elevation: 0,
                      color: Colors.transparent,
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
                        width: width,
                        height: 150,
                      ) //SizedBox
                      ),
                ),
              ])),
            ),
          ),
          SliverToBoxAdapter(
              child: Container(
            width: width,
            constraints: BoxConstraints.loose(Size.infinite),
            child: Padding(
                padding: const EdgeInsets.only(
                    top: 20, left: 21, right: 21, bottom: 21),
                child: Column(
                  children: [
                    SizedBox(
                        height: MediaQuery.of(context).size.height -
                            kBottomNavigationBarHeight -
                            kToolbarHeight -
                            100,
                        child: ListView.builder(
                          itemCount: petang.length,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            // Datum model = filteredEvents[index];
                            return FadeInUp(
                              child: ListCardUiWidget(
                                type: 'wp',
                                id: index,
                                title: petang[index]['judul'],
                                titleStyle: Theme.of(context).textTheme.titleSmall
                                    ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).primaryColor),
                                subtitleStyle: Theme.of(context).textTheme.labelMedium
                                    ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black45),
                                onTap: () {},
                                subtitle: petang[index]['arabic'],
                                hasFooter: true,
                                usingDivider: false,
                                footerContent: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width -
                                        62,
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          AutoSizeText(
                                              petang[index]
                                                  ['transliteration'],
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  fontSize: Theme.of(context)
                                                      .textTheme
                                                      .labelLarge
                                                      ?.fontSize,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold)),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          AutoSizeText(
                                              petang[index]['translations'],
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  fontSize: Theme.of(context)
                                                      .textTheme
                                                      .labelMedium
                                                      ?.fontSize,
                                                  fontStyle: FontStyle.italic,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w300)),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          AutoSizeText(
                                              petang[index]['isi'],
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  fontSize: Theme.of(context)
                                                      .textTheme
                                                      .labelMedium
                                                      ?.fontSize,
                                                  fontStyle: FontStyle.italic,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w300)),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          AutoSizeText(
                                              petang[index]['opening'],
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  fontSize: Theme.of(context)
                                                      .textTheme
                                                      .labelMedium
                                                      ?.fontSize,
                                                  fontStyle: FontStyle.italic,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold))
                                        ]),
                                  ),
                                ],
                              ),
                            );
                          },
                        )),
                    const SizedBox(
                      height: 100,
                    )
                  ],
                )),
          )),
        ],
      ),
    ]);
  }

  Stack screenPagi(List<Map<String, dynamic>> pagi, BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Stack(children: [
      Container(
        height: 240,
        width: width,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/img/banner_dzikir_pagi.png"),
                fit: BoxFit.cover)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 60,
            ),
            AutoSizeText(
              "Dzikir Pagi",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge
                  ?.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
              maxLines: 1,
            ),
            AutoSizeText(
              "Kumpulan dzikir di waktu pagi",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge
                  ?.copyWith(fontWeight: FontWeight.w300, color: Colors.white),
              maxLines: 1,
            )
          ],
        ),
      ),
      CustomScrollView(
        // physics: FixedExtentScrollPhysics(),
        anchor: 0,
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.only(
              top: 20,
            ),
            sliver: SliverPersistentHeader(
              pinned: false,
              floating: false,
              delegate: _SliverPersistentHeaderDelegate(
                  Stack(clipBehavior: Clip.none, children: [
                Positioned(
                  top: 10,
                  child: Card(
                      elevation: 0,
                      color: Colors.transparent,
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
                        width: width,
                        height: 150,
                      ) //SizedBox
                      ),
                ),
              ])),
            ),
          ),
          SliverToBoxAdapter(
              child: Container(
            width: width,
            constraints: BoxConstraints.loose(Size.infinite),
            child: Padding(
                padding: const EdgeInsets.only(
                    top: 20, left: 21, right: 21, bottom: 21),
                child: Column(
                  children: [
                    SizedBox(
                        height: MediaQuery.of(context).size.height -
                            kBottomNavigationBarHeight -
                            kToolbarHeight -
                            100,
                        child: ListView.builder(
                          itemCount: pagi.length,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            // Datum model = filteredEvents[index];
                            return FadeInUp(
                              child: ListCardUiWidget(
                                type: 'wp',
                                id: index,
                                title: pagi[index]['judul'],
                                titleStyle: Theme.of(context).textTheme.titleSmall
                                    ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).primaryColor),
                                subtitleStyle: Theme.of(context).textTheme.labelMedium
                                    ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black45),
                                onTap: () {},
                                subtitle: pagi[index]['arabic'],
                                hasFooter: true,
                                usingDivider: false,
                                footerContent: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width -
                                        62,
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          AutoSizeText(
                                              pagi[index]['transliteration'],
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  fontSize: Theme.of(context)
                                                      .textTheme
                                                      .labelLarge
                                                      ?.fontSize,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold)),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          AutoSizeText(
                                              pagi[index]['translations'],
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  fontSize: Theme.of(context)
                                                      .textTheme
                                                      .labelMedium
                                                      ?.fontSize,
                                                  fontStyle: FontStyle.italic,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w300)),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          AutoSizeText(
                                              pagi[index]['isi'],
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  fontSize: Theme.of(context)
                                                      .textTheme
                                                      .labelMedium
                                                      ?.fontSize,
                                                  fontStyle: FontStyle.italic,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w300)),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          AutoSizeText(
                                              pagi[index]['opening'],
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  fontSize: Theme.of(context)
                                                      .textTheme
                                                      .labelMedium
                                                      ?.fontSize,
                                                  fontStyle: FontStyle.italic,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold))
                                        ]),
                                  ),
                                ],
                              ),
                            );
                          },
                        )),
                    const SizedBox(
                      height: 100,
                    )
                  ],
                )),
          )),
        ],
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final dzikirAsync = ref.watch(dzikirRawProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(55.0), // here the desired height
          child: AppBarWSWidget.getAppbarWidget(
              title: "",
              context: context,
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.white),
              iconRight: Material(
                  color: Colors.transparent,
                  child: InkWell(
                      splashColor: Colors.white30,
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.only(right: 21),
                        child: ActionChip(
                          backgroundColor: _flagDzikir
                              ? const Color(0xFF236480)
                              : const Color(0xFFFF981D),
                          labelStyle: const TextStyle(color: Colors.white),
                          label: Row(children: [
                            SvgPicture.asset(
                              _flagDzikir
                                  ? 'assets/icons/moon.svg'
                                  : 'assets/icons/sun.svg',
                              alignment: Alignment.center,
                              width: Theme.of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.fontSize,
                              height: Theme.of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.fontSize,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              _flagDzikir ? "Dzikir Pagi" : "Dzikir Petang",
                              style: TextStyle(
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .labelMedium
                                      ?.fontSize,
                                  fontWeight: FontWeight.bold),
                            )
                          ]),
                          onPressed: () {
                            setState(() {
                              _flagDzikir = !_flagDzikir;
                            });
                          },
                        ),
                      ))),
              backgroundColor: _flagDzikir
                  ? const Color(0xFFFFD3A2)
                  : const Color(0xFF1F2838))),
      body: dzikirAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => const SizedBox.shrink(),
          data: (items) => layout(
              items.where((item) => item['idCategoryDoa'] == 60).toList(),
              items.where((item) => item['idCategoryDoa'] == 61).toList(),
              context)),
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
