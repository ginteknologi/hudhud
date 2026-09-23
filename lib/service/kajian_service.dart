import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:masjid_app/configs/remote_data.dart';
import 'package:masjid_app/models/kajian_data.dart';

class KajianService {
  static Future<List<KajianData>> getListKajian(
      {type, pageKey = 0, pageSize = 20}) async {
    try {
      final response = await http.get(
          Uri.parse(
              "${RemoteData.api}/kajian/list?page=$pageKey&limit=$pageSize&type=$type"),
          headers: <String, String>{
            'Authorization': "Bearer ${authStore.read('jwt')}",
            'Content-Type': 'application/json; charset=UTF-8',
          });
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> data = jsonData['data'];
        final List<KajianData> newData = data.map((json) {
          return KajianData.fromJson(json);
        }).toList();
        return newData;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      if (kDebugMode) {
        debugPrint("error di service");
      }
      if (kDebugMode) {
        debugPrint(error.toString());
      }
      rethrow;
    }
  }
}
