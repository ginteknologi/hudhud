import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:masjid_app/configs/remote_data.dart';

class AkunService extends GetConnect {
  final authStore = GetStorage();

  Future<Map<String, dynamic>?> getList({
    required int page,
    required int limit,
    String status = "",
    String priority = "",
  }) async {
    final response = await http.get(
      Uri.parse("${RemoteData.api}akun?page=$page&limit=$limit"),
      headers: <String, String>{
        'Authorization': "Bearer ${authStore.read('jwt')}",
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      json['code'] = response.statusCode;
      return json;
    } else if (response.statusCode == 401) {
      // RemoteData.authError();
      return null;
    } else {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      json['code'] = response.statusCode;
      return json;
    }
  }

  Future<Map<String, dynamic>?> postProfile(
    String id,
    String nama,
    String phone,
    String photo,
  ) async {
    try {
      final response = await http.put(
        Uri.parse("${RemoteData.api}/profile/$id"),
        headers: <String, String>{
          'Authorization': "Bearer ${authStore.read('jwt')}",
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "nama": nama,
          "phone": phone,
          "photo": photo,
        }),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        json['code'] = response.statusCode;
        return json;
      } else if (response.statusCode == 401) {
        // RemoteData.authError();
        return null;
      } else {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        json['code'] = response.statusCode;
        return json;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('<<error postProfile>>');
        debugPrint(e.toString());
      }
      return null;
    }
  }
}
