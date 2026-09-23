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
