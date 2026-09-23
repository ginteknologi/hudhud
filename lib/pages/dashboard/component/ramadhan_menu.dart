import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:masjid_app/providers/jadwal_shalat_provider.dart';

class RamadhanMenuWidget extends ConsumerWidget {
  const RamadhanMenuWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jadwalAsync = ref.watch(jadwalShalatProvider);
    final jadwal = jadwalAsync.valueOrNull;

    final subuhStr = jadwal?.subuh ?? '--:--';
    final maghribStr = jadwal?.maghrib ?? '--:--';

    return Row(
      children: [
        _buildTanggal(context),
        _buildImsak(context, subuhStr),
        _buildBuka(context, maghribStr),
      ],
    );
  }

  Widget _buildImsak(BuildContext context, String time) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Expanded(
      child: Row(
        children: [
          Expanded(
            child: SvgPicture.asset('assets/icons/imsak.svg'),
          ),
          Expanded(
            child: SizedBox(
              height: screenHeight / 15,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AutoSizeText(
                    'Imsak',
                    maxLines: 1,
                    presetFontSizes: [screenWidth / 35],
                    style: TextStyle(
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      color: Colors.black,
                    ),
                  ),
                  AutoSizeText(
                    time,
                    maxLines: 1,
                    presetFontSizes: [screenWidth / 30],
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
        ],
      ),
    );
  }

  Widget _buildBuka(BuildContext context, String time) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Expanded(
      child: Row(
        children: [
          Expanded(
            child: SvgPicture.asset('assets/icons/buka_puasa.svg'),
          ),
          Expanded(
            child: SizedBox(
              height: screenHeight / 15,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AutoSizeText(
                    'Buka',
                    maxLines: 1,
                    presetFontSizes: [screenWidth / 35],
                    style: TextStyle(
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      color: Colors.black,
                    ),
                  ),
                  AutoSizeText(
                    time,
                    maxLines: 1,
                    presetFontSizes: [screenWidth / 30],
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
        ],
      ),
    );
  }

  Widget _buildTanggal(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final hijri = HijriCalendar.now();

    return Expanded(
      child: Container(
        height: screenHeight / 15,
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth / 50,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(screenWidth / 50)),
          border: Border.all(
            width: 0.5,
            color: const Color(0xFFD9BD63),
          ),
          gradient: const LinearGradient(
            begin: Alignment(0, 1),
            end: Alignment(-1, 0),
            colors: [
              Color.fromRGBO(177, 116, 62, 1),
              Color.fromRGBO(215, 163, 92, 1)
            ],
          ),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: AutoSizeText(
                  '${hijri.hDay}',
                  textAlign: TextAlign.center,
                  presetFontSizes: [screenWidth / 15],
                  style: const TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: screenWidth / 50),
              Expanded(
                flex: 2,
                child: AutoSizeText(
                  '${hijri.longMonthName} ${hijri.hYear} H',
                  textAlign: TextAlign.left,
                  maxLines: 2,
                  presetFontSizes: [screenWidth / 35],
                  style: TextStyle(
                    color: const Color.fromRGBO(255, 255, 255, 1),
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.normal,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
