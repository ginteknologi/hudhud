import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:masjid_app/core/network/api_endpoints.dart';
import 'package:masjid_app/core/storage/preferences_service.dart';
import 'package:masjid_app/models/user_model.dart';
import 'package:masjid_app/providers/api_providers.dart';
import 'package:masjid_app/providers/auth_provider.dart';
import 'package:minio_new/minio.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Riwayat sedekah + total sedekah milik user yang sedang login.
class RiwayatSedekah {
  final List<Map<String, dynamic>> history;
  final int totalSedekah;

  RiwayatSedekah({required this.history, required this.totalSedekah});

  static RiwayatSedekah fromJson(Map<String, dynamic> json) {
    final rawHistory = json['history'];
    return RiwayatSedekah(
      history: rawHistory is List
          ? rawHistory.map((e) => Map<String, dynamic>.from(e as Map)).toList()
          : <Map<String, dynamic>>[],
      totalSedekah: (json['total_sedekah'] as num?)?.toInt() ?? 0,
    );
  }
}

final riwayatSedekahProvider = FutureProvider<RiwayatSedekah>((ref) async {
  final email = ref.watch(authNotifierProvider).valueOrNull?.email ?? '';
  final apiClient = ref.watch(apiClientProvider);
  try {
    final response = await apiClient.get<RiwayatSedekah>(
      '${ApiEndpoints.transaksiHistory}/$email',
      fromJson: (json) => json is Map<String, dynamic>
          ? RiwayatSedekah.fromJson(json)
          : RiwayatSedekah(history: const [], totalSedekah: 0),
    );
    return response.data ?? RiwayatSedekah(history: const [], totalSedekah: 0);
  } catch (e) {
    return RiwayatSedekah(history: const [], totalSedekah: 0);
  }
});

/// Kontak / sosial media resmi sekarang di-hardcode di
/// `lib/pages/dkm/dkm_page.dart` (kOfficialSocials) — tidak lagi dari server.

final appVersionProvider = FutureProvider<String>((ref) async {
  try {
    final info = await PackageInfo.fromPlatform();
    return info.version;
  } catch (e) {
    return '0.0.0';
  }
});

/// Simpan profile (update nama/phone/photo + upload avatar ke Minio).
/// ponytail: PUT dipakai via http langsung karena ApiClient (core) hanya punya get/post.
class AkunRepository {
  AkunRepository(this.ref);

  static const String _phoneKey = 'profile_phone';

  static String get savedPhone => PreferencesService.getString(_phoneKey) ?? '';

  final Ref ref;

  final _minio = Minio(
    endPoint: 'nos.wjv-1.neo.id',
    accessKey: '00de6efb8708931b289e',
    secretKey: '8PG4OCho1aJJaZlYoa0cc+lQlODCF8EMla+rNKR0',
  );

  Future<String?> _uploadAvatar(File file, String fileName) async {
    final bytes = await file.readAsBytes();
    final currentTimeInMillis = DateTime.now().millisecondsSinceEpoch;
    final objectName = 'avatar/$currentTimeInMillis-$fileName';

    await _minio.putObject(
      'marbot',
      objectName,
      Stream<Uint8List>.value(bytes),
      metadata: {
        'x-amz-acl': 'public-read',
        'Content-type': 'image/png',
      },
      onProgress: (progress) {
        if (kDebugMode) {
          debugPrint('$progress uploaded');
        }
      },
    );

    return 'https://nos.wjv-1.neo.id/marbot/$objectName';
  }

  Future<bool> simpanProfile({
    required String nama,
    required String phone,
    File? newFile,
    String fileName = '',
  }) async {
    try {
      String photo = '';
      if (newFile != null) {
        photo = await _uploadAvatar(newFile, fileName) ?? '';
      }

      final currentUser = ref.read(authNotifierProvider).valueOrNull;
      final response = await http.put(
        Uri.parse(
          '${ApiEndpoints.baseUrl}${ApiEndpoints.profile}/${currentUser?.id ?? ''}',
        ),
        headers: <String, String>{
          'Authorization': 'Bearer ${PreferencesService.token}',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'nama': nama,
          'phone': phone,
          'photo': photo,
        }),
      );

      if (response.statusCode != 200) return false;

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final data = json['data'] is Map
          ? Map<String, dynamic>.from(json['data'] as Map)
          : <String, dynamic>{};

      final updatedUser = UserModel(
        id: (data['id'] as num?)?.toInt() ?? currentUser?.id ?? 0,
        name: data['nama'] as String? ?? nama,
        email: data['email'] as String? ?? currentUser?.email ?? '',
        photo: data['photo'] as String? ??
            currentUser?.photo ??
            'https://nos.wjv-1.neo.id/marbot/assets/app_icon.png',
        totalSedekah: (data['total_sedekah'] as num?)?.toInt() ??
            currentUser?.totalSedekah ??
            0,
      );

      PreferencesService.userJson = jsonEncode(updatedUser.toJson());
      // ponytail: UserModel tidak punya field phone, jadi phone disimpan terpisah
      // supaya form edit tetap terisi seperti sebelumnya.
      await PreferencesService.setString(_phoneKey, phone);
      ref.read(authNotifierProvider.notifier).checkAuthStatus();
      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('<<error simpanProfile>>');
        debugPrint(e.toString());
      }
      return false;
    }
  }
}

final akunRepositoryProvider =
    Provider<AkunRepository>((ref) => AkunRepository(ref));
