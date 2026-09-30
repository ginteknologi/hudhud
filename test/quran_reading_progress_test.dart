import 'package:flutter_test/flutter_test.dart';
import 'package:masjid_app/core/storage/bookmark_storage.dart';
import 'package:masjid_app/core/storage/preferences_service.dart';
import 'package:masjid_app/core/storage/quran_reading_progress_storage.dart';
import 'package:masjid_app/models/bookmark_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await PreferencesService.init();
  });

  test('continue reading follows the most recently viewed format and position',
      () {
    QuranReadingProgressStorage.save(const QuranReadingProgress(
      mode: QuranReadingMode.ayat,
      surahName: 'Al-Fatihah',
      surahNumber: 1,
      ayatNumber: 4,
    ));
    QuranReadingProgressStorage.save(const QuranReadingProgress(
      mode: QuranReadingMode.madinah,
      surahName: 'Al-Baqarah',
      pageNumber: 12,
    ));

    final latest = QuranReadingProgressStorage.getLatest();
    expect(latest?.mode, QuranReadingMode.madinah);
    expect(latest?.pageNumber, 12);
    expect(latest?.surahName, 'Al-Baqarah');
  });

  test('automatic reading position does not create a manual bookmark', () {
    final manual = BookmarkStorage('indonesia_saved');
    final legacyPosition = BookmarkStorage('indonesia');
    legacyPosition.saveBookmark(BookmarkData(
      namaSurat: 'Al-Fatihah',
      surat: 0,
      ayat: 0,
      totalAyat: 0,
      index: 1,
    ));
    QuranReadingProgressStorage.save(const QuranReadingProgress(
      mode: QuranReadingMode.indonesia,
      surahName: 'Al-Baqarah',
      pageNumber: 4,
    ));
    expect(manual.getBookmark().index, 0);

    manual.saveBookmark(BookmarkData(
      namaSurat: 'Al-Baqarah',
      surat: 0,
      ayat: 0,
      totalAyat: 0,
      index: 4,
    ));
    expect(manual.getBookmark().index, 4);
    manual.clearBookmark();
    expect(manual.getBookmark().index, 0);
    expect(QuranReadingProgressStorage.getLatest()?.pageNumber, 4);
    expect(legacyPosition.getBookmark().index, 1);
  });
}
