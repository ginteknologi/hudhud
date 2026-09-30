import 'package:flutter_test/flutter_test.dart';
import 'package:masjid_app/core/companion/hudhud_day_period.dart';
import 'package:masjid_app/models/jadwal_shalat_model.dart';

void main() {
  final schedule = JadwalShalatModel(
    imsak: '04:20',
    subuh: '04:30',
    terbit: '05:45',
    dzuhur: '12:00',
    ashar: '15:15',
    maghrib: '18:00',
    isya: '19:15',
  );

  HudhudDayPeriod at(int hour, int minute, [JadwalShalatModel? value]) =>
      resolveHudhudCompanion(
              DateTime(2026, 9, 27, hour, minute), value ?? schedule)
          .period;

  test('uses morning at the Subuh boundary', () {
    expect(at(4, 30), HudhudDayPeriod.morning);
  });

  test('uses midday at the Dzuhur boundary', () {
    expect(at(12, 0), HudhudDayPeriod.midday);
  });

  test('uses dusk at the Ashar boundary', () {
    expect(at(15, 15), HudhudDayPeriod.dusk);
  });

  test('keeps dusk at the Maghrib boundary', () {
    expect(at(18, 0), HudhudDayPeriod.dusk);
  });

  test('uses night at and after the Isya boundary', () {
    expect(at(19, 15), HudhudDayPeriod.night);
    expect(at(23, 30), HudhudDayPeriod.night);
  });

  test('uses safe defaults when schedule is unavailable', () {
    final state = resolveHudhudCompanion(DateTime(2026, 9, 27, 10), null);
    expect(state.period, HudhudDayPeriod.morning);
    expect(state.assetPath, contains('morning'));
  });
}
