import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:masjid_app/core/network/api_endpoints.dart';
import 'package:masjid_app/providers/api_providers.dart';
import 'package:masjid_app/providers/auth_provider.dart';

// Daftar notifikasi user: GET /notif/:id_user
final notifikasiListProvider = FutureProvider<List<dynamic>>((ref) async {
  final apiClient = ref.watch(apiClientProvider);
  final user = ref.watch(authNotifierProvider).valueOrNull;
  if (user == null) return [];
  try {
    final response = await apiClient.get<List<dynamic>>(
      '${ApiEndpoints.notif}/${user.id}',
      fromJson: (json) => json is List ? json : <dynamic>[],
    );
    return response.data ?? [];
  } catch (e) {
    return [];
  }
});

// Detail notifikasi: GET /notif/detail/:id (field 'data' berupa string JSON)
final notifikasiDetailProvider =
    FutureProvider.family<Map<String, dynamic>, String>((ref, id) async {
  final apiClient = ref.watch(apiClientProvider);
  final response = await apiClient.get<Map<String, dynamic>>(
    '${ApiEndpoints.notif}/detail/$id',
    fromJson: (json) {
      final map = Map<String, dynamic>.from(json as Map);
      final data = map['data'];
      if (data is String) {
        map['data'] = jsonDecode(data);
      }
      return map;
    },
  );
  return response.data ?? <String, dynamic>{};
});
