import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:masjid_app/core/storage/preferences_service.dart';
import 'package:permission_handler/permission_handler.dart';

/// Dipakai kalau user belum pernah mengambil lokasi GPS — server menghitung
/// jadwal sholat memakai koordinat masjid.
const String kDefaultLocationName = 'Masjid An-Ni’mah Cibubur';

class SavedLocation {
  const SavedLocation({
    this.name = kDefaultLocationName,
    this.latitude,
    this.longitude,
    this.loading = false,
  });

  final String name;
  final double? latitude;
  final double? longitude;
  final bool loading;

  /// True kalau koordinat berasal dari GPS, bukan default masjid.
  bool get isGps => latitude != null && longitude != null;

  SavedLocation copyWith({bool? loading}) => SavedLocation(
        name: name,
        latitude: latitude,
        longitude: longitude,
        loading: loading ?? this.loading,
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
  }

  static const String _keyName = 'location_name';
  static const String _keyLat = 'location_lat';
  static const String _keyLng = 'location_lng';

  void _restore() {
    final lat = PreferencesService.getDouble(_keyLat);
    final lng = PreferencesService.getDouble(_keyLng);
    if (lat == null || lng == null) return;
    state = SavedLocation(
      name: PreferencesService.getString(_keyName) ?? kDefaultLocationName,
      latitude: lat,
      longitude: lng,
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
      await _save(name, position.latitude, position.longitude);
      return null;
    } catch (e) {
      if (kDebugMode) debugPrint('Gagal ambil lokasi: $e');
      return 'Gagal mengambil lokasi';
    } finally {
      if (mounted) state = state.copyWith(loading: false);
    }
  }

  /// Balik ke jadwal sholat dengan koordinat masjid.
  Future<void> reset() async {
    state = const SavedLocation();
    await PreferencesService.remove(_keyName);
    await PreferencesService.remove(_keyLat);
    await PreferencesService.remove(_keyLng);
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

  Future<List<Placemark>> _reverseGeocode(double lat, double lng) async {
    try {
      return await Geocoding().placemarkFromCoordinates(lat, lng);
    } catch (e) {
      if (kDebugMode) debugPrint('Reverse geocode gagal: $e');
      return const [];
    }
  }

  Future<void> _save(String name, double lat, double lng) async {
    state = SavedLocation(
      name: name,
      latitude: lat,
      longitude: lng,
      loading: state.loading,
    );
    await PreferencesService.setString(_keyName, name);
    await PreferencesService.setDouble(_keyLat, lat);
    await PreferencesService.setDouble(_keyLng, lng);
  }
}

final locationProvider = StateNotifierProvider<LocationNotifier, SavedLocation>(
  (ref) => LocationNotifier(),
);
