import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mesjid_app/pages/splashscreen/splashscreen_controller.dart';

class SplashscreenPage extends StatelessWidget {
  const SplashscreenPage({super.key});
  layout() {
    return SafeArea(
      child: SizedBox(
      width: Get.width,
      child:const Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        // children: [
        //   Image.asset(
        //     'assets/img/logo.png',
        //     height: 50,
        //   )
        // ],
      ),
    )
  );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(SplashscreenController());

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      extendBodyBehindAppBar: false,
      body: layout(),
    );
  }
}
