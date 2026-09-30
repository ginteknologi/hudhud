import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masjid_app/core/storage/preferences_service.dart';
import 'package:masjid_app/core/theme/hudhud_theme.dart';
import 'package:masjid_app/models/hadist_data.dart';
import 'package:masjid_app/pages/hadits/component/hadits_font_size_modal.dart';
import 'package:masjid_app/pages/hadits/component/hadits_jump_sheet.dart';
import 'package:masjid_app/pages/hadits/component/hadits_last_read_card.dart';
import 'package:masjid_app/storage/hadits_bookmark_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget testHarness(Widget child,
    {List<Override> overrides = const [], double textScale = 1.0}) {
  return ProviderScope(
    overrides: overrides,
    child: MaterialApp(
      theme: ThemeData(
        extensions: const [HudhudTheme.light],
      ),
      home: MediaQuery(
        data: MediaQueryData(textScaler: TextScaler.linear(textScale)),
        child: Scaffold(body: child),
      ),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await PreferencesService.init();
  });

  group('Hadits Redesign Tests', () {
    testWidgets('HaditsLastReadCard displays Arbain recommendation when empty',
        (tester) async {
      await tester.pumpWidget(
        testHarness(
          const HaditsLastReadCard(),
        ),
      );

      expect(find.text('Rekomendasi Baca'), findsOneWidget);
      expect(find.text("Hadits Arba'in An-Nawawiyah"), findsOneWidget);
      expect(find.text('Mulai Baca'), findsOneWidget);
    });

    testWidgets(
        'HaditsLastReadCard displays saved bookmark and Lanjutkan Baca button',
        (tester) async {
      final mockBookmark = HaditsBookmarkData(
        namaTabel: 'bukhari',
        longNama: 'Shahih Bukhari',
        noHdt: 42,
        babIndonesia: 'Kitab Iman',
        isBookmark: true,
      );
      HaditsBookmarkStorage.saveBookmark(mockBookmark);

      await tester.pumpWidget(
        testHarness(
          const HaditsLastReadCard(),
        ),
      );

      expect(find.text('Terakhir Dibaca'), findsOneWidget);
      expect(find.text('Shahih Bukhari'), findsOneWidget);
      expect(find.text('Hadits No. 42 • Kitab Iman'), findsOneWidget);
      expect(find.text('Lanjutkan Baca'), findsOneWidget);
    });

    testWidgets(
        'HaditsFontSizeModal renders font size sliders and live preview',
        (tester) async {
      await tester.pumpWidget(
        testHarness(
          const SingleChildScrollView(child: HaditsFontSizeModal()),
        ),
      );

      expect(find.text('Pengaturan Teks Hadits'), findsOneWidget);
      expect(find.text('Ukuran Teks Arab'), findsOneWidget);
      expect(find.text('Ukuran Terjemahan'), findsOneWidget);
      expect(find.text('Pratinjau:'), findsOneWidget);
      expect(find.byType(Slider), findsNWidgets(2));
    });

    testWidgets('HaditsJumpSheet renders tabs and responds to input',
        (tester) async {
      int? jumpedNumber;

      await tester.pumpWidget(
        testHarness(
          Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => showHaditsJumpSheet(
                context: context,
                namaTabel: 'bukhari',
                longNama: 'Shahih Bukhari',
                totalHadits: 7008,
                listBooks: const [
                  ImamData(
                    imamId: 1,
                    imamSorting: 1,
                    longNama: 'Shahih Bukhari',
                    namaTabel: 'bukhari',
                    hadits: 7008,
                    babCount: 97,
                  ),
                ],
                onJump: (no) => jumpedNumber = no,
                onSelectKitab: (_) {},
              ),
              child: const Text('Open Jump Sheet'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Jump Sheet'));
      await tester.pumpAndSettle();

      expect(find.text('Shahih Bukhari'), findsOneWidget);
      expect(find.text('Lompat Hadits'), findsOneWidget);
      expect(find.text('Ganti Kitab'), findsOneWidget);
      expect(find.text('Buka Hadits'), findsOneWidget);

      // Enter hadits number 15
      await tester.enterText(find.byType(TextField), '15');
      await tester.tap(find.text('Buka Hadits'));
      await tester.pumpAndSettle();

      expect(jumpedNumber, equals(15));
    });

    testWidgets(
        'Hadits components scale safely at text scale 1.0, 1.3, 2.0 without overflow',
        (tester) async {
      for (final scale in [1.0, 1.3, 2.0]) {
        await tester.pumpWidget(
          testHarness(
            const SingleChildScrollView(
              child: Column(
                children: [
                  HaditsLastReadCard(),
                  SizedBox(height: 12),
                  HaditsFontSizeModal(),
                ],
              ),
            ),
            textScale: scale,
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      }
    });
  });
}
