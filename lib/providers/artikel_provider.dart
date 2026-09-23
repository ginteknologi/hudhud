import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:html/parser.dart';
import 'package:masjid_app/core/network/api_endpoints.dart';
import 'package:masjid_app/models/artikel_data.dart';
import 'package:masjid_app/models/artikel_model.dart';
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

// Provider daftar artikel (GET /artikel)
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
