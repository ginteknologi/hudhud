import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:masjid_app/core/network/api_endpoints.dart';
import 'package:masjid_app/models/hadist_data.dart';
import 'package:masjid_app/providers/api_providers.dart';
import 'package:masjid_app/storage/hadits_bookmark_storage.dart';

// Provider untuk daftar kitab hadits (GET /hadits)
// Map mentah dipakai apa adanya: UI butuh key longNama, hadits, namaTabel.
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

// Provider untuk daftar kitab per tabel hadits (GET /hadits/detail/:namaTabel)
final haditsDetailProvider = FutureProvider.family<List<ListKitabData>, String>((ref, namaTabel) async {
  final apiClient = ref.watch(apiClientProvider);
  try {
    final response = await apiClient.get<List<ListKitabData>>(
      '${ApiEndpoints.haditsDetail}/$namaTabel',
      fromJson: (json) {
        if (json is List) {
          return json
              .map((item) => ListKitabData(
                    idKitab: item['ID_Kitab'] as int,
                    kitabIndonesia: item['Kitab_Indonesia'] as String,
                    kitabArab: item['Kitab_Arab'] as String?,
                    noHdt: item['NoHdt'] as int?,
                  ))
              .toList();
        }
        return [];
      },
    );
    return response.data ?? [];
  } catch (e) {
    return [];
  }
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

// Provider untuk daftar bab (GET /hadits/detail/bab/:namaTabel?kitab=:idKitab)
final haditsBabProvider =
    FutureProvider.family<List<ListBabData>, HaditsBabParams>((ref, params) async {
  final apiClient = ref.watch(apiClientProvider);
  try {
    final response = await apiClient.get<List<ListBabData>>(
      '${ApiEndpoints.haditsDetail}/bab/${params.namaTabel}',
      queryParameters: {'kitab': params.idKitab},
      fromJson: (json) {
        if (json is List) {
          return json
              .map((item) => ListBabData(
                    idBab: item['ID_Bab'] as int,
                    idKitab: item['ID_Kitab'] as int,
                    babIndonesia: item['Bab_Indonesia'] as String,
                    babArab: item['Bab_Arab'] as String,
                  ))
              .toList();
        }
        return [];
      },
    );
    return response.data ?? [];
  } catch (e) {
    return [];
  }
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

// Provider untuk isi hadits
// (GET /hadits/detail/bab/content/:namaTabel?ID_Kitab=&ID_Bab=)
final haditsContentProvider =
    FutureProvider.family<List<ListHadistData>, HaditsContentParams>((ref, params) async {
  final apiClient = ref.watch(apiClientProvider);
  try {
    final response = await apiClient.get<List<ListHadistData>>(
      '${ApiEndpoints.haditsDetail}/bab/content/${params.namaTabel}',
      queryParameters: {
        'ID_Kitab': params.idKitab,
        // ponytail: null -> "null", persis seperti service lama (jalur 'arbain').
        'ID_Bab': '${params.idBab}',
      },
      fromJson: (json) {
        if (json is List) {
          return json
              .map((item) => ListHadistData(
                    noHdt: item['NoHdt'] as int,
                    idBab: item['ID_Bab'] as int?,
                    idKitab: item['ID_Kitab'] as int?,
                    isiArab: item['Isi_Arab'] as String,
                    isiIndonesia: item['Isi_Indonesia'] as String,
                  ))
              .toList();
        }
        return [];
      },
    );
    return response.data ?? [];
  } catch (e) {
    return [];
  }
});

// Notifier & Provider untuk Terakhir Dibaca / Bookmark Hadits (dengan kemampuan toggle / unchecklist)
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

  /// Toggle bookmark: jika hadits yang sama sudah ditandai, maka unchecklist / clear.
  /// Mengembalikan true jika ditandai, false jika dihapus / di-unchecklist.
  bool toggleBookmark(HaditsBookmarkData data) {
    if (state != null && state!.namaTabel == data.namaTabel && state!.noHdt == data.noHdt) {
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
