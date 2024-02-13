import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:masjid_app/components/button/outlinebutton.dart';
import 'package:masjid_app/pages/auth/auth_controller.dart';

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
          const Text("Assalamu’alaikum \n Warahmatullahi Wabarakatuh",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: "DMSerifDisplay",
                  color: Color(0xFF048C7C),
                  fontSize: 28)),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text('Selamat datang di aplikasi',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black54, fontSize: 14)),
              )
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Align(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/img/new-logo.png',
                width: 256,
              )),
          // child: SvgPicture.asset(
          // 'assets/img/new-logo.png',
          // width: 170,
          // )),
          // const Padding(
          //     padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
          //     child: Flexible(
          //       child: Text('Selamat datang di aplikasi \n Masjid An-Ni’mah',
          //           textAlign: TextAlign.center,
          //           style: TextStyle(color: Colors.black54, fontSize: 14)),
          //     )),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: ButtonOutline(
              onPressed: () {
                ctrl.loginGuest();
              },
              radius: 40,
              showIcon: "left",
              title: "Guest Login",
              width: 250,
              shadow: false,
            ),
          ),
          Container(
              margin: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: ButtonOutline(
                onPressed: () {
                  ctrl.loginGoogle();
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
              )),
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
