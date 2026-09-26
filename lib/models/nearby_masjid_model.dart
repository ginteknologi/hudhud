class NearbyMasjid {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final double distanceInMeters;
  final String? address;

  const NearbyMasjid({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.distanceInMeters,
    this.address,
  });

  String get formattedDistance {
    if (distanceInMeters < 1000) {
      return '${distanceInMeters.round()} m';
    }
    return '${(distanceInMeters / 1000).toStringAsFixed(1)} km';
  }
}
