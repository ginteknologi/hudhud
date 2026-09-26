import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:masjid_app/core/network/api_endpoints.dart';
import 'package:masjid_app/models/kajian_model.dart';
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

// ponytail: /kajian/slider dibatasi LIMIT 5, jadi daftar lengkap disaring dari
// /kajian/list. `tipe` asalnya kajian_kategoris.nama: tafsir/live/muadzin/
// doa_ramadhan/quotes.
// Upgrade: endpoint /kajian/tafsir/list kalau tabel kajian sudah besar.
final kajianTafsirListProvider = FutureProvider<List<KajianModel>>((ref) async {
  final all = await ref.watch(kajianListProvider.future);
  return all.where((k) => k.type == 'tafsir').toList();
});

final kajianLiveListProvider = FutureProvider<List<KajianModel>>((ref) async {
  final apiClient = ref.watch(apiClientProvider);
  try {
    final response = await apiClient.get<List<KajianModel>>(
      ApiEndpoints.kajianLiveList,
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
