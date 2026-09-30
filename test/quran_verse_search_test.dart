import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:masjid_app/core/storage/preferences_service.dart';
import 'package:masjid_app/core/theme/hudhud_theme.dart';
import 'package:masjid_app/models/quran_models.dart';
import 'package:masjid_app/pages/quran/list_ayat/list_ayat_quran_page.dart';
import 'package:masjid_app/providers/quran_ayat_providers.dart';
import 'package:masjid_app/providers/quran_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('pencarian di pembaca dapat mencari di surah lain',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    await PreferencesService.init();
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (_, __) => const ListAyatQuranPage()),
      ],
    );
    await tester.pumpWidget(ProviderScope(
      overrides: [
        surahListRawProvider('').overrideWith((ref) async => [
              {'id': 1, 'nama': 'Al-Fatihah', 'ayat': 1, 'arab': 'الفاتحة'},
              {'id': 2, 'nama': 'Al-Baqarah', 'ayat': 1, 'arab': 'البقرة'},
            ]),
        surahDetailProvider(1).overrideWith((ref) async => [
              AyatModel(surat: 1, ayat: 1, arab: 'بسم الله', arti: 'Pembukaan'),
            ]),
        surahDetailProvider(2).overrideWith((ref) async => [
              AyatModel(surat: 2, ayat: 1, arab: 'الم', arti: 'Petunjuk'),
            ]),
      ],
      child: MaterialApp.router(
        theme: ThemeData(extensions: const [HudhudTheme.light]),
        routerConfig: router,
      ),
    ));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Cari & Lompat Ayat'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cari Kata'));
    await tester.pumpAndSettle();
    expect(find.text('Navigasi & Pencarian Ayat'), findsOneWidget);
    expect(find.text('Cari kata dalam Al-Fatihah...'), findsOneWidget);
    await tester.tap(find.text('Ganti surah'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Al-Baqarah').last);
    await tester.pumpAndSettle();
    expect(find.text('Cari kata dalam Al-Baqarah...'), findsOneWidget);

    await tester.enterText(find.byType(TextField).last, 'Petunjuk');
    await tester.pumpAndSettle();
    expect(find.textContaining('Petunjuk'), findsWidgets);
    await tester.tap(find.byType(ListTile).last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Petunjuk').last);
    await tester.pumpAndSettle();
    expect(find.text('Ayat 1 dari 1'), findsOneWidget);
    expect(find.text('Putar murotal'), findsOneWidget);
    expect(find.text('Tandai ayat'), findsOneWidget);
    expect(find.text('Bagikan ayat'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
