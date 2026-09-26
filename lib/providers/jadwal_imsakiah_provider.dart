import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:masjid_app/core/network/api_endpoints.dart';
import 'package:masjid_app/models/jadwal_imsakiah_item.dart';
import 'package:masjid_app/providers/api_providers.dart';
import 'package:masjid_app/providers/location_provider.dart';

/// State untuk bulan dan tahun yang sedang dipilih di jadwal imsakiah.
final selectedImsakiahDateProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});

/// Provider utama untuk mengambil jadwal imsakiah bulanan dari backend.
final jadwalImsakiahProvider = FutureProvider<List<JadwalImsakiahItem>>((ref) async {
  final apiClient = ref.watch(apiClientProvider);
  final coords = ref.watch(
    locationProvider.select((l) => (l.latitude, l.longitude)),
  );
  final selectedDate = ref.watch(selectedImsakiahDateProvider);
  final now = DateTime.now();

  final queryParams = <String, dynamic>{};
  if (coords.$1 != null && coords.$2 != null) {
    queryParams['latitude'] = coords.$1;
    queryParams['longitude'] = coords.$2;
  }
  // Bulan dalam 1-indexed (1: Januari - 12: Desember)
  queryParams['month'] = selectedDate.month;
  queryParams['year'] = selectedDate.year;

  final response = await apiClient.get<List<List<dynamic>>>(
    ApiEndpoints.waktuSolatKalender,
    queryParameters: queryParams.isEmpty ? null : queryParams,
    fromJson: (json) {
      if (json is! List) return <List<dynamic>>[];
      return json.whereType<List>().toList();
    },
  );

  final rawRows = response.data ?? <List<dynamic>>[];
  final isCurrentMonth = selectedDate.year == now.year && selectedDate.month == now.month;

  return rawRows.asMap().entries.map((entry) {
    final index = entry.key;
    final row = entry.value;
    // Tanggal pada row biasanya 1-indexed sesuai tanggal dalam bulan
    final dayNum = int.tryParse(row.isNotEmpty ? row[0].toString() : '') ?? (index + 1);
    final isToday = isCurrentMonth && dayNum == now.day;
    return JadwalImsakiahItem.fromList(row, isToday: isToday);
  }).toList();
});

/// Alias backward-compatibility untuk kalender dzulhijjah
@Deprecated('Gunakan jadwalImsakiahProvider')
final kalenderDzulhijjahProvider = FutureProvider<List<List<String>>>((ref) async {
  final items = await ref.watch(jadwalImsakiahProvider.future);
  return items.map((item) => [
    item.no.toString(),
    item.tanggal,
    item.hari,
    item.imsak,
    item.berbuka,
  ]).toList();
});
