import 'dart:math';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:mesjid_app/pages/onboarding/onboard_controller.dart';
import 'package:mesjid_app/components/button/buttonvariant.dart';

class OnboardPage extends StatelessWidget {
  OnboardPage({super.key});

  // late int index;

  final onboardingPagesList = [
    PageViewModel(
      titleWidget: const Text("Jadwal Sholat",
          style: TextStyle(
              fontFamily: "DMSerifDisplay", color: Colors.black, fontSize: 30)),
      bodyWidget: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Text('Selamat datang di aplikasi \n Masjid An-Ni’mah',
                textAlign: TextAlign.center),
          )
        ],
      ),
      image: Center(
          child: Image.asset(
        "assets/img/pray-night.png",
        height: 200,
      )),
    ),
    PageViewModel(
      titleWidget: const Text("Al-Qur'an Digital",
          style: TextStyle(
              fontFamily: "DMSerifDisplay", color: Colors.black, fontSize: 30)),
      bodyWidget: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Text('Selamat datang di aplikasi \n Masjid An-Ni’mah',
                textAlign: TextAlign.center),
          )
        ],
      ),
      image: Center(
          child: Image.asset(
        "assets/img/alquran.png",
        height: 200,
      )),
    ),
    PageViewModel(
      titleWidget: const Flexible(
        child: Text("Fitur dan Konten Islami",
            style: TextStyle(
                fontFamily: "DMSerifDisplay",
                color: Colors.black,
                fontSize: 30)),
      ),
      bodyWidget: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Text('Selamat datang di aplikasi \n Masjid An-Ni’mah',
                textAlign: TextAlign.center),
          )
        ],
      ),
      image: Center(
          child: Image.asset(
        "assets/img/pray-night.png",
        height: 200,
      )),
    ),
  ];
  final _introKey = GlobalKey<IntroductionScreenState>();
  layout(OnboardController ctrl, BuildContext context) {
    return SafeArea(
        child: SizedBox(
            width: Get.width,
            child: IntroductionScreen(
              key: _introKey,
              pages: onboardingPagesList,
              showSkipButton: false,
              showNextButton: true,
              showBackButton: true,
              done: const Text("Done"),
              controlsPosition: const Position(left: 0, right: 0, bottom: 100),
              overrideNext: ElevatedButton(
                onPressed: () {
                  _introKey.currentState?.next();
                },
                style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(), //<-- SEE HERE
                    padding: const EdgeInsets.all(15),
                    backgroundColor: Theme.of(context).primaryColor),
                child: const Icon(
                  //<-- SEE HERE
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              overrideBack: ElevatedButton(
                onPressed: () {
                  _introKey.currentState?.previous();
                },
                style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(), //<-- SEE HERE
                    padding: const EdgeInsets.all(15),
                    side: BorderSide(
                        width: 2.0, color: Theme.of(context).primaryColor),
                    backgroundColor: Colors.white),
                child: Icon(
                  //<-- SEE HERE
                  Icons.arrow_back,
                  color: Theme.of(context).primaryColor,
                  size: 24,
                ),
              ),
              onDone: () {
                // On button pressed
                ctrl.goToLogin();
              },
            )));
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(OnboardController());

    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark));

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      extendBodyBehindAppBar: false,
      body: layout(ctrl, context),
    );
  }
}
