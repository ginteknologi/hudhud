import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:masjid_app/core/network/api_endpoints.dart';
import 'package:masjid_app/models/hadist_data.dart';
import 'package:masjid_app/providers/api_providers.dart';
import 'package:masjid_app/storage/hadits_bookmark_storage.dart';

// ============================================================
// v3 Providers — Kitab → Bab → Hadits, plus tema & pencarian
// ============================================================

/// GET /hadits — daftar imam/perawi + babCount
final haditsBooksProvider = FutureProvider<List<ImamData>>((ref) async {
  final apiClient = ref.watch(apiClientProvider);
  try {
    final response = await apiClient.get<List<dynamic>>(
      ApiEndpoints.hadits,
      fromJson: (json) => json is List ? json : <dynamic>[],
    );
    return (response.data ?? [])
        .map((e) => ImamData.fromMap(Map<String, dynamic>.from(e as Map)))
        .toList();
  } catch (e) {
    return [];
  }
});

/// Params untuk daftar hadits satu kitab.
///
/// `mulai`/`akhir` = jendela NoHdt. Dipakai bareng oleh scope bab, lompat
/// nomor, dan lanjutkan-baca — ketiganya memang hal yang sama.
/// WAJIB ikut di `==`/`hashCode`, kalau tidak cache bab A dipakai bab B.
class HaditsListParams {
  final String namaTabel;
  final int page;
  final int limit;
  final int? mulai;
  final int? akhir;

