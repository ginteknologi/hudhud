import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:masjid_app/core/network/api_endpoints.dart';
import 'package:masjid_app/models/lokasi_saya_data.dart';
import 'package:masjid_app/providers/api_providers.dart';
import 'package:masjid_app/storage/lokasi_saya_storage.dart';

// Baris tabel kalender dari /waktusolat/kalender.
// Response: { "code": ..., "data": [ [no, tanggal, hari, imsak, berbuka], ... ] }
final kalenderDzulhijjahProvider = FutureProvider<List<List<String>>>((ref) async {
  final apiClient = ref.watch(apiClientProvider);
  final response = await apiClient.get<List<List<String>>>(
    ApiEndpoints.waktuSolatKalender,
    fromJson: (json) {
      if (json is! List) return <List<String>>[];
      return json
          .whereType<List>()
          .map((row) => row.map((v) => v.toString()).toList())
          .toList();
    },
  );
  return response.data ?? <List<String>>[];
});

// Lokasi tersimpan (dulu MainController.mylokasi).
final lokasiSayaProvider = Provider<LokasiSayaData>((ref) {
  return LokasiStorage().getLokasi();
});
