import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:masjid_app/core/theme/hudhud_theme.dart';

class WorshipScriptureBlock extends StatelessWidget {
  const WorshipScriptureBlock({
    super.key,
    required this.arabic,
    this.latin,
    this.translation,
    this.note,
    this.arabicFontSize = 24.0,
    this.translationFontSize = 14.0,
    this.showArabic = true,
    this.showLatin = true,
    this.showTranslation = true,
    this.arabicFontFamily,
  });

  final String arabic;
  final String? latin;
  final String? translation;
  final String? note;
  final double arabicFontSize;
  final double translationFontSize;
  final bool showArabic;
  final bool showLatin;
  final bool showTranslation;
  final String? arabicFontFamily;

  @override
  Widget build(BuildContext context) {
    final t = context.hudhud;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showArabic && arabic.trim().isNotEmpty) ...[
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              arabic.trim(),
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              style: arabicFontFamily != null
                  ? TextStyle(
                      fontFamily: arabicFontFamily,
                      fontSize: arabicFontSize,
                      height: 2.0,
                      color: t.charcoal,
                    )
                  : GoogleFonts.amiri(
                      fontSize: arabicFontSize,
                      height: 2.0,
                      color: t.charcoal,
                    ),
            ),
          ),
          const SizedBox(height: 12),
        ],
        if (showLatin && latin != null && latin!.trim().isNotEmpty) ...[
          Text(
            latin!.trim(),
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: translationFontSize,
              fontStyle: FontStyle.italic,
              height: 1.5,
              color: t.muted,
            ),
          ),
          const SizedBox(height: 10),
        ],
        if (showTranslation &&
            translation != null &&
            translation!.trim().isNotEmpty) ...[
          Text(
            translation!.trim(),
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: translationFontSize,
              height: 1.6,
              color: t.charcoal,
            ),
          ),
          const SizedBox(height: 10),
        ],
        if (note != null && note!.trim().isNotEmpty) ...[
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: t.surface,
              borderRadius: BorderRadius.circular(t.radiusMd),
              border: Border.all(color: t.outline),
            ),
            child: Text(
              note!.trim(),
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 12,
                height: 1.4,
                color: t.muted,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
