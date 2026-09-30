import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masjid_app/core/storage/preferences_service.dart';
import 'package:masjid_app/core/storage/bookmark_storage.dart';
import 'package:masjid_app/core/theme/hudhud_theme.dart';
import 'package:masjid_app/models/bookmark_data.dart';
import 'package:masjid_app/models/quran_models.dart';
import 'package:masjid_app/pages/quran/new_quran/alquran_page.dart';
import 'package:masjid_app/providers/quran_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('header content scrolls while title and tabs stay pinned',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    await PreferencesService.init();
    BookmarkStorage('indonesia').saveBookmark(BookmarkData(
      namaSurat: 'Al-Fatihah',
      surat: 0,
      ayat: 0,
      totalAyat: 0,
      index: 1,
    ));
    await tester.pumpWidget(ProviderScope(
      overrides: [
        surahListProvider('').overrideWith((ref) async => List.generate(
              30,
              (index) => SurahModel(
                id: index + 1,
                nama: 'Surah ${index + 1}',
                jumlahAyat: 7,
              ),
            )),
      ],
      child: MaterialApp(
        theme: ThemeData(extensions: const [HudhudTheme.light]),
        home: const AlquranPage(),
      ),
    ));
    await tester.pumpAndSettle();

    expect(find.text('Tilawah hari ini'), findsOneWidget);
    await tester.drag(find.byType(ListView).first, const Offset(0, -450));
    await tester.pumpAndSettle();

    expect(find.text('Tilawah hari ini'), findsNothing);
    expect(find.text("Al-Qur'an"), findsOneWidget);
    expect(find.text('Surah').first, findsOneWidget);
    expect(tester.getTopLeft(find.text('Surah').first).dy, lessThan(120));
    await tester.tap(find.text('Tanda baca'));
    await tester.pumpAndSettle();
    expect(find.text('Belum ada tanda baca'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
