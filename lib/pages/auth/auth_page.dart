import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mesjid_app/components/button/outlinebutton.dart';
import 'package:mesjid_app/pages/auth/auth_controller.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(AuthController());

    layout(AuthController ctrl, BuildContext context) {
      return SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
              alignment: Alignment.center,
              child: Image.asset("assets/img/masjid2.png", height: 200)),
          const Text("Assalamu’alaikum",
              style: TextStyle(
                  fontFamily: "DMSerifDisplay",
                  color: Color(0xFF048C7C),
                  fontSize: 28)),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text('Selamat datang di aplikasi \n Masjid An-Ni’mah',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black54, fontSize: 14)),
              )
            ],
          ),
          // const Padding(
          //     padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
          //     child: Flexible(
          //       child: Text('Selamat datang di aplikasi \n Masjid An-Ni’mah',
          //           textAlign: TextAlign.center,
          //           style: TextStyle(color: Colors.black54, fontSize: 14)),
          //     )),
          Container(
              margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
              child: ButtonOutline(
                onPressed: () {
                  ctrl.goToHome();
                },
                radius: 40,
                showIcon: "left",
                iconLeft: Image.asset(
                  "assets/img/google.png",
                  height: 30,
                ),
                title: "Login dengan Google",
                width: 250,
                shadow: false,
              ))
        ],
      ));
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      extendBodyBehindAppBar: false,
      resizeToAvoidBottomInset: false,
      body: layout(ctrl, context),
    );
  }
}
