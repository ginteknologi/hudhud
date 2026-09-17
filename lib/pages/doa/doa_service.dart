import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:masjid_app/configs/remote_data.dart';

class DoaService extends GetConnect {
  final authStore = GetStorage();

  Future getList() async {
    final response = await http.get(
        Uri.parse("${RemoteData.api}/doa/category"),
        headers: <String, String>{
          // 'Authorization': "Bearer ${authStore.read('jwt')}",
          'Content-Type': 'application/json; charset=UTF-8',
        });
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      // json['code'] = response.statusCode;
      return json;
    } else if (response.statusCode == 401) {
      // RemoteData.authError();
    } else {
      final json = jsonDecode(response.body);
      json['code'] = response.statusCode;
      return json;
    }
  }
  Future getListDoa(category) async {
    final response = await http.get(
        Uri.parse("${RemoteData.api}/doa/list/$category"),
        headers: <String, String>{
          // 'Authorization': "Bearer ${authStore.read('jwt')}",
          'Content-Type': 'application/json; charset=UTF-8',
        });
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      // json['code'] = response.statusCode;
      return json;
    } else if (response.statusCode == 401) {
      // RemoteData.authError();
    } else {
      final json = jsonDecode(response.body);
      json['code'] = response.statusCode;
      return json;
    }
  }
  Future getListSearchDoa(category, search) async {
    print("${RemoteData.api}/doa/list/$category?search=$search");
    final response = await http.get(
        Uri.parse("${RemoteData.api}/doa/list/$category?search=$search"),
        headers: <String, String>{
          // 'Authorization': "Bearer ${authStore.read('jwt')}",
          'Content-Type': 'application/json; charset=UTF-8',
        });
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      // json['code'] = response.statusCode;
      return json;
    } else if (response.statusCode == 401) {
      // RemoteData.authError();
    } else {
      final json = jsonDecode(response.body);
      json['code'] = response.statusCode;
      return json;
    }
  }
  Future getDetail() async {
    print(Get.parameters['content']);
    final response = await http.get(
        Uri.parse("${RemoteData.api}/doa/detail/${Get.parameters['content']}"),
        headers: <String, String>{
          'Authorization': "Bearer ${authStore.read('jwt')}",
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
