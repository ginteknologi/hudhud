import 'dart:async';

import 'package:adhan/adhan.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:masjid_app/models/jadwal_shalat_model.dart';
import 'package:masjid_app/providers/location_provider.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

const double _fallbackLatitude = -6.2088;
const double _fallbackLongitude = 106.8456;

JadwalShalatModel calculatePrayerTimes({
  required double latitude,
  required double longitude,
  required DateTime date,
  String timeZoneId = 'Asia/Jakarta',
}) {
  if (!latitude.isFinite ||
      !longitude.isFinite ||
      latitude < -90 ||
      latitude > 90 ||
      longitude < -180 ||
      longitude > 180) {
    throw ArgumentError('Invalid coordinates');
  }

  final coordinates = Coordinates(latitude, longitude, validate: true);
  final parameters = CalculationMethod.singapore.getParameters()
    ..madhab = Madhab.shafi;
  tzdata.initializeTimeZones();
  final zone = tz.getLocation(timeZoneId);
  final localDate = tz.TZDateTime.from(date, zone);
  final prayerTimes = PrayerTimes.utcOffset(
    coordinates,
    DateComponents(localDate.year, localDate.month, localDate.day),
    parameters,
    localDate.timeZoneOffset,
  );
  String formatTime(DateTime time) =>
      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

  return JadwalShalatModel(
    imsak: formatTime(prayerTimes.fajr.subtract(const Duration(minutes: 10))),
    subuh: formatTime(prayerTimes.fajr),
    terbit: formatTime(prayerTimes.sunrise),
    dzuhur: formatTime(prayerTimes.dhuhr),
    ashar: formatTime(prayerTimes.asr),
    maghrib: formatTime(prayerTimes.maghrib),
    isya: formatTime(prayerTimes.isha),
    tanggal:
        '${localDate.year.toString().padLeft(4, '0')}-${localDate.month.toString().padLeft(2, '0')}-${localDate.day.toString().padLeft(2, '0')}',
  );
}

final jadwalShalatProvider = FutureProvider<JadwalShalatModel>((ref) async {
  final location = ref.watch(locationProvider);
  final timeZoneId = location.timeZoneId ?? kDefaultTimeZoneId;
  tzdata.initializeTimeZones();
  final zone = tz.getLocation(timeZoneId);
  final now = tz.TZDateTime.now(zone);
  return calculatePrayerTimes(
    latitude: location.latitude ?? _fallbackLatitude,
    longitude: location.longitude ?? _fallbackLongitude,
    date: now,
    timeZoneId: timeZoneId,
  );
});

class NextShalatInfo {
  final ShalatTimeItem nextShalat;
  final Duration timeRemaining;
  final String formattedRemaining;
  final List<ShalatTimeItem> items;

  NextShalatInfo({
    required this.nextShalat,
    required this.timeRemaining,
    required this.formattedRemaining,
    required this.items,
  });
}

// Countdown timer provider that emits every second with autoDispose
final prayerCountdownProvider =
    StreamProvider.autoDispose<NextShalatInfo?>((ref) async* {
  final jadwalAsync = ref.watch(jadwalShalatProvider);
  final location = ref.watch(locationProvider);
  final jadwal = jadwalAsync.valueOrNull;
  if (jadwal == null) {
    yield null;
    return;
  }

  final items = jadwal.toItems();
  final scheduleDate = jadwal.tanggal;

  while (true) {
    final currentDate = tz.TZDateTime.now(tz.getLocation(
      location.timeZoneId ?? kDefaultTimeZoneId,
    ));
    final currentDateKey =
        '${currentDate.year.toString().padLeft(4, '0')}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.day.toString().padLeft(2, '0')}';
    if (currentDateKey != scheduleDate) {
      ref.invalidate(jadwalShalatProvider);
      return;
    }
    tzdata.initializeTimeZones();
    final zone = tz.getLocation(
      location.timeZoneId ?? 'Asia/Jakarta',
    );
    final now = tz.TZDateTime.now(zone);
    ShalatTimeItem? targetItem;
    DateTime? targetDateTime;

    for (final item in items) {
      final parts = item.waktu.split(':');
      if (parts.length != 2) continue;
      final hour = int.tryParse(parts[0]) ?? 0;
      final minute = int.tryParse(parts[1]) ?? 0;

      final prayerTimeToday =
          tz.TZDateTime(zone, now.year, now.month, now.day, hour, minute);
      if (prayerTimeToday.isAfter(now)) {
        targetItem = item;
        targetDateTime = prayerTimeToday;
        break;
      }
    }

    // If all prayers today have passed, next prayer is Subuh tomorrow
    if (targetItem == null && items.isNotEmpty) {
      targetItem = items.first;
      final parts = targetItem.waktu.split(':');
      final hour = int.tryParse(parts[0]) ?? 4;
      final minute = int.tryParse(parts[1]) ?? 30;
      targetDateTime =
          tz.TZDateTime(zone, now.year, now.month, now.day + 1, hour, minute);
    }

    if (targetItem != null && targetDateTime != null) {
      final diff = targetDateTime.difference(now);
      final hours = diff.inHours;
      final minutes = diff.inMinutes % 60;
      final seconds = diff.inSeconds % 60;

      final formatted = hours > 0
          ? '$hours jam $minutes menit'
          : '$minutes menit $seconds detik';

      final updatedItems = items.map((i) {
        return i.copyWith(isActive: i.id == targetItem!.id);
      }).toList();

      yield NextShalatInfo(
        nextShalat: targetItem,
        timeRemaining: diff,
        formattedRemaining: formatted,
        items: updatedItems,
      );
    }

    await Future.delayed(const Duration(seconds: 1));
  }
});
