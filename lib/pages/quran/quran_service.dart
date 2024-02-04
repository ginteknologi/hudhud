import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:masjid_app/configs/remote_data.dart';

class QuranService extends GetConnect {
  final authStore = GetStorage();

  Future getList(search) async {
    try {
    final response = await http.get(
        Uri.parse("${RemoteData.api}/quran/surah?search=$search"),
        headers: <String, String>{
          // 'Authorization': "Bearer ${authStore.read('jwt')}",
          'Content-Type': 'application/json; charset=UTF-8',
        });
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      json['code'] = response.statusCode;
      return json;
    } else if (response.statusCode == 401) {
      // RemoteData.authError();
    } else {
      final json = jsonDecode(response.body);
      json['code'] = response.statusCode;
      
      return json;
    }
    } catch (e) {
      print('<<<<<<<<<<<<erorr quran service>>>>>>>>>>>>');
      print(e);
    }
  }
  Future getDetail(id) async {
    final response = await http.get(
        Uri.parse("${RemoteData.api}/quran/surah/$id"),
        headers: <String, String>{
          // 'Authorization': "Bearer ${authStore.read('jwt')}",
          'Content-Type': 'application/json; charset=UTF-8',
        });
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      json['code'] = response.statusCode;
      return json;
    } else if (response.statusCode == 401) {
      // RemoteData.authError();
    } else {
      final json = jsonDecode(response.body);
      json['code'] = response.statusCode;
      
      return json;
    }
  }
}
