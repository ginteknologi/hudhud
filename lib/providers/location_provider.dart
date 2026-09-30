import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:masjid_app/core/storage/preferences_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

/// Default lokasi saat user belum mengaktifkan GPS.
const String kDefaultLocationName = 'Jakarta';
const double kDefaultLatitude = -6.2088;
const double kDefaultLongitude = 106.8456;
const String kDefaultTimeZoneId = 'Asia/Jakarta';
const _locationChannel = MethodChannel('hudhud/location');

class SavedLocation {
  const SavedLocation({
    this.name = kDefaultLocationName,
    this.latitude,
    this.longitude,
    this.loading = false,
    this.timeZoneId,
    this.isDeviceLocation = false,
  });

  final String name;
  final double? latitude;
  final double? longitude;
  final bool loading;
  final String? timeZoneId;
  final bool isDeviceLocation;

  bool get hasCoordinates => latitude != null && longitude != null;

  @Deprecated('Use hasCoordinates or isDeviceLocation')
  bool get isGps => hasCoordinates;

  SavedLocation copyWith({bool? loading, String? timeZoneId}) => SavedLocation(
        name: name,
        latitude: latitude,
        longitude: longitude,
        loading: loading ?? this.loading,
        timeZoneId: timeZoneId ?? this.timeZoneId,
        isDeviceLocation: isDeviceLocation,
      );
}

/// Nama pendek dari hasil reverse-geocode, mis. "Cibubur, Kota Jakarta Timur".
/// Kalau geocoder tidak mengembalikan apa pun (butuh jaringan), pakai koordinat.
String placeNameOrCoords(List<Placemark> placemarks, double lat, double lng) {
  if (placemarks.isNotEmpty) {
    final place = placemarks.first;
    final parts = [place.subLocality, place.locality]
        .whereType<String>()
        .map((part) => part.trim())
        .where((part) => part.isNotEmpty)
        .toSet()
        .take(2)
        .toList();
    if (parts.isNotEmpty) return parts.join(', ');
  }
  return '${lat.toStringAsFixed(3)}, ${lng.toStringAsFixed(3)}';
}

class LocationNotifier extends StateNotifier<SavedLocation> {
  LocationNotifier() : super(const SavedLocation()) {
    _restore();
    unawaited(_refreshDeviceTimeZone());
  }

  static const String _keyName = 'location_name';
  static const String _keyLat = 'location_lat';
  static const String _keyLng = 'location_lng';
  static const String _keyTimeZone = 'location_timezone';
  static const String _keySourceDevice = 'location_source_device';

  void _restore() {
    final lat = PreferencesService.getDouble(_keyLat);
    final lng = PreferencesService.getDouble(_keyLng);
    if (lat == null || lng == null) return;
    state = SavedLocation(
      name: PreferencesService.getString(_keyName) ?? kDefaultLocationName,
      latitude: lat,
      longitude: lng,
      timeZoneId: PreferencesService.getString(_keyTimeZone),
      // Existing saved coordinates came from GPS before manual locations existed.
      isDeviceLocation: PreferencesService.getBool(_keySourceDevice) ?? true,
    );
  }

  /// Ambil posisi sekarang lewat GPS. Mengembalikan pesan error untuk
  /// ditampilkan ke user, atau `null` kalau berhasil.
  Future<String?> detect() async {
    if (state.loading) return null;
    state = state.copyWith(loading: true);
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        return 'GPS mati — nyalakan lokasi di HP dulu';
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever) {
        // Dialog izin tidak bisa muncul lagi, jadi user langsung diarahkan ke
        // layar pengaturan aplikasi.
        await openAppSettings();
        return 'Izin lokasi diblokir — aktifkan lewat pengaturan sistem';
      }
      if (permission == LocationPermission.denied) {
        return 'Izin lokasi dibutuhkan untuk menyesuaikan waktu sholat';
      }

      final position = await _resolvePosition();
      if (position == null) {
        return 'Tidak dapat sinyal GPS — di emulator, set lokasi lewat '
            'Extended Controls; di HP, coba di tempat terbuka';
      }

