import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mesjid_app/pages/splashscreen/splashscreen_controller.dart';

class SplashscreenPage extends StatelessWidget {
  const SplashscreenPage({super.key});
  layout() {
    return SizedBox(
        width: Get.width,
        child: Container(
          constraints: const BoxConstraints.expand(),
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/img/bg_grad.png"),
                  fit: BoxFit.fill)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/img/logo_text.png',
                height: 150,
              )
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    Get.put(SplashscreenController());

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      extendBodyBehindAppBar: true,
      body: layout(),
    );
  }
}
