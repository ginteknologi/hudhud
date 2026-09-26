import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:masjid_app/core/network/api_endpoints.dart';
import 'package:masjid_app/models/kajian_model.dart';
import 'package:masjid_app/models/pagination_state.dart';
import 'package:masjid_app/providers/api_providers.dart';

final kajianListProvider = FutureProvider<List<KajianModel>>((ref) async {
  final apiClient = ref.watch(apiClientProvider);
  try {
    final response = await apiClient.get<List<KajianModel>>(
      ApiEndpoints.kajianList,
      fromJson: (json) {
        if (json is List) {
          return json.map((item) => KajianModel.fromJson(item as Map<String, dynamic>)).toList();
        }
        return [];
      },
    );
    return response.data ?? [];
  } catch (e) {
    return [];
  }
});

// type: 'tafsir' (dashboard), 'quotes' (dkm) — mirrors the old ?type= query.
final kajianSliderProvider =
    FutureProvider.family<List<KajianModel>, String>((ref, type) async {
  final apiClient = ref.watch(apiClientProvider);
  try {
    final response = await apiClient.get<List<KajianModel>>(
      ApiEndpoints.kajianSlider,
      queryParameters: {'type': type},
      fromJson: (json) {
        if (json is List) {
          return json.map((item) => KajianModel.fromJson(item as Map<String, dynamic>)).toList();
        }
        return [];
      },
    );
    return response.data ?? [];
  } catch (e) {
    return [];
  }
});

// Home: /kajian/kaji-live/slider LIMIT 5. Daftar penuh di /kajian/kaji-live/list.
final kajianLiveSliderProvider = FutureProvider<List<KajianModel>>((ref) async {
  final apiClient = ref.watch(apiClientProvider);
  try {
    final response = await apiClient.get<List<KajianModel>>(
      ApiEndpoints.kajianLiveSlider,
      fromJson: (json) {
        if (json is List) {
          return json.map((item) => KajianModel.fromJson(item as Map<String, dynamic>)).toList();
        }
        return [];
      },
    );
    return response.data ?? [];
  } catch (e) {
    return [];
  }
});

final kajianTafsirListProvider = FutureProvider<List<KajianModel>>((ref) async {
  final apiClient = ref.watch(apiClientProvider);
  try {
    final response = await apiClient.get<List<KajianModel>>(
      ApiEndpoints.kajianList,
      queryParameters: {'type': 'tafsir', 'page': 1, 'limit': 20},
      fromJson: (json) {
        if (json is List) {
          return json.map((item) => KajianModel.fromJson(item as Map<String, dynamic>)).toList();
        }
        return [];
      },
    );
    return response.data ?? [];
  } catch (e) {
    return [];
  }
});

final kajianSahabatListProvider = FutureProvider<List<KajianModel>>((ref) async {
  final apiClient = ref.watch(apiClientProvider);
  try {
    final response = await apiClient.get<List<KajianModel>>(
      ApiEndpoints.kajianList,
      queryParameters: {'type': 'doa_ramadhan', 'page': 1, 'limit': 20},
      fromJson: (json) {
        if (json is List) {
          return json.map((item) => KajianModel.fromJson(item as Map<String, dynamic>)).toList();
        }
        return [];
      },
    );
    return response.data ?? [];
  } catch (e) {
    return [];
  }
});

final kajianLiveListProvider = FutureProvider<List<KajianModel>>((ref) async {
  final apiClient = ref.watch(apiClientProvider);
  try {
    final response = await apiClient.get<List<KajianModel>>(
      ApiEndpoints.kajianLiveList,
      queryParameters: {'page': 1, 'limit': 20},
      fromJson: (json) {
        if (json is List) {
          return json.map((item) => KajianModel.fromJson(item as Map<String, dynamic>)).toList();
        }
        return [];
      },
    );
    return response.data ?? [];
  } catch (e) {
    return [];
  }
});

final muadzinListProvider = FutureProvider<List<KajianModel>>((ref) async {
  final apiClient = ref.watch(apiClientProvider);
  try {
    final response = await apiClient.get<List<KajianModel>>(
      ApiEndpoints.muadzinList,
      fromJson: (json) {
        if (json is List) {
          return json.map((item) => KajianModel.fromJson(item as Map<String, dynamic>)).toList();
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
// Infinite Loading Notifier & Provider untuk Kajian
// ============================================================

class KajianInfiniteNotifier extends StateNotifier<PaginationState<KajianModel>> {
  final Ref ref;
  final String type;
  static const int _limit = 10;

  KajianInfiniteNotifier(this.ref, this.type)
      : super(const PaginationState<KajianModel>(isLoading: true)) {
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
      if (type.isNotEmpty && type != 'all') {
        queryParams['type'] = type;
      }

      final endpoint = type == 'live' ? ApiEndpoints.kajianLiveList : ApiEndpoints.kajianList;
      final response = await apiClient.get<List<KajianModel>>(
        endpoint,
        queryParameters: queryParams,
        fromJson: (json) {
          if (json is List) {
            return json.map((item) => KajianModel.fromJson(item as Map<String, dynamic>)).toList();
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
        errorMessage: 'Gagal memuat kajian: ${e.toString()}',
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
      if (type.isNotEmpty && type != 'all') {
        queryParams['type'] = type;
      }

      final endpoint = type == 'live' ? ApiEndpoints.kajianLiveList : ApiEndpoints.kajianList;
      final response = await apiClient.get<List<KajianModel>>(
        endpoint,
        queryParameters: queryParams,
        fromJson: (json) {
          if (json is List) {
            return json.map((item) => KajianModel.fromJson(item as Map<String, dynamic>)).toList();
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
      if (type.isNotEmpty && type != 'all') {
        queryParams['type'] = type;
      }

      final endpoint = type == 'live' ? ApiEndpoints.kajianLiveList : ApiEndpoints.kajianList;
      final response = await apiClient.get<List<KajianModel>>(
        endpoint,
        queryParameters: queryParams,
        fromJson: (json) {
          if (json is List) {
            return json.map((item) => KajianModel.fromJson(item as Map<String, dynamic>)).toList();
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
      // Keep existing data on refresh error
    }
  }
}

final kajianInfiniteProvider = StateNotifierProvider.family<
    KajianInfiniteNotifier, PaginationState<KajianModel>, String>((ref, type) {
  return KajianInfiniteNotifier(ref, type);
});
