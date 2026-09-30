import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masjid_app/core/storage/preferences_service.dart';
import 'package:masjid_app/core/storage/quran_reading_progress_storage.dart';
import 'package:masjid_app/core/theme/hudhud_theme.dart';
import 'package:masjid_app/models/quran_models.dart';
import 'package:masjid_app/pages/quran/new_quran/alquran_page.dart';
import 'package:masjid_app/providers/quran_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('mencari ayat di beranda tidak mengubah bacaan terakhir',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    await PreferencesService.init();
    QuranReadingProgressStorage.save(const QuranReadingProgress(
      mode: QuranReadingMode.ayat,
      surahName: 'Al-Baqarah',
      surahNumber: 2,
      ayatNumber: 5,
    ));

    await tester.pumpWidget(ProviderScope(
      overrides: [
        surahListProvider('').overrideWith((ref) async => [
              SurahModel(id: 1, nama: 'Al-Fatihah', jumlahAyat: 7),
              SurahModel(id: 2, nama: 'Al-Baqarah', jumlahAyat: 286),
            ]),
        surahDetailProvider(2).overrideWith((ref) async => [
              AyatModel(surat: 2, ayat: 5, arab: 'الم', arti: 'Petunjuk'),
            ]),
        surahDetailProvider(1).overrideWith((ref) async => [
              AyatModel(surat: 1, ayat: 1, arab: 'بسم الله', arti: 'Pembukaan'),
            ]),
      ],
      child: MaterialApp(
        theme: ThemeData(extensions: const [HudhudTheme.light]),
        home: const AlquranPage(),
      ),
    ));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Cari ayat dalam surah'));
    await tester.pumpAndSettle();
    expect(find.text('Cari ayat'), findsOneWidget);
    expect(find.text('Ganti'), findsOneWidget);
    expect(find.text('Al-Baqarah'), findsWidgets);
    expect(QuranReadingProgressStorage.getLatest()?.surahNumber, 2);
    expect(QuranReadingProgressStorage.getLatest()?.ayatNumber, 5);

    await tester.enterText(find.byType(TextField).last, 'Petunjuk');
    await tester.pumpAndSettle();
    expect(find.text('1 ayat ditemukan'), findsOneWidget);
    expect(QuranReadingProgressStorage.getLatest()?.ayatNumber, 5);

    await tester.tap(find.text('Ganti'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Al-Fatihah').last);
    await tester.pumpAndSettle();
    expect(QuranReadingProgressStorage.getLatest()?.surahNumber, 2);
    expect(QuranReadingProgressStorage.getLatest()?.ayatNumber, 5);

    await tester.tap(find.byTooltip('Tutup'));
    await tester.pumpAndSettle();
    expect(find.text('Cari ayat'), findsNothing);
    expect(QuranReadingProgressStorage.getLatest()?.ayatNumber, 5);
    expect(tester.takeException(), isNull);
  });
}
