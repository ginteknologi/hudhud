import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:masjid_app/core/network/api_endpoints.dart';
import 'package:masjid_app/models/jadwal_shalat_model.dart';
import 'package:masjid_app/providers/api_providers.dart';
import 'package:masjid_app/providers/location_provider.dart';

final jadwalShalatProvider = FutureProvider<JadwalShalatModel>((ref) async {
  final apiClient = ref.watch(apiClientProvider);

  // Server memakai koordinat masjid kalau parameter ini kosong. Hanya koordinat
  // yang di-watch — perubahan nama/loading tidak perlu request ulang.
  final coords = ref.watch(
    locationProvider.select((l) => (l.latitude, l.longitude)),
  );

  try {
    final response = await apiClient.get<JadwalShalatModel>(
      ApiEndpoints.waktuSolat,
      queryParameters: coords.$1 == null || coords.$2 == null
          ? null
          : {'latitude': coords.$1, 'longitude': coords.$2},
      fromJson: (json) =>
          JadwalShalatModel.fromJson(json as Map<String, dynamic>),
    );
    return response.data ?? JadwalShalatModel.fromJson({});
  } catch (e) {
    // Return clean fallback without logging out the user
    return JadwalShalatModel.fromJson({});
  }
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

  final jadwal = jadwalAsync.valueOrNull;
  if (jadwal == null) {
    yield null;
    return;
  }

  final items = jadwal.toItems();

  while (true) {
    final now = DateTime.now();
    ShalatTimeItem? targetItem;
    DateTime? targetDateTime;

    for (final item in items) {
      final parts = item.waktu.split(':');
      if (parts.length != 2) continue;
      final hour = int.tryParse(parts[0]) ?? 0;
      final minute = int.tryParse(parts[1]) ?? 0;

      final prayerTimeToday =
          DateTime(now.year, now.month, now.day, hour, minute);
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
      targetDateTime = DateTime(now.year, now.month, now.day + 1, hour, minute);
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
