import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:html/parser.dart';
import 'package:masjid_app/core/network/api_endpoints.dart';
import 'package:masjid_app/models/doa_data.dart';
import 'package:masjid_app/models/doa_models.dart';
import 'package:masjid_app/models/pagination_state.dart';
import 'package:masjid_app/providers/api_providers.dart';

// Provider untuk kategori doa
final doaCategoriesProvider = FutureProvider<List<DoaCategoryModel>>((ref) async {
  final apiClient = ref.watch(apiClientProvider);
  try {
    final response = await apiClient.get<List<DoaCategoryModel>>(
      ApiEndpoints.doaCategory,
      fromJson: (json) {
        if (json is List) {
          return json.map((item) => DoaCategoryModel.fromJson(item as Map<String, dynamic>)).toList();
        }
        return [];
      },
    );
    return response.data ?? [];
  } catch (e) {
    return [];
  }
});

// Provider untuk daftar doa per kategori + search
class DoaListParams {
  final String categoryId;
  final String query;

  const DoaListParams({required this.categoryId, this.query = ''});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DoaListParams &&
          runtimeType == other.runtimeType &&
          categoryId == other.categoryId &&
          query == other.query;

  @override
  int get hashCode => categoryId.hashCode ^ query.hashCode;
}

final doaListProvider = FutureProvider.family<List<DoaItemModel>, DoaListParams>((ref, params) async {
  final apiClient = ref.watch(apiClientProvider);
  try {
    final response = await apiClient.get<List<DoaItemModel>>(
      '${ApiEndpoints.doaList}/${params.categoryId}',
      queryParameters: params.query.isNotEmpty ? {'search': params.query} : null,
      fromJson: (json) {
        if (json is List) {
          return json.map((item) {
            final map = Map<String, dynamic>.from(item as Map);
            // API kirim field `isi`; DoaItemModel menyimpannya sebagai `arti`.
            map['arti'] ??= map['isi'];
            return DoaItemModel.fromJson(map);
          }).toList();
        }
        return [];
      },
    );
    return response.data ?? [];
  } catch (e) {
    return [];
  }
});

// ============================================================
// Infinite Loading Notifier & Provider untuk Doa
// ============================================================

class DoaInfiniteNotifier extends StateNotifier<PaginationState<DoaItemModel>> {
  final Ref ref;
  final DoaListParams params;
  static const int _limit = 15;

  DoaInfiniteNotifier(this.ref, this.params)
      : super(const PaginationState<DoaItemModel>(isLoading: true)) {
    loadFirstPage();
  }

  Future<void> loadFirstPage() async {
    state = state.copyWith(isLoading: true, clearError: true);
    final apiClient = ref.read(apiClientProvider);

    try {
      final queryParams = <String, dynamic>{
        'page': 1,
        'limit': _limit,
      };
      if (params.query.isNotEmpty) {
        queryParams['search'] = params.query;
      }

      final response = await apiClient.get<List<DoaItemModel>>(
        '${ApiEndpoints.doaList}/${params.categoryId}',
        queryParameters: queryParams,
        fromJson: (json) {
          if (json is List) {
            return json.map((item) {
              final map = Map<String, dynamic>.from(item as Map);
              map['arti'] ??= map['isi'];
              return DoaItemModel.fromJson(map);
            }).toList();
          }
          return [];
        },
      );

      final items = response.data ?? [];
      state = state.copyWith(
        items: items,
        page: 1,
        hasMore: items.length >= _limit,
        isLoading: false,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Gagal memuat doa: ${e.toString()}',
      );
    }
  }

  Future<void> loadNextPage() async {
    if (state.isLoading || state.isLoadingMore || !state.hasMore) return;

    state = state.copyWith(isLoadingMore: true);
    final apiClient = ref.read(apiClientProvider);
    final nextPage = state.page + 1;

    try {
      final queryParams = <String, dynamic>{
        'page': nextPage,
        'limit': _limit,
      };
      if (params.query.isNotEmpty) {
        queryParams['search'] = params.query;
      }

      final response = await apiClient.get<List<DoaItemModel>>(
        '${ApiEndpoints.doaList}/${params.categoryId}',
        queryParameters: queryParams,
        fromJson: (json) {
          if (json is List) {
            return json.map((item) {
              final map = Map<String, dynamic>.from(item as Map);
              map['arti'] ??= map['isi'];
              return DoaItemModel.fromJson(map);
            }).toList();
          }
          return [];
        },
      );

      final newItems = response.data ?? [];
      state = state.copyWith(
        items: [...state.items, ...newItems],
        page: nextPage,
        hasMore: newItems.length >= _limit,
        isLoadingMore: false,
      );
    } catch (e) {
      state = state.copyWith(isLoadingMore: false);
    }
  }

