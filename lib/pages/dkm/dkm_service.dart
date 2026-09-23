import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:masjid_app/configs/remote_data.dart';
import 'package:masjid_app/models/sosmed_data.dart';

class DkmService extends GetConnect {
  final authStore = GetStorage();

  Future getList() async {
    try {
      final response = await http
          .get(Uri.parse("${RemoteData.api}/sosmed"), headers: <String, String>{
        'Authorization': "Bearer ${authStore.read('jwt')}",
        'Content-Type': 'application/json; charset=UTF-8',
      });
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> data = jsonData['data'];
        final List<SosmedData> newData = data.map((json) {
          return SosmedData.fromJson(json);
        }).toList();
        return newData;
      } else if (response.statusCode == 401) {
        // RemoteData.authError();
      } else {
        final json = jsonDecode(response.body);
        json['code'] = response.statusCode;

        return json;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint("<<<<error service getList sosmed>>>>");
      }
    }
  }
}
