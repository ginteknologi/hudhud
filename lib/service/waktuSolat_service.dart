import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:masjid_app/configs/remote_data.dart';
import 'package:masjid_app/models/waktu_solat_data.dart';

class WaktuSolatService {
  static Future<List<WaktuSolatData>> getList({
    double? lat,
    double? long,
  }) async {
    try {
      var query = [];
      if (lat != null && long != null) {
        if (lat != 0.0 && long != 0.0) {
          query = [
            "latitude=$lat",
            "longitude=$long",
          ];
        }
      }
      final response = await http.get(
          Uri.parse("${RemoteData.api}/waktusolat/list?${query.join("&")}"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> data = jsonData['data'];
        final List<WaktuSolatData> newData = data.map((json) {
          return WaktuSolatData.fromJson(json);
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
      // Handle general error
      rethrow;
    }
  }
}
