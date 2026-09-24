import 'dart:math' as math;

/// Koordinat Ka'bah.
const double kKaabaLatitude = 21.4224779;
const double kKaabaLongitude = 39.8251832;

/// Arah kiblat dari utara sejati, dalam derajat (0..360).
///
/// Rumus great-circle bearing: dari titik pengamat ke Ka'bah.
double qiblaBearing(double latitude, double longitude) {
  final lat = _radians(latitude);
  final kaabaLat = _radians(kKaabaLatitude);
  final deltaLng = _radians(kKaabaLongitude - longitude);

  final x = math.sin(deltaLng) * math.cos(kaabaLat);
  final y = math.cos(lat) * math.sin(kaabaLat) -
      math.sin(lat) * math.cos(kaabaLat) * math.cos(deltaLng);

  return _normalizeDegrees(_degrees(math.atan2(x, y)));
}

/// Jarak garis lurus ke Ka'bah dalam kilometer (haversine).
double distanceToKaaba(double latitude, double longitude) {
  const earthRadiusKm = 6371.0;
  final deltaLat = _radians(kKaabaLatitude - latitude);
  final deltaLng = _radians(kKaabaLongitude - longitude);

  final a = math.sin(deltaLat / 2) * math.sin(deltaLat / 2) +
      math.cos(_radians(latitude)) *
          math.cos(_radians(kKaabaLatitude)) *
          math.sin(deltaLng / 2) *
          math.sin(deltaLng / 2);

  return 2 * earthRadiusKm * math.asin(math.min(1, math.sqrt(a)));
}

/// Selisih sudut terpendek dari [from] ke [to], di rentang -180..180.
///
/// Dipakai supaya jarum berputar lewat jalur terdekat: dari 359° ke 1° cukup
/// 2°, bukan 358° ke arah sebaliknya.
double shortestAngleDelta(double from, double to) =>
    ((to - from + 540) % 360) - 180;

double _normalizeDegrees(double degrees) => (degrees % 360 + 360) % 360;

double _radians(double degrees) => degrees * math.pi / 180;

double _degrees(double radians) => radians * 180 / math.pi;
