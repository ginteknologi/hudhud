import 'package:flutter_test/flutter_test.dart';
import 'package:masjid_app/pages/kiblat/kiblat_math.dart';

void main() {
  // Sudut pembanding diambil dari arah kiblat yang sudah dipublikasikan.
  test('arah kiblat sesuai acuan', () {
    expect(qiblaBearing(-6.2, 106.816), closeTo(295.2, 0.3)); // Jakarta
    expect(qiblaBearing(51.5074, -0.1278), closeTo(119.0, 0.3)); // London
    expect(qiblaBearing(40.7128, -74.006), closeTo(58.5, 0.3)); // New York
  });

  test('selalu dalam rentang 0..360', () {
    for (final lat in [-90.0, -45.0, 0.0, 21.4, 45.0, 89.0]) {
      for (final lng in [-180.0, -90.0, 0.0, 39.8, 106.8, 180.0]) {
        final bearing = qiblaBearing(lat, lng);
        expect(bearing, greaterThanOrEqualTo(0), reason: '$lat,$lng');
        expect(bearing, lessThan(360), reason: '$lat,$lng');
      }
    }
  });

  test('jarak ke Ka\'bah', () {
    expect(distanceToKaaba(-6.2, 106.816), closeTo(7917, 15)); // Jakarta
    expect(distanceToKaaba(51.5074, -0.1278), closeTo(4794, 15)); // London
    expect(kKaabaLatitude, closeTo(21.4225, 0.001));
  });

  test('selisih sudut ambil jalur terpendek', () {
    expect(shortestAngleDelta(359, 1), closeTo(2, 0.001));
    expect(shortestAngleDelta(1, 359), closeTo(-2, 0.001));
    expect(shortestAngleDelta(10, 350), closeTo(-20, 0.001));
    expect(shortestAngleDelta(100, 100), closeTo(0, 0.001));
    expect(shortestAngleDelta(0, 180).abs(), closeTo(180, 0.001));
  });
}
