import 'package:flutter_test/flutter_test.dart';
import 'package:masjid_app/providers/quran_ui_settings_provider.dart';

void main() {
  group('QuranUiSettings Unit Tests', () {
    test('Default settings are correct', () {
      final settings = QuranUiSettings();
      expect(settings.arabicFontSize, 24.0);
      expect(settings.translationFontSize, 13.5);
      expect(settings.showLatin, true);
      expect(settings.showTranslation, true);
      expect(settings.selectedQori, 'ar.alafasy');
    });

    test('copyWith updates fields properly', () {
      final settings = QuranUiSettings();
      final updated = settings.copyWith(
        arabicFontSize: 32.0,
        showLatin: false,
        selectedQori: 'ar.sudais',
      );

      expect(updated.arabicFontSize, 32.0);
      expect(updated.translationFontSize, 13.5);
      expect(updated.showLatin, false);
      expect(updated.showTranslation, true);
      expect(updated.selectedQori, 'ar.sudais');
    });
  });
}