  const HaditsListParams({
    required this.namaTabel,
    this.page = 1,
    this.limit = 20,
    this.mulai,
    this.akhir,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HaditsListParams &&
          runtimeType == other.runtimeType &&
          namaTabel == other.namaTabel &&
          page == other.page &&
          limit == other.limit &&
          mulai == other.mulai &&
          akhir == other.akhir;

  @override
  int get hashCode =>
      namaTabel.hashCode ^
      page.hashCode ^
      limit.hashCode ^
      mulai.hashCode ^
      akhir.hashCode;
}

/// GET /hadits/detail/:namaTabel?page=N&limit=20&mulai=&akhir=
final haditsListProvider =
    FutureProvider.family<HaditsPageResult, HaditsListParams>((ref, params) async {
  final apiClient = ref.watch(apiClientProvider);
  try {
    final response = await apiClient.get<List<dynamic>>(
      '${ApiEndpoints.haditsDetail}/${params.namaTabel}',
      queryParameters: {
        'page': params.page,
        'limit': params.limit,
        if (params.mulai != null) 'mulai': params.mulai,
        if (params.akhir != null) 'akhir': params.akhir,
      },
      fromJson: (json) => json is List ? json : <dynamic>[],
    );

    final items = (response.data ?? [])
        .map((e) => HaditsData.fromMap(Map<String, dynamic>.from(e as Map)))
        .toList();

    // Pagination ada di root response, bukan di dalam `data`.
    final rawJson = response.rawJson ?? {};
    final total = rawJson['total'] as int? ?? items.length;
    final totalPages =
        rawJson['totalPages'] as int? ?? (total > 0 ? (total / params.limit).ceil() : 1);

    return HaditsPageResult(
      items: items,
      pagination: HaditsPagination(
        page: rawJson['page'] as int? ?? params.page,
        limit: rawJson['limit'] as int? ?? params.limit,
        total: total,
        totalPages: totalPages,
      ),
    );
  } catch (e) {
    return HaditsPageResult(
      items: [],
      pagination: HaditsPagination(page: 1, limit: params.limit, total: 0, totalPages: 0),
    );
  }
});

/// GET /hadits/bab/:namaTabel — daftar bab satu kitab. Kosong = kitab tanpa bab.
final haditsBabProvider =
    FutureProvider.family<List<HaditsBab>, String>((ref, namaTabel) async {
  final apiClient = ref.watch(apiClientProvider);
  try {
    final response = await apiClient.get<List<dynamic>>(
      '${ApiEndpoints.haditsBab}/$namaTabel',
      fromJson: (json) => json is List ? json : <dynamic>[],
    );
    return (response.data ?? [])
        .map((e) => HaditsBab.fromMap(Map<String, dynamic>.from(e as Map)))
        .toList();
  } catch (e) {
    return [];
  }
});

/// Params pencarian. `q` sudah dinormalisasi (trim) sebelum masuk sini.
class HaditsSearchParams {
  final String q;
  final int page;
  final int limit;
  final String? namaTabel;

  const HaditsSearchParams({
    required this.q,
    this.page = 1,
    this.limit = 20,
    this.namaTabel,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HaditsSearchParams &&
          runtimeType == other.runtimeType &&
          q == other.q &&
          page == other.page &&
          limit == other.limit &&
          namaTabel == other.namaTabel;

  @override
  int get hashCode => q.hashCode ^ page.hashCode ^ limit.hashCode ^ namaTabel.hashCode;
}

/// GET /hadits/search?q=&namaTabel=&page=
final haditsSearchProvider =
    FutureProvider.family<HaditsPageResult, HaditsSearchParams>((ref, params) async {
  final apiClient = ref.watch(apiClientProvider);
  const empty = HaditsPageResult(
    items: [],
    pagination: HaditsPagination(page: 1, limit: 20, total: 0, totalPages: 0),
  );
  if (params.q.length < 3) return empty;

  try {
    final response = await apiClient.get<List<dynamic>>(
      ApiEndpoints.haditsSearch,
      queryParameters: {
        'q': params.q,
        'page': params.page,
        'limit': params.limit,
        if (params.namaTabel != null && params.namaTabel!.isNotEmpty)
          'namaTabel': params.namaTabel,
      },
      fromJson: (json) => json is List ? json : <dynamic>[],
    );

    final items = (response.data ?? [])
        .map((e) => HaditsData.fromMap(Map<String, dynamic>.from(e as Map)))
        .toList();

    final rawJson = response.rawJson ?? {};
    final total = rawJson['total'] as int? ?? items.length;
    final totalPages =
        rawJson['totalPages'] as int? ?? (total > 0 ? (total / params.limit).ceil() : 1);

    return HaditsPageResult(
      items: items,
      pagination: HaditsPagination(
        page: rawJson['page'] as int? ?? params.page,
        limit: rawJson['limit'] as int? ?? params.limit,
        total: total,
        totalPages: totalPages,
      ),
    );
  } catch (e) {
    return empty;
  }
});

/// GET /hadits/tema — kategori induk + jumlah hadits
final haditsTemaProvider = FutureProvider<List<HaditsTema>>((ref) async {
  final apiClient = ref.watch(apiClientProvider);
  try {
    final response = await apiClient.get<List<dynamic>>(
      ApiEndpoints.haditsTema,
      fromJson: (json) => json is List ? json : <dynamic>[],
    );
    return (response.data ?? [])
        .map((e) => HaditsTema.fromMap(Map<String, dynamic>.from(e as Map)))
        .toList();
  } catch (e) {
    return [];
  }
});

/// GET /hadits/tema/:id — isi satu tema (tanpa pagination, set kurasi kecil)
final haditsTemaDetailProvider =
    FutureProvider.family<List<HaditsKoleksi>, int>((ref, id) async {
  final apiClient = ref.watch(apiClientProvider);
  try {
    final response = await apiClient.get<List<dynamic>>(
      '${ApiEndpoints.haditsTema}/$id',
      fromJson: (json) => json is List ? json : <dynamic>[],
    );
    return (response.data ?? [])
        .map((e) => HaditsKoleksi.fromMap(Map<String, dynamic>.from(e as Map)))
        .toList();
  } catch (e) {
    return [];
  }
});

// ============================================================
// Bookmark & riwayat — satu daftar, bukan family
// (jumlah entri tak terbatas, jadi family berarti notifier tak terbatas)
// ============================================================
class HaditsBookmarkNotifier extends StateNotifier<List<HaditsBookmarkData>> {
  HaditsBookmarkNotifier() : super(HaditsBookmarkStorage.getAll());

  List<HaditsBookmarkData> get bookmarks =>
      state.where((e) => e.isBookmark).toList();

  HaditsBookmarkData? get latest => state.isEmpty ? null : state.first;

  bool isBookmarked(String namaTabel, int noHdt) => state
      .any((e) => e.namaTabel == namaTabel && e.noHdt == noHdt && e.isBookmark);

  /// Simpan sebagai bookmark, atau lepas bookmark-nya. Entri tetap tinggal
  /// di riwayat — melepas bookmark bukan menghapus jejak baca.
  bool toggle(HaditsBookmarkData data) {
    if (isBookmarked(data.namaTabel, data.noHdt)) {
      HaditsBookmarkStorage.unbookmark(data.namaTabel, data.noHdt);
      reload();
      return false;
    }
    HaditsBookmarkStorage.saveBookmark(data);
    reload();
    return true;
  }

  void remove(String namaTabel, int noHdt) {
    HaditsBookmarkStorage.remove(namaTabel, noHdt);
    reload();
  }

  void markRead(HaditsBookmarkData data) {
    HaditsBookmarkStorage.markRead(data);
    reload();
  }

  void clearAll() {
    HaditsBookmarkStorage.clear();
    reload();
  }

  void refresh() => reload();

  void reload() => state = HaditsBookmarkStorage.getAll();
}

final haditsBookmarkProvider =
    StateNotifierProvider<HaditsBookmarkNotifier, List<HaditsBookmarkData>>((ref) {
  return HaditsBookmarkNotifier();
});
