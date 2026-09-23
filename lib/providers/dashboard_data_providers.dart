import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:masjid_app/core/network/api_endpoints.dart';
import 'package:masjid_app/models/sedang_live_data.dart';
import 'package:masjid_app/providers/api_providers.dart';

final sedangLiveListProvider = FutureProvider<List<SedangLiveData>>((ref) async {
  try {
    final apiClient = ref.watch(apiClientProvider);
    final response = await apiClient.get<List<SedangLiveData>>(
      ApiEndpoints.live,
      fromJson: (json) {
        if (json is List) {
          return json
              .map((item) => SedangLiveData.fromJson(item as Map<String, dynamic>))
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
