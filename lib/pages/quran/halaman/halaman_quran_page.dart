import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mesjid_app/components/input/InputText.dart';
import 'package:mesjid_app/components/partial/list_ui.dart';
import 'package:mesjid_app/pages/quran/halaman/halaman_quran_controller.dart';
import 'package:mesjid_app/theme.dart';

class HalamanQuranPage extends StatelessWidget {
  const HalamanQuranPage({super.key});

  layout(HalamanQuranController ctrl, BuildContext context) {
    return SafeArea(
        child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.only(left: 21, right: 21),
                  child: Container(
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                      image: AssetImage("assets/img/quran/quran_page_1.png"),
                      fit: BoxFit.contain,
                      alignment: Alignment.topCenter,
                    )),
                    height: Get.height,
                    width: Get.width,
                  ),
                ))));
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(HalamanQuranController());

    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      extendBodyBehindAppBar: false,
      resizeToAvoidBottomInset: false,
      body: layout(ctrl, context),
    );
  }
}
