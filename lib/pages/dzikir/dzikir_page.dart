import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:masjid_app/components/layout/app_bar_ws.dart';
import 'package:masjid_app/components/partial/list_card_ui.dart';
import 'package:masjid_app/pages/dzikir/dzikir_controller.dart';

class DzikirPage extends StatelessWidget implements PreferredSizeWidget {
  const DzikirPage({super.key});

  layout(DzikirController ctrl, BuildContext context) {
    return SafeArea(
        child: Obx(() => Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.center,
                    end: Alignment.bottomCenter,
                    colors: ctrl.flagDzikir.value
                        ? [Color(0xFF49132A), Color(0xFF892E33)]
                        : [Color(0xFF050301), Color(0xFF303D58)])),
            child: ctrl.flagDzikir.value
                ? screenPetang(ctrl, context)
                : screenPagi(ctrl, context))));
  }

  screenPetang(DzikirController ctrl, BuildContext context) {
    return Stack(children: [
      Container(
        height: 240,
        width: Get.width,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/img/banner_dzikir_petang.png"),
                fit: BoxFit.cover)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 60,
            ),
            AutoSizeText(
              "Dzikir Petang",
              textAlign: TextAlign.center,
              style: context.textTheme.bodyLarge
                  ?.copyWith(fontWeight: FontWeight.bold, color: Colors.black),
              maxLines: 1,
            ),
            AutoSizeText(
              "Kumpulan dzikir di waktu sore",
              textAlign: TextAlign.center,
              style: context.textTheme.bodyLarge
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
                        width: Get.width,
                        height: 150,
                      ) //SizedBox
                      ),
                ),
              ])),
            ),
          ),
          SliverToBoxAdapter(
              child: Container(
            width: Get.width,
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
                          itemCount: ctrl.petang.length,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            // Datum model = filteredEvents[index];
                            return FadeInUp(
                              child: ListCardUiWidget(
                                type: 'wp',
                                id: index,
                                title: ctrl.petang[index]['judul'],
                                titleStyle: context.textTheme.titleSmall
                                    ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).primaryColor),
                                subtitleStyle: context.textTheme.labelMedium
                                    ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black45),
                                onTap: () {},
                                subtitle: ctrl.petang[index]['arabic'],
                                hasFooter: true,
                                usingDivider: false,
                                footerContent: [
                                  Container(
                                    width: Get.width - 62,
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          AutoSizeText(
                                              ctrl.petang[index]
                                                  ['transliteration'],
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  fontSize: Theme.of(context)
                                                      .textTheme
                                                      .labelLarge
                                                      ?.fontSize,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold)),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          AutoSizeText(
                                              ctrl.petang[index]
                                                  ['translations'],
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  fontSize: Theme.of(context)
                                                      .textTheme
                                                      .labelMedium
                                                      ?.fontSize,
                                                  fontStyle: FontStyle.italic,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w300)),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          AutoSizeText(
                                              ctrl.petang[index]['isi'],
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  fontSize: Theme.of(context)
                                                      .textTheme
                                                      .labelMedium
                                                      ?.fontSize,
                                                  fontStyle: FontStyle.italic,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w300)),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          AutoSizeText(
                                              ctrl.petang[index]['opening'],
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
                    SizedBox(
                      height: 100,
                    )
                  ],
                )),
          )),
        ],
      ),
    ]);
  }

  screenPagi(DzikirController ctrl, BuildContext context) {
    return Stack(children: [
      Container(
        height: 240,
        width: Get.width,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/img/banner_dzikir_pagi.png"),
                fit: BoxFit.cover)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 60,
            ),
            AutoSizeText(
              "Dzikir Pagi",
              textAlign: TextAlign.center,
              style: context.textTheme.bodyLarge
                  ?.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
              maxLines: 1,
            ),
            AutoSizeText(
              "Kumpulan dzikir di waktu pagi",
              textAlign: TextAlign.center,
              style: context.textTheme.bodyLarge
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
                        width: Get.width,
                        height: 150,
                      ) //SizedBox
                      ),
                ),
              ])),
            ),
          ),
          SliverToBoxAdapter(
              child: Container(
            width: Get.width,
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
                          itemCount: ctrl.pagi.length,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            // Datum model = filteredEvents[index];
                            return FadeInUp(
                              child: ListCardUiWidget(
                                type: 'wp',
                                id: index,
                                title: ctrl.pagi[index]['judul'],
                                titleStyle: context.textTheme.titleSmall
                                    ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).primaryColor),
                                subtitleStyle: context.textTheme.labelMedium
                                    ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black45),
                                onTap: () {},
                                subtitle: ctrl.pagi[index]['arabic'],
                                hasFooter: true,
                                usingDivider: false,
                                footerContent: [
                                  Container(
                                    width: Get.width - 62,
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          AutoSizeText(
                                              ctrl.pagi[index]
                                                  ['transliteration'],
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  fontSize: Theme.of(context)
                                                      .textTheme
                                                      .labelLarge
                                                      ?.fontSize,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold)),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          AutoSizeText(
                                              ctrl.pagi[index]
                                                  ['translations'],
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  fontSize: Theme.of(context)
                                                      .textTheme
                                                      .labelMedium
                                                      ?.fontSize,
                                                  fontStyle: FontStyle.italic,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w300)),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          AutoSizeText(
                                              ctrl.pagi[index]['isi'],
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  fontSize: Theme.of(context)
                                                      .textTheme
                                                      .labelMedium
                                                      ?.fontSize,
                                                  fontStyle: FontStyle.italic,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w300)),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          AutoSizeText(
                                              ctrl.pagi[index]['opening'],
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
                    SizedBox(
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
    final ctrl = Get.put(DzikirController());

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(55.0), // here the desired height
          child: Obx(() => AppBarWSWidget.getAppbarWidget(
              title: "",
              context: context,
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.white),
              iconRight: Material(
                  color: Colors.transparent,
                  child: Obx(() => InkWell(
                      splashColor: Colors.white30,
                      onTap: () => {},
                      child: Padding(
                        padding: EdgeInsets.only(right: 21),
                        child: ActionChip(
                          backgroundColor: ctrl.flagDzikir.value
                              ? Color(0xFF236480)
                              : Color(0xFFFF981D),
                          labelStyle: TextStyle(color: Colors.white),
                          label: Row(children: [
                            SvgPicture.asset(
                              ctrl.flagDzikir.value
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
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              ctrl.flagDzikir.value
                                  ? "Dzikir Pagi"
                                  : "Dzikir Petang",
                              style: TextStyle(
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .labelMedium
                                      ?.fontSize,
                                  fontWeight: FontWeight.bold),
                            )
                          ]),
                          onPressed: () {
                            ctrl.flagDzikir.value = !ctrl.flagDzikir.value;
                          },
                        ),
                      )))),
              backgroundColor: ctrl.flagDzikir.value
                  ? Color(0xFFFFD3A2)
                  : Color(0xFF1F2838)))),
      body: Obx(() => ctrl.isLoadingList.value
          ? Center(child: CircularProgressIndicator())
          : layout(ctrl, context)),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(55.0);
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