      final name = placeNameOrCoords(
        await _reverseGeocode(position.latitude, position.longitude),
        position.latitude,
        position.longitude,
      );
      await _save(
        name,
        position.latitude,
        position.longitude,
        timeZoneId: await _deviceTimeZone(),
        isDeviceLocation: true,
      );
      return null;
    } catch (e) {
      if (kDebugMode) debugPrint('Gagal ambil lokasi: $e');
      return 'Gagal mengambil lokasi';
    } finally {
      if (mounted) state = state.copyWith(loading: false);
    }
  }

  Future<void> setManualLocation({
    required String name,
    required double latitude,
    required double longitude,
    required String timeZoneId,
  }) async {
    tzdata.initializeTimeZones();
    try {
      tz.getLocation(timeZoneId);
    } on tz.LocationNotFoundException {
      throw ArgumentError.value(timeZoneId, 'timeZoneId', 'Unknown IANA zone');
    }
    if (name.trim().isEmpty ||
        !latitude.isFinite ||
        latitude < -90 ||
        latitude > 90 ||
        !longitude.isFinite ||
        longitude < -180 ||
        longitude > 180) {
      throw ArgumentError('Invalid location');
    }
    await _save(
      name.trim(),
      latitude,
      longitude,
      timeZoneId: timeZoneId,
      isDeviceLocation: false,
    );
  }

  /// Balik ke lokasi default.
  Future<void> reset() async {
    state = const SavedLocation();
    await PreferencesService.remove(_keyName);
    await PreferencesService.remove(_keyLat);
    await PreferencesService.remove(_keyLng);
    await PreferencesService.remove(_keyTimeZone);
    await PreferencesService.remove(_keySourceDevice);
  }

  /// Posisi sekarang; kalau tidak ada fix dalam batas waktu (sering terjadi di
  /// emulator atau dalam ruangan), pakai posisi terakhir yang diketahui.
  Future<Position?> _resolvePosition() async {
    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 15),
        ),
      );
    } on TimeoutException {
      final last = await Geolocator.getLastKnownPosition();
      if (last != null && kDebugMode) {
        debugPrint(
            'Pakai posisi terakhir: ${last.latitude}, ${last.longitude}');
      }
      return last;
    }
  }

  Future<void> _refreshDeviceTimeZone() async {
    if (!state.isDeviceLocation) return;
    final zone = await _deviceTimeZone();
    if (zone == state.timeZoneId) return;
    state = SavedLocation(
      name: state.name,
      latitude: state.latitude,
      longitude: state.longitude,
      loading: state.loading,
      timeZoneId: zone,
      isDeviceLocation: true,
    );
    await PreferencesService.setString(_keyTimeZone, zone);
  }

  Future<String> _deviceTimeZone() async {
    try {
      final zone = await _locationChannel.invokeMethod<String>('getTimeZoneId');
      if (zone != null && zone.isNotEmpty && zone != 'GMT') {
        tzdata.initializeTimeZones();
        try {
          tz.getLocation(zone);
          return zone;
        } on tz.LocationNotFoundException {
          if (kDebugMode) debugPrint('Zona waktu perangkat tidak dikenal: $zone');
        }
      }
    } on MissingPluginException {
      // Use Jakarta as fallback until native zone lookup is available.
    } on PlatformException catch (e) {
      if (kDebugMode) debugPrint('Gagal membaca zona waktu: ${e.code}');
    }
    return kDefaultTimeZoneId;
  }

  Future<List<Placemark>> _reverseGeocode(double lat, double lng) async {
    try {
      return await Geocoding().placemarkFromCoordinates(lat, lng);
    } catch (e) {
      if (kDebugMode) debugPrint('Reverse geocode gagal: $e');
      return const [];
    }
  }

  Future<void> _save(
    String name,
    double lat,
    double lng, {
    required String timeZoneId,
    required bool isDeviceLocation,
  }) async {
    state = SavedLocation(
      name: name,
      latitude: lat,
      longitude: lng,
      loading: state.loading,
      timeZoneId: timeZoneId,
      isDeviceLocation: isDeviceLocation,
    );
    await PreferencesService.setString(_keyName, name);
    await PreferencesService.setDouble(_keyLat, lat);
    await PreferencesService.setDouble(_keyLng, lng);
    await PreferencesService.setString(_keyTimeZone, timeZoneId);
    await PreferencesService.setBool(_keySourceDevice, isDeviceLocation);
  }

}

final locationProvider = StateNotifierProvider<LocationNotifier, SavedLocation>(
  (ref) => LocationNotifier(),
);
