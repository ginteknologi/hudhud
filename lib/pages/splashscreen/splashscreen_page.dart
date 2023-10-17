import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mesjid_app/pages/splashscreen/splashscreen_controller.dart';

class SplashscreenPage extends StatelessWidget {
  const SplashscreenPage({super.key});
  layout(BuildContext context) {
    return SizedBox(
        width: Get.width,
        child: Container(
          constraints: const BoxConstraints.expand(),
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/img/bg_grad2.png"),
                  fit: BoxFit.fill)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/img/logo_app.png',
                height: 150,
              ),
              Text("Masjid An-Ni’mah",
                  style: TextStyle(
                      fontFamily: "DMSerifDisplay",
                      color: Theme.of(context).primaryColor,
                      fontSize: 30)),
              Text("CITRAGRAN-CIBUBUR",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize:
                          Theme.of(context).textTheme.titleSmall?.fontSize))
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
      body: layout(context),
    );
  }
}
