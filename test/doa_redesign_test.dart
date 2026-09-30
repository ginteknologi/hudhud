import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masjid_app/components/worship/worship_reader_scaffold.dart';
import 'package:masjid_app/components/worship/worship_scripture_block.dart';
import 'package:masjid_app/components/worship/worship_state_views.dart';
import 'package:masjid_app/core/theme/hudhud_theme.dart';

Widget testHarness(Widget child, {double textScale = 1.0}) {
  return MaterialApp(
    theme: ThemeData(
      extensions: const [HudhudTheme.light],
    ),
    home: MediaQuery(
      data: MediaQueryData(textScaler: TextScaler.linear(textScale)),
      child: Scaffold(body: child),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Doa Redesign - Scripture Block & States', () {
    testWidgets('WorshipScriptureBlock renders arabic, latin, and translation',
        (tester) async {
      await tester.pumpWidget(
        testHarness(
          const WorshipScriptureBlock(
            arabic: 'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ',
            latin: 'Bismillahir rahmanir rahim',
            translation: 'Dengan menyebut nama Allah Yang Maha Pengasih lagi Maha Penyayang',
            note: 'Dibaca sebelum memulai segala aktivitas baik',
          ),
        ),
      );

      expect(find.text('بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ'), findsOneWidget);
      expect(find.text('Bismillahir rahmanir rahim'), findsOneWidget);
      expect(find.text('Dengan menyebut nama Allah Yang Maha Pengasih lagi Maha Penyayang'),
          findsOneWidget);
      expect(find.text('Dibaca sebelum memulai segala aktivitas baik'), findsOneWidget);
    });

    testWidgets('WorshipScriptureBlock toggles latin and translation visibility',
        (tester) async {
      await tester.pumpWidget(
        testHarness(
          const WorshipScriptureBlock(
            arabic: 'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً',
            latin: 'Rabbana atina fiddunya hasanah',
            translation: 'Ya Tuhan kami, berilah kami kebaikan di dunia',
            showLatin: false,
            showTranslation: false,
          ),
        ),
      );

      expect(find.text('رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً'), findsOneWidget);
      expect(find.text('Rabbana atina fiddunya hasanah'), findsNothing);
      expect(find.text('Ya Tuhan kami, berilah kami kebaikan di dunia'), findsNothing);
    });

    testWidgets('WorshipScriptureBlock scales safely at text scale 1.0, 1.3, 2.0 without overflow',
        (tester) async {
      for (final scale in [1.0, 1.3, 2.0]) {
        await tester.pumpWidget(
          testHarness(
            const SingleChildScrollView(
              child: WorshipScriptureBlock(
                arabic: 'اللَّهُمَّ إِنِّي أَسْأَلُكَ الْهُدَى وَالتُّقَى وَالْعَفَافَ وَالْغِنَى',
                latin: "Allahumma inni as'alukal huda wat tuqa wal 'afafa wal ghina",
                translation:
                    'Ya Allah, sesungguhnya aku memohon kepada-Mu petunjuk, ketakwaan, kesucian diri, dan kecukupan.',
              ),
            ),
            textScale: scale,
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      }
    });

    testWidgets('WorshipReaderScaffold displays title, subtitle, and back button with min 48dp target',
        (tester) async {
      await tester.pumpWidget(
        testHarness(
          const WorshipReaderScaffold(
            title: 'Doa Sehari-hari',
            subtitle: 'Kumpulan doa harian',
            body: Center(child: Text('Konten')),
          ),
        ),
      );

      expect(find.text('Doa Sehari-hari'), findsOneWidget);
      expect(find.text('Kumpulan doa harian'), findsOneWidget);
      expect(find.text('Konten'), findsOneWidget);

      final backButtonFinder = find.byType(IconButton).first;
      final size = tester.getSize(backButtonFinder);
      expect(size.width, greaterThanOrEqualTo(48.0));
      expect(size.height, greaterThanOrEqualTo(48.0));
    });

    testWidgets('WorshipStateViews renders empty and error states with retry callback',
        (tester) async {
      var retried = false;
      await tester.pumpWidget(
        testHarness(
          Column(
            children: [
              const WorshipEmptyView(
                title: 'Doa Tidak Ditemukan',
                message: 'Coba kata kunci lain',
              ),
              WorshipErrorView(
                title: 'Gagal Memuat Doa',
                message: 'Periksa koneksi internet Anda',
                onRetry: () => retried = true,
              ),
            ],
          ),
        ),
      );

      expect(find.text('Doa Tidak Ditemukan'), findsOneWidget);
      expect(find.text('Gagal Memuat Doa'), findsOneWidget);

      final retryButton = find.text('Coba Lagi');
      expect(retryButton, findsOneWidget);

      final retrySize = tester.getSize(find.byType(FilledButton));
      expect(retrySize.height, greaterThanOrEqualTo(48.0));

      await tester.tap(retryButton);
      expect(retried, isTrue);
    });
  });
}
