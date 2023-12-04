import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:masjid_app/components/button/elevatedbutton.dart';
import 'package:masjid_app/components/button/outlinebutton.dart';
import 'package:masjid_app/pages/auth/auth_controller.dart';
import 'package:masjid_app/routes/auth/index.dart';

class LogOutPage extends StatelessWidget {
  const LogOutPage({super.key});

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
              child: Image.asset("assets/img/logo_text_only_primary.png",
                  height: 200)),
          // const Text("Assalamu’alaikum",
          //     style: TextStyle(
          //         fontFamily: "DMSerifDisplay",
          //         color: Color(0xFF048C7C),
          //         fontSize: 28)),
          SizedBox(
            height: 20,
          ),
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
          SizedBox(
            height: 20,
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                    'Anda belum login Silahkan Tekan  \n Tombol Login Di Bawah ini',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black54, fontSize: 14)),
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 21),
            child: ButtonElevated(
              title: 'Login',
              iconLeft: Icon(Icons.account_circle_outlined),
              showIcon: "left",
              nearLeft: false,
              width: Get.width,
              bgcolor: Theme.of(context).primaryColor,
              height: 45,
              color: Colors.white,
              radius: 7,
              onPressed: () {
                Get.offAllNamed(RoutesAuth.root);
              },
            ),
          )

          // Container(
          //     margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
          //     child: ButtonOutline(
          //       onPressed: () {
          //         ctrl.goToHome();
          //       },
          //       radius: 40,
          //       showIcon: "left",
          //       iconLeft: Image.asset(
          //         "assets/img/google.png",
          //         height: 30,
          //       ),
          //       title: "Login dengan Google",
          //       width: 250,
          //       shadow: false,
          //     ))
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
