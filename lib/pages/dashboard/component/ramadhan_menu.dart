import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:masjid_app/controllers/waktu_solat_controller.dart';

class RamadhanMenuWidget extends StatelessWidget {
  final WaktuSolatController ctrl = Get.find(); // ctrl
  RamadhanMenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        tanggal(),
        imsak(),
        buka(),
      ],
    );
  }

  Expanded imsak() {
    return Expanded(
        child: Row(children: [
      Expanded(
        child: SvgPicture.asset("assets/icons/imsak.svg"),
      ),
      Expanded(
        child: SizedBox(
          height: Get.height / 15,
          // color: Color(0xFFDCDCDC),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AutoSizeText(
                'Imsak',
                maxLines: 1,
                presetFontSizes: [Get.width / 35],
                style: TextStyle(
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  color: Colors.black,
                ),
              ),
              AutoSizeText(
                ctrl.imsak.value,
                maxLines: 1,
                presetFontSizes: [Get.width / 30],
                style: TextStyle(
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                ),
              )
            ],
          ),
        ),
      )
    ]));
  }

  Expanded buka() {
    return Expanded(
        child: Row(children: [
      Expanded(
        child: SvgPicture.asset("assets/icons/buka.svg"),
      ),
      Expanded(
        child: SizedBox(
          height: Get.height / 15,
          // color: Color(0xFFDCDCDC),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AutoSizeText(
                'Berbuka',
                maxLines: 1,
                presetFontSizes: [Get.width / 35],
                style: TextStyle(
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  color: Colors.black,
                ),
              ),
              AutoSizeText(
                ctrl.berbuka.value,
                maxLines: 1,
                presetFontSizes: [Get.width / 30],
                style: TextStyle(
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                ),
              )
            ],
          ),
        ),
      )
    ]));
  }

  Expanded tanggal() {
    return Expanded(
      flex: 1,
      child: Container(
          height: Get.height / 15,
          padding: EdgeInsets.symmetric(
            horizontal: Get.width / 50,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(Get.width / 50)),
            border: Border.all(
              width: 0.5,
              color: Color(0xFFD9BD63),
            ),
            gradient: LinearGradient(
                begin: Alignment(6.123234262925839e-17, 1),
                end: Alignment(-1, 6.123234262925839e-17),
                colors: [
                  Color.fromRGBO(177, 116, 62, 1),
                  Color.fromRGBO(215, 163, 92, 1)
                ]),
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: AutoSizeText(
                    ctrl.hijriDate['hari'],
                    textAlign: TextAlign.center,
                    presetFontSizes: [Get.width / 15],
                    style: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        fontSize: 20.779720306396484,
                        letterSpacing:
                            0 /*percentages not used in flutter. defaulting to zero*/,
                        fontWeight: FontWeight.bold,
                        height: 1.5 /*PERCENT not supported*/
                        ),
                  ),
                ),
                SizedBox(
                  width: Get.width / 50,
                ),
                Expanded(
                  flex: 2,
                  child: AutoSizeText(
                    '${ctrl.hijriDate['bulan']} ${ctrl.hijriDate['tahun']} Hijriah',
                    textAlign: TextAlign.left,
                    maxLines: 2,
                    presetFontSizes: [Get.width / 35],
                    style: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        letterSpacing: 0,
                        fontWeight: FontWeight.normal,
                        height: 1.3),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
