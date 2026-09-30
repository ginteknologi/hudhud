import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masjid_app/components/hudhud_ui.dart';
import 'package:masjid_app/core/theme/hudhud_theme.dart';

void main() {
  test('design tokens keep cards within the 8dp radius contract', () {
    expect(HudhudTheme.light.radiusMd, 8);
    expect(HudhudTheme.light.controlHeight, greaterThanOrEqualTo(48));
    expect(HudhudTheme.light.motionFast.inMilliseconds,
        inInclusiveRange(180, 240));
    expect(HudhudTheme.light.motionNormal.inMilliseconds,
        inInclusiveRange(180, 240));
  });

  testWidgets('action row exposes a comfortable touch target', (tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: ThemeData(extensions: const [HudhudTheme.light]),
      home: const Scaffold(
          body: HudhudActionRow(icon: Icons.book, title: 'Baca')),
    ));
    expect(tester.getSize(find.byType(HudhudActionRow)).height,
        greaterThanOrEqualTo(56));
  });
}
