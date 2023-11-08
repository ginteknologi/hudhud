// import 'dart:async';
// import 'package:animate_do/animate_do.dart';
// import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mesjid_app/components/button/elevatedbutton.dart';
// import 'package:mesjid_app/components/input/InputText.dart';
import 'package:mesjid_app/components/layout/app_bar_ws.dart';
import 'package:mesjid_app/components/layout/sliding_app_bar.dart';
// import 'package:mesjid_app/components/partial/list_ui.dart';
import 'package:mesjid_app/pages/home/home_controller.dart';
import 'package:mesjid_app/pages/quran/halaman/component/image_viewer_widget.dart';
import 'package:mesjid_app/pages/quran/halaman/halaman_quran_controller.dart';
import 'package:mesjid_app/pages/quran/quran_controller.dart';
// import 'package:mesjid_app/theme.dart';

class HalamanQuranPage extends StatefulWidget {
  const HalamanQuranPage({super.key});

  @override
  State<HalamanQuranPage> createState() => _HalamanQuranPageState();
}

class _HalamanQuranPageState extends State<HalamanQuranPage>
    with SingleTickerProviderStateMixin {
  layout(HalamanQuranController ctrl, BuildContext context,
      HomeController ctrlHome) {
    return SafeArea(
        child: Container(
            constraints: BoxConstraints.loose(Size.infinite),
            child: Stack(
              children: [
                Padding(
                    padding: const EdgeInsets.only(left: 21, right: 21),
                    child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _visible = !_visible;
                            _show = !_show;
                            // Timer(Duration(milliseconds: 10), () {
                            //   _show = !_show;
                            // });
                          });
                          ctrlHome.visible.value = !ctrlHome.visible.value;
                          ctrlHome.selectedIdx.value = 1;
                        },
                        child: EasyImageViewPager(
                            onTap: (int index) {
                              showPopup(ctrl, context, ctrlHome);
                            },
                            idxInitial: ctrlHome.idxLastReadHalaman.value,
                            imageProviders: ctrl.listSurah)))
                // Column(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Expanded(
                //         flex: 1,
                //         child: Padding(
                //             padding: const EdgeInsets.only(left: 21, right: 21),
                //             child: GestureDetector(
                //                 onTap: () {
                //                   setState(() {
                //                     _visible = !_visible;
                //                     _show = !_show;
                //                     // Timer(Duration(milliseconds: 10), () {
                //                     //   _show = !_show;
                //                     // });
                //                   });
                //                   ctrlHome.visible.value =
                //                       !ctrlHome.visible.value;
                //                   ctrlHome.selectedIdx.value = 1;
                //                 },
                //                 child: EasyImageViewPager(
                //                     onTap: (int index) {
                //                       showPopup(ctrl, context, ctrlHome);
                //                     },
                //                     idxInitial:
                //                         ctrlHome.idxLastReadHalaman.value,
                //                     imageProviders: ctrl.listSurah)

                //                 // PageView.builder(
                //                 //     itemCount: ctrl.listSurah.length,
                //                 //     pageSnapping: true,
                //                 //     reverse: true,
                //                 //     itemBuilder: (context, pagePosition) {
                //                 //       return Container(
                //                 //           margin: EdgeInsets.all(10),
                //                 //           child: Image.asset(
                //                 //               ctrl.listSurah[pagePosition]));
                //                 //     })

                //                 // Container(
                //                 //   decoration: const BoxDecoration(
                //                 //       image: DecorationImage(
                //                 //     image: AssetImage(
                //                 //         "assets/img/quran/quran_page_1.png"),
                //                 //     fit: BoxFit.contain,
                //                 //     alignment: Alignment.center,
                //                 //   )),
                //                 //   width: Get.width,
                //                 // ),
                //                 )))
                //   ],
                // ),
                // Obx(() => Positioned(
                //       top: ctrl.bookmarked.value ? 0 : -20,
                //       right: 10,
                //       child: GestureDetector(
                //         child: SvgPicture.asset(
                //           'assets/icons/bookmark-page.svg',
                //           height: 60,
                //         ),
                //         onTap: () {
                //           showPopup(ctrl, context, ctrlHome);
                //         },
                //       ),
                //     )),
              ],
            )

            // SingleChildScrollView(
            //     physics: const ClampingScrollPhysics(),
            //     child: Padding(
            //         padding: const EdgeInsets.only(left: 21, right: 21),
            //         child: GestureDetector(
            //           onTap: () {
            //             setState(() {
            //               _visible = !_visible;
            //               _show = !_show;
            //               // Timer(Duration(milliseconds: 10), () {
            //               //   _show = !_show;
            //               // });
            //             });

            //             ctrlHome.visible.value = !ctrlHome.visible.value;
            //           },
            //           child: Container(
            //             decoration: const BoxDecoration(
            //                 image: DecorationImage(
            //               image:
            //                   AssetImage("assets/img/quran/quran_page_1.png"),
            //               fit: BoxFit.contain,
            //               alignment: Alignment.topCenter,
            //             )),
            //             height: MediaQuery.of(context).size.height -
            //                 kBottomNavigationBarHeight -
            //                 MediaQuery.of(context).padding.top -
            //                 kToolbarHeight,
            //             width: Get.width,
            //           ),
            //         )))

            ));
  }

  bool _visible = true;
  bool _show = true;
  late final AnimationController _controller;

  void showPopup(
    HalamanQuranController ctrl,
    BuildContext context,
    HomeController ctrlHome,
  ) {
    showDialog(
        context: context,
        builder: (BuildContext bc) {
          return Dialog(
            elevation: 0,
            backgroundColor: Color(0xFFDADADA),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7.0)),
            child: Container(
                padding: EdgeInsets.all(10),
                height: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ButtonElevated(
                      title: 'Tandai Halaman ini',
                      width: Get.width,
                      bgcolor: Theme.of(bc).primaryColor,
                      height: 45,
                      color: Colors.white,
                      radius: 7,
                      shadow: false,
                      onPressed: () {
                        Navigator.pop(context);
                        ctrl.bookmarked.value = !ctrl.bookmarked.value;
                        ctrl.bookmark();
                      },
                    ),
                  ],
                )),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(HalamanQuranController());
    final hctrl = Get.find<HomeController>();
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      extendBodyBehindAppBar: false,
      resizeToAvoidBottomInset: false,
      body: layout(ctrl, context, hctrl),
      appBar: _show
          ? SlidingAppBar(
              controller: _controller,
              visible: _visible,
              child: AppBarWSWidget.getAppbarWidget(
                  title: "Alfatihah",
                  context: context,
                  elevation: 0,
                  iconRight: Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(right: 40),
                    // padding: const EdgeInsets.only(right: 20.0),
                    child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            if (MediaQuery.of(context).orientation ==
                                Orientation.portrait) {
                              SystemChrome.setPreferredOrientations(
                                  [DeviceOrientation.landscapeLeft]);
                            } else {
                              SystemChrome.setPreferredOrientations(
                                  [DeviceOrientation.portraitUp]);
                            }
                          },
                          borderRadius: BorderRadius.circular(20),
                          splashColor: Colors.green.withOpacity(0.5),
                          child: Icon(
                            Icons.zoom_in,
                            size: 25,
                            color: Theme.of(context).primaryColor,
                          ),
                        )),
                  ),
                  noBack: true),
            )
          : null,
    );
  }
}
