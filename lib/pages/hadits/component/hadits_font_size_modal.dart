import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masjid_app/core/theme/hudhud_theme.dart';
import 'package:masjid_app/providers/hadits_ui_settings_provider.dart';

class HaditsFontSizeModal extends ConsumerWidget {
  const HaditsFontSizeModal({super.key});

  static void show(BuildContext context) {
    final t = context.hudhud;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: t.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(t.radiusMd)),
        ),
        child: const HaditsFontSizeModal(),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.hudhud;
    final settings = ref.watch(haditsUiSettingsProvider);
    final notifier = ref.read(haditsUiSettingsProvider.notifier);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        t.spaceLg,
        t.spaceMd,
        t.spaceLg,
        MediaQuery.of(context).viewInsets.bottom + t.spaceLg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: t.outline,
                borderRadius: BorderRadius.circular(t.radiusSm),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pengaturan Teks Hadits',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: t.charcoal,
                ),
              ),
              IconButton(
                constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                icon: Icon(LucideIcons.x, size: 18, color: t.muted),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(),
          const SizedBox(height: 8),

          // Pengaturan Font Arab
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ukuran Teks Arab',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: t.charcoal,
                ),
              ),
              Text(
                '${settings.arabicFontSize.round()} pt',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: t.terracotta,
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: t.terracotta,
              thumbColor: t.terracotta,
              inactiveTrackColor: t.outline,
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
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: t.charcoal,
                ),
              ),
              Text(
                '${settings.translationFontSize.round()} pt',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: t.terracotta,
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: t.terracotta,
              thumbColor: t.terracotta,
              inactiveTrackColor: t.outline,
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
            padding: EdgeInsets.all(t.spaceMd),
            decoration: BoxDecoration(
              color: t.sand,
              borderRadius: BorderRadius.circular(t.radiusMd),
              border: Border.all(color: t.outline),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Pratinjau:',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: t.muted,
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
                    color: t.charcoal,
                    height: 1.8,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Sesungguhnya setiap amalan tergantung pada niatnya.',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: settings.translationFontSize,
                    color: t.charcoal,
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
