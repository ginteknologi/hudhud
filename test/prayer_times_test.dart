import 'package:flutter_test/flutter_test.dart';
import 'package:masjid_app/providers/jadwal_shalat_provider.dart';
import 'package:masjid_app/providers/location_provider.dart';

void main() {
  test('calculates ordered and plausible Jakarta prayer times', () {
    final schedule = calculatePrayerTimes(
      latitude: -6.2088,
      longitude: 106.8456,
      date: DateTime(2026, 9, 28),
    );

    final minutes = [
      schedule.imsak,
      schedule.subuh,
      schedule.terbit,
      schedule.dzuhur,
      schedule.ashar,
      schedule.maghrib,
      schedule.isya,
    ].map((time) {
      final parts = time.split(':').map(int.parse).toList();
      return parts[0] * 60 + parts[1];
    }).toList();

    for (var i = 1; i < minutes.length; i++) {
      expect(minutes[i], greaterThan(minutes[i - 1]));
    }
    expect(minutes[4], inInclusiveRange(12 * 60, 18 * 60));
    expect(minutes[5], inInclusiveRange(17 * 60, 19 * 60));
    expect(minutes[6], inInclusiveRange(18 * 60, 22 * 60));
    expect(minutes[1] - minutes[0], 10);
    expect(schedule.tanggal, '2026-09-28');
  });

  test('uses the selected timezone for WIB, WITA, and WIT locations', () {
    final locations = [
      (-6.2088, 106.8456, 'Asia/Jakarta'),
      (-5.1477, 119.4327, 'Asia/Makassar'),
      (-2.5916, 140.6690, 'Asia/Jayapura'),
    ];

    for (final (latitude, longitude, zone) in locations) {
      final schedule = calculatePrayerTimes(
        latitude: latitude,
        longitude: longitude,
        date: DateTime.utc(2026, 9, 27, 17),
        timeZoneId: zone,
      );
      expect(schedule.tanggal, '2026-09-28');
      expect(schedule.ashar, isNot('20:55'));
      expect(schedule.ashar.compareTo(schedule.maghrib), lessThan(0));
    }
  });

  test('default location includes Jakarta calculation coordinates', () {
    const location = SavedLocation();
    expect(location.latitude, isNull);
    expect(location.longitude, isNull);
    final schedule = calculatePrayerTimes(
      latitude: location.latitude ?? -6.2088,
      longitude: location.longitude ?? 106.8456,
      date: DateTime(2026, 9, 28),
    );
    expect(schedule.subuh, isNotEmpty);
  });

  test('rejects invalid coordinates', () {
    expect(
      () => calculatePrayerTimes(
        latitude: 91,
        longitude: 106,
        date: DateTime(2026, 9, 28),
      ),
      throwsArgumentError,
    );
  });
}
