import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:masjid_app/core/network/api_endpoints.dart';
import 'package:masjid_app/models/hadist_data.dart';
import 'package:masjid_app/providers/api_providers.dart';
import 'package:masjid_app/storage/hadits_bookmark_storage.dart';

// ============================================================
// v2 Providers — struktur baru (flat, pagination)
// ============================================================

/// GET /hadits — daftar imam/perawi
final haditsBooksProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final apiClient = ref.watch(apiClientProvider);
  try {
    final response = await apiClient.get<List<Map<String, dynamic>>>(
      '/hadits',
      fromJson: (json) {
        if (json is List) {
          return json.map((item) => Map<String, dynamic>.from(item as Map)).toList();
        }
        return [];
      },
    );
    return response.data ?? [];
  } catch (e) {
    return [];
  }
});

/// Params untuk hadits list (namaTabel + page)
class HaditsListParams {
  final String namaTabel;
  final int page;
  final int limit;

  const HaditsListParams({
    required this.namaTabel,
    this.page = 1,
    this.limit = 20,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HaditsListParams &&
          runtimeType == other.runtimeType &&
          namaTabel == other.namaTabel &&
          page == other.page &&
          limit == other.limit;

  @override
  int get hashCode => namaTabel.hashCode ^ page.hashCode ^ limit.hashCode;
}

/// GET /hadits/detail/:namaTabel?page=N&limit=20
/// Mengembalikan HaditsPageResult (items + pagination)
final haditsListProvider =
    FutureProvider.family<HaditsPageResult, HaditsListParams>((ref, params) async {
  final apiClient = ref.watch(apiClientProvider);
  try {
    final response = await apiClient.get<Map<String, dynamic>>(
      '${ApiEndpoints.haditsDetail}/${params.namaTabel}',
      queryParameters: {
        'page': params.page,
        'limit': params.limit,
      },
      fromJson: (json) {
        if (json is Map) return Map<String, dynamic>.from(json);
        return <String, dynamic>{};
      },
    );

    final raw = response.data ?? {};
    final dataList = raw['data'];
    final items = (dataList is List)
        ? dataList.map((e) => HaditsData.fromMap(Map<String, dynamic>.from(e as Map))).toList()
        : <HaditsData>[];

    final paginationRaw = raw['pagination'];
    final pagination = (paginationRaw is Map)
        ? HaditsPagination.fromMap(Map<String, dynamic>.from(paginationRaw))
        : HaditsPagination(
            page: params.page,
            limit: params.limit,
            total: items.length,
            totalPages: 1,
          );

    return HaditsPageResult(items: items, pagination: pagination);
  } catch (e) {
    return HaditsPageResult(
      items: [],
      pagination: HaditsPagination(page: 1, limit: params.limit, total: 0, totalPages: 0),
    );
  }
});

// ============================================================
// Providers lama — dipertahankan agar screen lama tidak error
// (BabHaditsPage, ContentHaditsPage masih ada di router lama)
// ============================================================

final haditsDetailProvider =
    FutureProvider.family<List<ListKitabData>, String>((ref, namaTabel) async {
  return [];
});

class HaditsBabParams {
  final String namaTabel;
  final int idKitab;

  const HaditsBabParams({required this.namaTabel, required this.idKitab});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HaditsBabParams &&
          runtimeType == other.runtimeType &&
          namaTabel == other.namaTabel &&
          idKitab == other.idKitab;

  @override
  int get hashCode => namaTabel.hashCode ^ idKitab.hashCode;
}

final haditsBabProvider =
    FutureProvider.family<List<ListBabData>, HaditsBabParams>((ref, params) async {
  return [];
});

class HaditsContentParams {
  final String namaTabel;
  final int idKitab;
  final int? idBab;

  const HaditsContentParams({
    required this.namaTabel,
    required this.idKitab,
    this.idBab,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HaditsContentParams &&
          runtimeType == other.runtimeType &&
          namaTabel == other.namaTabel &&
          idKitab == other.idKitab &&
          idBab == other.idBab;

  @override
  int get hashCode => namaTabel.hashCode ^ idKitab.hashCode ^ idBab.hashCode;
}

final haditsContentProvider =
    FutureProvider.family<List<ListHadistData>, HaditsContentParams>((ref, params) async {
  return [];
});

// ============================================================
// Bookmark Provider — tetap sama
// ============================================================
class HaditsBookmarkNotifier extends StateNotifier<HaditsBookmarkData?> {
  HaditsBookmarkNotifier() : super(HaditsBookmarkStorage.getBookmark());

  void saveBookmark(HaditsBookmarkData data) {
    HaditsBookmarkStorage.saveBookmark(data);
    state = data;
  }

  void clearBookmark() {
    HaditsBookmarkStorage.clear();
    state = null;
  }

  bool toggleBookmark(HaditsBookmarkData data) {
    if (state != null &&
        state!.namaTabel == data.namaTabel &&
        state!.noHdt == data.noHdt) {
      clearBookmark();
      return false;
    } else {
      saveBookmark(data);
      return true;
    }
  }

  void refresh() {
    state = HaditsBookmarkStorage.getBookmark();
  }
}

final haditsBookmarkProvider =
    StateNotifierProvider<HaditsBookmarkNotifier, HaditsBookmarkData?>((ref) {
  return HaditsBookmarkNotifier();
});
