import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masjid_app/components/worship/worship_counter_control.dart';
import 'package:masjid_app/components/worship/worship_progress_indicator.dart';
import 'package:masjid_app/core/theme/hudhud_theme.dart';

Widget testHarness(Widget child,
    {double textScale = 1.0, bool disableAnimations = false}) {
  return MaterialApp(
    theme: ThemeData(
      extensions: const [HudhudTheme.light],
    ),
    home: MediaQuery(
      data: MediaQueryData(
        textScaler: TextScaler.linear(textScale),
        disableAnimations: disableAnimations,
      ),
      child: Scaffold(body: Center(child: child)),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Dzikir Redesign - Focus Reader & Counter Controls', () {
    testWidgets(
        'WorshipCounterControl increments, shows Selesai at target, and resets',
        (tester) async {
      int currentCount = 0;
      const target = 3;

      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            return testHarness(
              WorshipCounterControl(
                count: currentCount,
                target: target,
                onTap: () {
                  setState(() {
                    if (currentCount >= target) {
                      currentCount = 0;
                    } else {
                      currentCount++;
                    }
                  });
                },
              ),
            );
          },
        ),
      );

      // Initial state: 0 / 3
      expect(find.textContaining('0'), findsOneWidget);
      expect(find.textContaining('/ 3'), findsOneWidget);
      expect(find.textContaining('Selesai'), findsNothing);

      // Tap 1 -> 1 / 3
      await tester.tap(find.byType(WorshipCounterControl));
      await tester.pumpAndSettle();
      expect(find.textContaining('1'), findsOneWidget);
      expect(find.textContaining('/ 3'), findsOneWidget);

      // Tap 2 -> 2 / 3
      await tester.tap(find.byType(WorshipCounterControl));
      await tester.pumpAndSettle();
      expect(find.textContaining('2'), findsOneWidget);
      expect(find.textContaining('/ 3'), findsOneWidget);

      // Tap 3 -> 3 / 3 (Target reached -> Selesai)
      await tester.tap(find.byType(WorshipCounterControl));
      await tester.pumpAndSettle();
      expect(find.textContaining('Selesai'), findsOneWidget);

      // Tap 4 (Reset) -> 0 / 3
      await tester.tap(find.byType(WorshipCounterControl));
      await tester.pumpAndSettle();
      expect(find.textContaining('0'), findsOneWidget);
      expect(find.textContaining('/ 3'), findsOneWidget);
      expect(find.textContaining('Selesai'), findsNothing);
    });

    testWidgets('WorshipCounterControl respects minimum 48dp touch target',
        (tester) async {
      await tester.pumpWidget(
        testHarness(
          WorshipCounterControl(
            count: 1,
            target: 33,
            onTap: () {},
          ),
        ),
      );

      final size = tester.getSize(find.byType(WorshipCounterControl));
      expect(size.height, greaterThanOrEqualTo(48.0));
      expect(size.width, greaterThanOrEqualTo(120.0));
    });

    testWidgets(
        'WorshipProgressIndicator displays correct step and progress fraction',
        (tester) async {
      await tester.pumpWidget(
        testHarness(
          const WorshipProgressIndicator(
            currentStep: 5,
            totalSteps: 20,
          ),
        ),
      );

      expect(find.text('Bacaan 5 dari 20'), findsOneWidget);
      final progressBar = tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );
      expect(progressBar.value, equals(5 / 20));
    });

    testWidgets(
        'WorshipProgressIndicator and Counter scale safely without overflow',
        (tester) async {
      for (final scale in [1.0, 1.3, 2.0]) {
        await tester.pumpWidget(
          testHarness(
            SingleChildScrollView(
              child: Column(
                children: [
                  const WorshipProgressIndicator(
                      currentStep: 12, totalSteps: 30),
                  const SizedBox(height: 20),
                  WorshipCounterControl(count: 10, target: 33, onTap: () {}),
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

    testWidgets('Reduced motion check with disableAnimations true',
        (tester) async {
      await tester.pumpWidget(
        testHarness(
          WorshipCounterControl(
            count: 1,
            target: 3,
            onTap: () {},
          ),
          disableAnimations: true,
        ),
      );

      final mediaQuery = tester.element(find.byType(WorshipCounterControl));
      expect(MediaQuery.of(mediaQuery).disableAnimations, isTrue);
    });
  });
}
