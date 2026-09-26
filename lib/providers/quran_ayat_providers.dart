import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:masjid_app/core/network/api_endpoints.dart';
import 'package:masjid_app/core/storage/preferences_service.dart';
import 'package:masjid_app/providers/api_providers.dart';

/// Key storage lama (GetStorage) — nilainya JSON map, key-nya dipertahankan
/// supaya instalasi lama tetap terbaca.
const String perAyatLastReadKey = 'perAyatLastRead';

/// Daftar surah mentah (`GET /quran/surah?search=`) — bentuk asli seperti
/// `QuranService().getList()`: tiap item punya `id`, `nama`, `ayat`, `tipe`, `arab`.
/// Pembaca per-ayat memakai map mentah karena `SurahModel` tidak memuat `arab`
/// (dipakai di header "nama surah" aksara Arab).
final surahListRawProvider =
    FutureProvider.family<List<Map<String, dynamic>>, String>((ref, search) async {
  final apiClient = ref.watch(apiClientProvider);
  try {
    final response = await apiClient.get<List<Map<String, dynamic>>>(
      ApiEndpoints.quranSurah,
      queryParameters: search.isNotEmpty ? {'search': search} : null,
      fromJson: (json) {
        if (json is List) {
          return json.whereType<Map>().map((item) {
            final m = Map<String, dynamic>.from(item);
            final type = (m['tipe'] ?? m['type'] ?? '').toString();
            final arab = (m['arab'] ?? m['asma'] ?? '').toString();
            m['tipe'] = type;
            m['type'] = type;
            m['arab'] = arab;
            m['asma'] = arab;
            return m;
          }).toList();
        }
        return <Map<String, dynamic>>[];
      },
    );
    return response.data ?? <Map<String, dynamic>>[];
  } catch (e) {
    return <Map<String, dynamic>>[];
  }
});

/// Detail surah mentah (`GET /quran/surah/:id`) untuk halaman detail ayat yang
/// membaca field di luar `AyatModel`: `name.transliteration.id`, `verses[].text.arab`,
/// `text.transliteration.en`, `translation.id`, `audio.primary`, `numberOfVerses`.
final surahDetailRawProvider =
    FutureProvider.family<Map<String, dynamic>, String>((ref, id) async {
  final apiClient = ref.watch(apiClientProvider);
  try {
    final response = await apiClient.get<Map<String, dynamic>>(
      '${ApiEndpoints.quranDetail}/$id',
      fromJson: (json) =>
          json is Map ? Map<String, dynamic>.from(json) : <String, dynamic>{},
    );
    return response.data ?? <String, dynamic>{};
  } catch (e) {
    return <String, dynamic>{};
  }
});

/// Riwayat baca terakhir per-ayat — dulu `MainController.perAyatLastRead`
/// (`{id, suratName, ayatNumber, audio, audiosource}`).
class PerAyatLastReadNotifier extends StateNotifier<Map<String, dynamic>> {
  PerAyatLastReadNotifier() : super(_defaultValue) {
    _load();
  }

  static const Map<String, dynamic> _defaultValue = {
    'id': 0,
    'suratName': '',
    'ayatNumber': 0,
    'audio': 'ar.alafasy',
    'audiosource': 'server',
  };

  void _load() {
    final raw = PreferencesService.getString(perAyatLastReadKey);
    if (raw == null) return;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map) {
        state = Map<String, dynamic>.from(decoded);
      }
    } catch (_) {
      // data lama rusak — pakai nilai default
    }
  }

  Future<void> save(Map<String, dynamic> value) async {
    state = value;
    await PreferencesService.setString(perAyatLastReadKey, jsonEncode(value));
  }
}

final perAyatLastReadProvider =
    StateNotifierProvider<PerAyatLastReadNotifier, Map<String, dynamic>>(
  (ref) => PerAyatLastReadNotifier(),
);
