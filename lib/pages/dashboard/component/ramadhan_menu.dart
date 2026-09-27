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

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE2EBE8),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD06A4C).withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: [
          _buildTanggal(context),
          const SizedBox(width: 8),
          _buildImsak(context, subuhStr),
          const SizedBox(width: 8),
          _buildBuka(context, maghribStr),
        ],
      ),
    );
  }

  Widget _buildImsak(BuildContext context, String time) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAF9),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE8EFEA)),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/icons/imsak.svg',
              height: 28,
              width: 28,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Imsak',
                    maxLines: 1,
                    style: TextStyle(
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      color: Colors.black54,
                      fontSize: 10,
                    ),
                  ),
                  Text(
                    time,
                    maxLines: 1,
                    style: TextStyle(
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      color: const Color(0xFFD06A4C),
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBuka(BuildContext context, String time) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAF9),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE8EFEA)),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/icons/buka.svg',
              height: 28,
              width: 28,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Buka',
                    maxLines: 1,
                    style: TextStyle(
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      color: Colors.black54,
                      fontSize: 10,
                    ),
                  ),
                  Text(
                    time,
                    maxLines: 1,
                    style: TextStyle(
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      color: const Color(0xFFD06A4C),
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTanggal(BuildContext context) {
    final hijri = HijriCalendar.now();

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF8C3B24),
              Color(0xFFD06A4C),
            ],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${hijri.hDay}',
              style: const TextStyle(
                color: Color(0xFFECA843),
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    hijri.longMonthName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${hijri.hYear} H',
                    maxLines: 1,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
