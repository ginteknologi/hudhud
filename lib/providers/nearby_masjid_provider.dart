import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:masjid_app/models/nearby_masjid_model.dart';
import 'package:masjid_app/providers/location_provider.dart';
import 'package:masjid_app/services/nearby_masjid_service.dart';

final nearbyMasjidServiceProvider = Provider<NearbyMasjidService>((ref) {
  return NearbyMasjidService();
});

final searchRadiusProvider = StateProvider<int>((ref) => 3000); // Default 3 km

final nearbyMasjidsProvider = FutureProvider<List<NearbyMasjid>>((ref) async {
  final location = ref.watch(locationProvider);
  final radius = ref.watch(searchRadiusProvider);
  final service = ref.watch(nearbyMasjidServiceProvider);

  // Jika belum ada koordinat GPS, gunakan default Jakarta
  final lat = location.latitude ?? -6.2088;
  final lng = location.longitude ?? 106.8456;

  return await service.fetchNearbyMasjids(
    latitude: lat,
    longitude: lng,
    radiusInMeters: radius,
  );
});
