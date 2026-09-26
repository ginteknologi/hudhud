import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:html/parser.dart';
import 'package:masjid_app/core/network/api_endpoints.dart';
import 'package:masjid_app/models/artikel_data.dart';
import 'package:masjid_app/models/artikel_model.dart';
import 'package:masjid_app/models/pagination_state.dart';
import 'package:masjid_app/providers/api_providers.dart';

final artikelTerbaruProvider = FutureProvider<List<ArtikelModel>>((ref) async {
  final apiClient = ref.watch(apiClientProvider);
  try {
    final response = await apiClient.get<List<ArtikelModel>>(
      ApiEndpoints.artikelTerbaru,
      fromJson: (json) {
        if (json is List) {
          return json.map((item) => ArtikelModel.fromJson(item as Map<String, dynamic>)).toList();
        }
        return [];
      },
    );
    return response.data ?? [];
  } catch (e) {
    return [];
  }
});

ArtikelData _artikelFromJson(dynamic raw) {
  final item = Map<String, dynamic>.from(raw as Map);
  return ArtikelData(
    id: (item['id'] as num?)?.toInt() ?? 0,
    judul: item['judul'] as String? ?? '',
    image: item['image'] as String? ?? '',
    updatedAt: item['updatedAt'] as String? ?? '',
    publishDate: item['publish_date'] as String? ?? '',
    isi: item['isi'] as String?,
    categoryArtikel: item['category_artikel'] as Map?,
  );
}

// Provider daftar artikel sederhana (GET /artikel)
final artikelListProvider = FutureProvider<List<ArtikelData>>((ref) async {
  final apiClient = ref.watch(apiClientProvider);
  try {
    final response = await apiClient.get<List<ArtikelData>>(
      ApiEndpoints.artikel,
      fromJson: (json) {
        if (json is List) {
          return json.map(_artikelFromJson).toList();
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
// Infinite Loading Notifier & Provider untuk Artikel
// ============================================================

class ArtikelInfiniteNotifier extends StateNotifier<PaginationState<ArtikelData>> {
  final Ref ref;
  static const int _limit = 10;

  ArtikelInfiniteNotifier(this.ref)
      : super(const PaginationState<ArtikelData>(isLoading: true)) {
    loadFirstPage();
  }

  Future<void> loadFirstPage() async {
    state = state.copyWith(isLoading: true, clearError: true);
    final apiClient = ref.read(apiClientProvider);

    try {
      final response = await apiClient.get<List<ArtikelData>>(
        ApiEndpoints.artikel,
        queryParameters: {'page': 1, 'limit': _limit},
        fromJson: (json) {
          if (json is List) {
            return json.map(_artikelFromJson).toList();
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
        errorMessage: 'Gagal memuat artikel: ${e.toString()}',
      );
    }
  }

  Future<void> loadNextPage() async {
    if (state.isLoading || state.isLoadingMore || !state.hasMore) return;

    state = state.copyWith(isLoadingMore: true);
    final apiClient = ref.read(apiClientProvider);
    final nextPage = state.page + 1;

    try {
      final response = await apiClient.get<List<ArtikelData>>(
        ApiEndpoints.artikel,
        queryParameters: {'page': nextPage, 'limit': _limit},
        fromJson: (json) {
          if (json is List) {
            return json.map(_artikelFromJson).toList();
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
      final response = await apiClient.get<List<ArtikelData>>(
        ApiEndpoints.artikel,
        queryParameters: {'page': 1, 'limit': _limit},
        fromJson: (json) {
          if (json is List) {
            return json.map(_artikelFromJson).toList();
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

final artikelInfiniteProvider = StateNotifierProvider<
    ArtikelInfiniteNotifier, PaginationState<ArtikelData>>((ref) {
  return ArtikelInfiniteNotifier(ref);
});

class ArtikelDetailResult {
  final ArtikelData detail;
  final List<ArtikelData> lainnya;
  final String share;

  ArtikelDetailResult({
    required this.detail,
    required this.lainnya,
    required this.share,
  });
}

String _convertHtmlToText(String htmlString) {
  try {
    final document = parse(htmlString);
    return parse(document.body!.text).documentElement!.text;
  } catch (_) {
    return '';
  }
}

// Provider detail artikel + artikel lainnya (GET /artikel/detail/:id, /artikel/lain/:id)
final artikelDetailProvider =
    FutureProvider.family<ArtikelDetailResult, int>((ref, id) async {
  final apiClient = ref.watch(apiClientProvider);
  final empty = ArtikelDetailResult(
    detail: ArtikelData(
      id: id,
      judul: '',
      image: '',
      updatedAt: '',
      publishDate: '',
    ),
    lainnya: [],
    share: '',
  );
  try {
    final detailResponse = await apiClient.get<Map<String, dynamic>>(
      '${ApiEndpoints.artikel}/detail/$id',
      fromJson: (json) =>
          json is Map ? Map<String, dynamic>.from(json) : <String, dynamic>{},
    );
    final data = detailResponse.data ?? <String, dynamic>{};
    final detail = _artikelFromJson(data);

    final lainResponse = await apiClient.get<List<ArtikelData>>(
      '${ApiEndpoints.artikel}/lain/$id',
      fromJson: (json) {
        if (json is List) {
          return json.map(_artikelFromJson).toList();
        }
        return [];
      },
    );
    final lainnya = lainResponse.data ?? [];
    lainnya.sort(
        (a, b) => DateTime.parse(b.updatedAt).compareTo(DateTime.parse(a.updatedAt)));

    return ArtikelDetailResult(
      detail: detail,
      lainnya: lainnya,
      share:
          '${detail.judul}\n\n${_convertHtmlToText(detail.isi ?? '')}\n\nDibagikan dari aplikasi\n\n Marbot App',
    );
  } catch (e) {
    return empty;
  }
});
