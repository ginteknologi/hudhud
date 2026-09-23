import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:masjid_app/configs/remote_data.dart';

class HaditsService extends GetConnect {
  final authStore = GetStorage();

  Future<Map<String, dynamic>?> getBooks() async {
    final response = await http.get(
      Uri.parse("${RemoteData.api}/hadits"),
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

  Future<Map<String, dynamic>?> getList(String data) async {
    final response = await http.get(
      Uri.parse("${RemoteData.api}/hadits/detail/$data"),
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

  Future<Map<String, dynamic>?> getBab(String data, String kitab) async {
    final response = await http.get(
      Uri.parse("${RemoteData.api}/hadits/detail/bab/$kitab?kitab=$data"),
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

  Future<Map<String, dynamic>?> getContent(
    String data,
    String idKitab,
    String idBab,
  ) async {
    final response = await http.get(
      Uri.parse(
        "${RemoteData.api}/hadits/detail/bab/content/$data?ID_Kitab=$idKitab&ID_Bab=$idBab",
      ),
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
