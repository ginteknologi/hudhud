import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:masjid_app/models/nearby_masjid_model.dart';

class NearbyMasjidService {
  final Dio _dio;

  NearbyMasjidService({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                headers: {
                  'User-Agent': 'HudhudApp/1.0 (contact@hudhud.app)',
                },
                connectTimeout: const Duration(seconds: 12),
                receiveTimeout: const Duration(seconds: 15),
              ),
            );

  /// Mengambil data masjid di sekitar koordinat menggunakan Overpass API (OpenStreetMap)
  /// 100% Free Version tanpa perlu API Key.
  Future<List<NearbyMasjid>> fetchNearbyMasjids({
    required double latitude,
    required double longitude,
    int radiusInMeters = 3000,
  }) async {
    final query =
        '[out:json][timeout:15];(node["amenity"="place_of_worship"]["religion"="muslim"](around:$radiusInMeters,$latitude,$longitude);way["amenity"="place_of_worship"]["religion"="muslim"](around:$radiusInMeters,$latitude,$longitude););out center;';

    // Daftar server cermin (mirrors) publik Overpass OSM
    final endpoints = [
      'https://overpass-api.de/api/interpreter',
      'https://lz4.overpass-api.de/api/interpreter',
      'https://z.overpass-api.de/api/interpreter',
    ];

    dynamic data;
    dynamic lastError;

    // 1. Coba request via GET query param (paling stabil & didukung semua HTTP firewall)
    for (final baseUrl in endpoints) {
      try {
        final response = await _dio.get(
          baseUrl,
          queryParameters: {'data': query},
        );
        if (response.statusCode == 200 && response.data != null) {
          data = response.data;
          break;
        }
      } catch (e) {
        lastError = e;
      }
    }

    // 2. Jika GET gagal, coba POST form-urlencoded dengan payload 'data=...'
    if (data == null) {
      for (final baseUrl in endpoints) {
        try {
          final response = await _dio.post(
            baseUrl,
            data: {'data': query},
            options: Options(
              contentType: Headers.formUrlEncodedContentType,
            ),
          );
          if (response.statusCode == 200 && response.data != null) {
            data = response.data;
            break;
          }
        } catch (e) {
          lastError = e;
        }
      }
    }

    if (data == null) {
      throw Exception(
        lastError?.toString() ?? 'Gagal mengambil data masjid dari server.',
      );
    }

    final elements = data['elements'] as List<dynamic>? ?? [];
    final List<NearbyMasjid> masjids = [];

    for (final element in elements) {
      final tags = element['tags'] as Map<String, dynamic>? ?? {};
      String? rawName = tags['name'] as String?;
      if (rawName == null || rawName.trim().isEmpty) {
        rawName = (tags['name:id'] ?? tags['description'])?.toString();
      }
      final String name = (rawName != null && rawName.trim().isNotEmpty)
          ? rawName.trim()
          : 'Masjid / Mushola';

      double? lat;
      double? lon;

      if (element['type'] == 'node') {
        lat = (element['lat'] as num?)?.toDouble();
        lon = (element['lon'] as num?)?.toDouble();
      } else if (element['type'] == 'way' && element['center'] != null) {
        lat = (element['center']['lat'] as num?)?.toDouble();
        lon = (element['center']['lon'] as num?)?.toDouble();
      }

      if (lat != null && lon != null) {
        final distance = Geolocator.distanceBetween(
          latitude,
          longitude,
          lat,
          lon,
        );

        String? street = tags['addr:street'];
        String? city = tags['addr:city'] ?? tags['addr:suburb'];
        String? address;
        if (street != null && city != null) {
          address = '$street, $city';
        } else {
          address = street ?? city;
        }

        masjids.add(
          NearbyMasjid(
            id: element['id'].toString(),
            name: name,
            latitude: lat,
            longitude: lon,
            distanceInMeters: distance,
            address: address,
          ),
        );
      }
    }

    // Urutkan dari yang paling dekat
    masjids.sort((a, b) => a.distanceInMeters.compareTo(b.distanceInMeters));

    return masjids;
  }
}
