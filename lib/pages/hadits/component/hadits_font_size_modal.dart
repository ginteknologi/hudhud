import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:masjid_app/providers/hadits_ui_settings_provider.dart';

class HaditsFontSizeModal extends ConsumerWidget {
  const HaditsFontSizeModal({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const HaditsFontSizeModal(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(haditsUiSettingsProvider);
    final notifier = ref.read(haditsUiSettingsProvider.notifier);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        16,
        20,
        MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pengaturan Teks Hadits',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFD06A4C),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 20, color: Colors.black54),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const Divider(height: 20),

          // Pengaturan Font Arab
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ukuran Teks Arab',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Text(
                '${settings.arabicFontSize.round()} pt',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFD06A4C),
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: const Color(0xFFD06A4C),
              thumbColor: const Color(0xFFD06A4C),
              inactiveTrackColor: const Color(0xFFE2EBE8),
            ),
            child: Slider(
              value: settings.arabicFontSize,
              min: 18.0,
              max: 36.0,
              divisions: 9,
              onChanged: (val) => notifier.setArabicFontSize(val),
            ),
          ),

          const SizedBox(height: 10),

          // Pengaturan Font Terjemahan
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ukuran Terjemahan',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Text(
                '${settings.translationFontSize.round()} pt',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFD06A4C),
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: const Color(0xFFD06A4C),
              thumbColor: const Color(0xFFD06A4C),
              inactiveTrackColor: const Color(0xFFE2EBE8),
            ),
            child: Slider(
              value: settings.translationFontSize,
              min: 12.0,
              max: 22.0,
              divisions: 5,
              onChanged: (val) => notifier.setTranslationFontSize(val),
            ),
          ),

          const SizedBox(height: 14),

          // Live Preview Box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAF9),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2EBE8)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Pratinjau:',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.black45,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'إِنَّمَا الأَعْمَالُ بِالنِّيَّاتِ',
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  style: GoogleFonts.amiri(
                    fontSize: settings.arabicFontSize,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFD06A4C),
                    height: 1.8,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Sesungguhnya setiap amalan tergantung pada niatnya.',
                  style: GoogleFonts.poppins(
                    fontSize: settings.translationFontSize,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
