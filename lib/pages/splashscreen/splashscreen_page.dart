import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mesjid_app/pages/splashscreen/splashscreen_controller.dart';

class SplashscreenPage extends StatelessWidget {
  const SplashscreenPage({super.key});
  layout(BuildContext context) {
    return SizedBox(
        width: Get.width,
        child: Container(
            constraints: const BoxConstraints.expand(),
            decoration: const BoxDecoration(color: Color(0xFF0DA49D)),
            padding: EdgeInsets.symmetric(horizontal: 21),
            child: Stack(children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      'assets/img/logo-text-only.svg',
                      height: 90,
                    ),
                  )

                  // Image.asset(
                  //   'assets/img/logo-text-only.png',
                  //   height: 150,
                  // ),
                  // Text("Masjid An-Ni’mah",
                  //     style: TextStyle(
                  //         fontFamily: "DMSerifDisplay",
                  //         color: Theme.of(context).primaryColor,
                  //         fontSize: 30)),
                  // Text("CITRAGRAN-CIBUBUR",
                  //     style: TextStyle(
                  //         color: Theme.of(context).primaryColor,
                  //         fontSize:
                  //             Theme.of(context).textTheme.titleSmall?.fontSize))
                ],
              ),
              Positioned(
                  bottom: kBottomNavigationBarHeight,
                  width: Get.width - 42,
                  child: Align(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.copyright,
                          color: Colors.white,
                          size:
                              Theme.of(context).textTheme.titleSmall?.fontSize,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text("2023 Masjidannimah.id",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w300,
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.fontSize))
                      ],
                    ),
                  ))
            ])));
  }

  @override
  Widget build(BuildContext context) {
    Get.put(SplashscreenController());

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      extendBodyBehindAppBar: true,
      body: layout(context),
    );
  }
}
