import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:masjid_app/core/network/api_endpoints.dart';
import 'package:masjid_app/models/quran_models.dart';
import 'package:masjid_app/providers/api_providers.dart';

/// Daftar halaman mushaf dari aset JSON lokal.
/// Key = path aset: `assets/img/quran/quran-page.json` (Indonesia),
/// `quran-page-madinah.json`, `quran-page-tajwid.json`.
/// Pengganti `HalamanQuranController.getQuran()` (`rootBundle.loadString` +
/// `json.decode`) — bentuk map dipertahankan apa adanya: id, surat, hal, file.
final quranPageListProvider =
    FutureProvider.family<List<Map<String, dynamic>>, String>(
        (ref, assetPath) async {
  try {
    final raw = await rootBundle.loadString(assetPath);
    final decoded = jsonDecode(raw);
    if (decoded is! List) return const [];
    return decoded.whereType<Map<String, dynamic>>().toList();
  } catch (_) {
    return const [];
  }
});

/// Hasil pencarian surah untuk modal "Cari".
/// Pengganti `QuranService().getList(search)` → `GET /quran/surah?search=`,
/// yang dulu dipakai controller sebagai `result['data']`.
final quranSurahSearchProvider =
    FutureProvider.family<List<dynamic>, String>((ref, search) async {
  final client = ref.watch(apiClientProvider);
  try {
    final response = await client.get<List<dynamic>>(
      ApiEndpoints.quranSurah,
      queryParameters: {'search': search},
      fromJson: (json) => json is List ? json : const <dynamic>[],
    );
    return response.data ?? const <dynamic>[];
  } catch (_) {
    return const <dynamic>[];
  }
});

/// Data juz dari `GET /quran/juz/{id}` — dipakai "Buka Juz" untuk mencari
/// nomor halaman (`hal`). Pengganti `QuranService().getNumber(numbertogo)`.
final quranJuzPageProvider =
    FutureProvider.family<QuranPageItem?, String>((ref, id) async {
  final client = ref.watch(apiClientProvider);
  try {
    final response = await client.get<QuranPageItem?>(
      '${ApiEndpoints.quranJuz}/$id',
      fromJson: (json) =>
          json is Map<String, dynamic> ? QuranPageItem.fromJson(json) : null,
    );
    return response.data;
  } catch (_) {
    return null;
  }
});
