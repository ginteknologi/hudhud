import 'package:flutter_test/flutter_test.dart';
import 'package:masjid_app/providers/hadits_ui_settings_provider.dart';
import 'package:masjid_app/storage/hadits_bookmark_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:masjid_app/core/storage/preferences_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await PreferencesService.init();
  });

  group('HaditsBookmarkData & HaditsBookmarkStorage Tests', () {
    test('HaditsBookmarkData validation', () {
      final invalid = HaditsBookmarkData(
        namaTabel: '',
        longNama: '',
        idKitab: 1,
        kitabIndonesia: '',
        noHdt: 0,
      );
      expect(invalid.isValid, false);

      final valid = HaditsBookmarkData(
        namaTabel: 'bukhari',
        longNama: 'Shahih Bukhari',
        idKitab: 1,
        kitabIndonesia: 'Permulaan Wahyu',
        idBab: 1,
        babIndonesia: 'Niat',
        noHdt: 1,
        totalHadits: 7008,
      );
      expect(valid.isValid, true);
    });

    test('HaditsBookmarkStorage save and retrieve', () {
      final data = HaditsBookmarkData(
        namaTabel: 'arbain',
        longNama: "Hadits Arba'in An-Nawawiyah",
        idKitab: 1,
        kitabIndonesia: "Arba'in An-Nawawiyah",
        idBab: 1,
        babIndonesia: 'Niat dan Ikhlas',
        noHdt: 1,
        totalHadits: 42,
        snippet: 'Innamal a\'malu binniyyat',
      );

      HaditsBookmarkStorage.saveBookmark(data);

      final retrieved = HaditsBookmarkStorage.getBookmark();
      expect(retrieved, isNotNull);
      expect(retrieved!.namaTabel, 'arbain');
      expect(retrieved.longNama, "Hadits Arba'in An-Nawawiyah");
      expect(retrieved.noHdt, 1);
      expect(retrieved.totalHadits, 42);
      expect(retrieved.snippet, 'Innamal a\'malu binniyyat');
    });

    test('HaditsBookmarkStorage clear', () {
      final data = HaditsBookmarkData(
        namaTabel: 'muslim',
        longNama: 'Shahih Muslim',
        idKitab: 1,
        kitabIndonesia: 'Kitab Iman',
        noHdt: 5,
      );
      HaditsBookmarkStorage.saveBookmark(data);
      expect(HaditsBookmarkStorage.getBookmark(), isNotNull);

      HaditsBookmarkStorage.clear();
      expect(HaditsBookmarkStorage.getBookmark(), isNull);
    });
  });

  group('HaditsUiSettings Tests', () {
    test('Default settings', () {
      const settings = HaditsUiSettings();
      expect(settings.arabicFontSize, 24.0);
      expect(settings.translationFontSize, 14.0);
      expect(settings.showArabic, true);
      expect(settings.showTranslation, true);
    });

    test('copyWith updates settings', () {
      const settings = HaditsUiSettings();
      final updated = settings.copyWith(
        arabicFontSize: 28.0,
        translationFontSize: 16.0,
        showArabic: false,
      );
      expect(updated.arabicFontSize, 28.0);
      expect(updated.translationFontSize, 16.0);
      expect(updated.showArabic, false);
      expect(updated.showTranslation, true);
    });
  });
}
