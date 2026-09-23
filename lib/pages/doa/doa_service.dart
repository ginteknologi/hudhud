import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:masjid_app/configs/remote_data.dart';

class DoaService extends GetConnect {
  final authStore = GetStorage();

  Future<Map<String, dynamic>?> getList() async {
    final response = await http.get(
      Uri.parse("${RemoteData.api}/doa/category"),
      headers: <String, String>{
        // 'Authorization': "Bearer ${authStore.read('jwt')}",
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
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

  Future<Map<String, dynamic>?> getListDoa(String category) async {
    final response = await http.get(
      Uri.parse("${RemoteData.api}/doa/list/$category"),
      headers: <String, String>{
        // 'Authorization': "Bearer ${authStore.read('jwt')}",
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
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

  Future<Map<String, dynamic>?> getListSearchDoa(
    String category,
    String search,
  ) async {
    if (kDebugMode) {
      debugPrint("${RemoteData.api}/doa/list/$category?search=$search");
    }
    final response = await http.get(
      Uri.parse("${RemoteData.api}/doa/list/$category?search=$search"),
      headers: <String, String>{
        // 'Authorization': "Bearer ${authStore.read('jwt')}",
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
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

  Future<Map<String, dynamic>?> getDetail() async {
    if (kDebugMode) {
      debugPrint(Get.parameters['content']);
    }
    final response = await http.get(
      Uri.parse("${RemoteData.api}/doa/detail/${Get.parameters['content']}"),
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
}
