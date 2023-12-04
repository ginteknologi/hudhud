// import 'dart:async';
// import 'package:animate_do/animate_do.dart';
// import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:masjid_app/components/button/elevatedbutton.dart';
// import 'package:masjid_app/components/input/InputText.dart';
import 'package:masjid_app/components/layout/app_bar_ws.dart';
import 'package:masjid_app/components/layout/sliding_app_bar.dart';
// import 'package:masjid_app/components/partial/list_ui.dart';
import 'package:masjid_app/pages/home/home_controller.dart';
import 'package:masjid_app/pages/quran/halaman/component/image_viewer_widget.dart';
import 'package:masjid_app/pages/quran/halaman/halaman_quran_controller.dart';
// import 'package:masjid_app/pages/quran/quran_controller.dart';
// import 'package:masjid_app/theme.dart';

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
                GestureDetector(
                    onTap: () {
                      setState(() {
                        _visible = !_visible;
                        _show = !_show;
                      });
                      ctrlHome.visible.value = !ctrlHome.visible.value;
                      ctrlHome.selectedIdx.value = 1;
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: EasyImageViewPager(
                              onTap: (int index) {
                                showPopup(ctrl, context, ctrlHome);
                              },
                              idxInitial: ctrlHome.idxLastReadHalaman.value,
                              imageProviders: ctrl.listSurah),
                        ),
                      ],
                    ))
              ],
            )));
  }

  bool _visible = false;
  bool _show = false;
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
                  title: "Al-Quran",
                  context: context,
                  elevation: 0,
                  iconRight: Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(right: 40),
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