  Future<void> refresh() async {
    final apiClient = ref.read(apiClientProvider);
    try {
      final queryParams = <String, dynamic>{
        'page': 1,
        'limit': _limit,
      };
      if (params.query.isNotEmpty) {
        queryParams['search'] = params.query;
      }

      final response = await apiClient.get<List<DoaItemModel>>(
        '${ApiEndpoints.doaList}/${params.categoryId}',
        queryParameters: queryParams,
        fromJson: (json) {
          if (json is List) {
            return json.map((item) {
              final map = Map<String, dynamic>.from(item as Map);
              map['arti'] ??= map['isi'];
              return DoaItemModel.fromJson(map);
            }).toList();
          }
          return [];
        },
      );

      final items = response.data ?? [];
      state = state.copyWith(
        items: items,
        page: 1,
        hasMore: items.length >= _limit,
        isLoading: false,
        clearError: true,
      );
    } catch (e) {
      // keep existing items
    }
  }
}

final doaInfiniteProvider = StateNotifierProvider.family<
    DoaInfiniteNotifier, PaginationState<DoaItemModel>, DoaListParams>((ref, params) {
  return DoaInfiniteNotifier(ref, params);
});

// Provider detail doa berdasarkan id konten (field html: arabic, transliteration, dll)
final doaDetailProvider = FutureProvider.family<DoaData?, String>((ref, id) async {
  final apiClient = ref.watch(apiClientProvider);
  try {
    final response = await apiClient.get<DoaData>(
      '${ApiEndpoints.doaDetail}/$id',
      fromJson: (json) {
        final map = json as Map<String, dynamic>;
        final arab = map['arabic'] as String? ??
            map['teks_arab'] as String? ??
            map['arab'] as String?;
        final latin = map['transliteration'] as String? ??
            map['teks_latin'] as String? ??
            map['latin'] as String?;
        final arti = map['translations'] as String? ??
            map['terjemahan'] as String? ??
            map['isi'] as String? ??
            map['arti'] as String?;
        return DoaData(
          id: map['id'] is int
              ? map['id'] as int
              : int.tryParse('${map['id']}') ?? 1,
          judul: map['judul'] as String? ?? '',
          updatedAt: map['updatedAt'] as String? ?? '',
          arabic: arab,
          transliteration: latin,
          translations: arti,
          isi: arti,
          opening: map['opening'] as String?,
        );
      },
    );
    return response.data;
  } catch (e) {
    return null;
  }
});

// Provider untuk dzikir harian (pagi, petang, solat)
final dzikirListProvider = FutureProvider<List<DzikirItemModel>>((ref) async {
  final apiClient = ref.watch(apiClientProvider);
  try {
    final response = await apiClient.get<List<DzikirItemModel>>(
      ApiEndpoints.dzikir,
      fromJson: (json) {
        if (json is List) {
          return json.map((item) => DzikirItemModel.fromJson(item as Map<String, dynamic>)).toList();
        }
        return [];
      },
    );
    return response.data ?? [];
  } catch (e) {
    return [];
  }
});

// Dzikir harian apa adanya (map mentah). DzikirItemModel tidak membawa
// transliteration/translations/isi/opening/idCategoryDoa yang dipakai halaman
// Dzikir; provider ini mengembalikan item lengkap dengan teks sudah bersih html.
final dzikirRawProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final apiClient = ref.watch(apiClientProvider);
  try {
    final response = await apiClient.get<List<Map<String, dynamic>>>(
      ApiEndpoints.dzikir,
      fromJson: (json) {
        if (json is List) {
          return json.map((item) => _cleanDzikirItem(item as Map)).toList();
        }
        return [];
      },
    );
    return response.data ?? [];
  } catch (e) {
    return [];
  }
});

const _dzikirHtmlFields = [
  'judul',
  'arabic',
  'transliteration',
  'translations',
  'isi',
  'opening',
];

String _convertHtmlToText(String htmlString) {
  final document = parse(htmlString);
  return parse(document.body!.text).documentElement!.text;
}

Map<String, dynamic> _cleanDzikirItem(Map raw) {
  final map = Map<String, dynamic>.from(raw);
  for (final key in _dzikirHtmlFields) {
    final value = map[key];
    map[key] = value != null ? _convertHtmlToText(value.toString()) : '';
  }
  return map;
}

// Digital Tasbih Counter State
class TasbihState {
  final int count;
  final int target;

  const TasbihState({this.count = 0, this.target = 33});

  TasbihState copyWith({int? count, int? target}) {
    return TasbihState(
      count: count ?? this.count,
      target: target ?? this.target,
    );
  }
}

class TasbihNotifier extends StateNotifier<TasbihState> {
  TasbihNotifier() : super(const TasbihState());

  void increment() {
    if (state.count + 1 >= state.target) {
      state = state.copyWith(count: state.target);
    } else {
      state = state.copyWith(count: state.count + 1);
    }
  }

  void reset() {
    state = state.copyWith(count: 0);
  }

  void setTarget(int target) {
    state = state.copyWith(target: target, count: 0);
  }
}

final tasbihProvider = StateNotifierProvider.autoDispose<TasbihNotifier, TasbihState>((ref) {
  return TasbihNotifier();
});
