import 'package:animate_do/animate_do.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mesjid_app/components/button/elevatedbutton.dart';
import 'package:mesjid_app/components/layout/app_bar_ws.dart';
import 'package:mesjid_app/components/partial/list_ui.dart';
import 'package:mesjid_app/pages/notifikasi/detail/detail_notifikasi_controller.dart';
import 'package:mesjid_app/routes/home/index.dart';
import 'package:mesjid_app/theme.dart';

class DetailNotifikasiPage extends StatelessWidget {
  const DetailNotifikasiPage({super.key});

  layout(BuildContext context, DetailNotifikasiController ctrl) {
    return SafeArea(
        child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Padding(
                    padding: EdgeInsets.only(left: 21, right: 21, top: 21),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Image.asset(
                            "assets/img/logo_circle.png",
                            fit: BoxFit.fitHeight,
                            width: 100,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text("Jazakallah Khairon",
                              style: context.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.normal,
                                  fontFamily: "DMSerifDisplay",
                                  color: Theme.of(context).primaryColor)
                              // TextStyle(
                              //     fontFamily: "DMSerifDisplay",
                              //     color: Color(0xFF048C7C),
                              //     fontSize: 30)
                              ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text("Insan Al-sampurna",
                              style: context.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black)
                              // TextStyle(
                              //     fontFamily: "DMSerifDisplay",
                              //     color: Color(0xFF048C7C),
                              //     fontSize: 30)
                              ),
                        )
                      ],
                    )))));
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(DetailNotifikasiController());

    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBarWSWidget.getAppbarWidget(
            title: "", context: context, elevation: 0),
        body: layout(context, ctrl),
        persistentFooterButtons: [
          Padding(
            padding: const EdgeInsets.only(left: 21, right: 21),
            child: Container(
              width: Get.width,
              child: ButtonElevated(
                title: 'Kembali Ke Beranda',
                width: Get.width,
                bgcolor: Theme.of(context).primaryColor,
                height: 45,
                color: Colors.white,
                radius: 5,
                onPressed: () {
                  Get.offAllNamed(RoutesHome.root);
                },
              ),
            ),
          )
        ]);
  }
}
