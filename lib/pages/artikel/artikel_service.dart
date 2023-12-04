import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:masjid_app/configs/remote_data.dart';

class ArtikelService extends GetConnect {
  final authStore = GetStorage();

  Future getListTag() async {
    final response = await http.get(
        Uri.parse("${RemoteData.apiWp}/tags?_fields=id,name"),
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
  Future getListArtikel() async {
    final response = await http.get(
        Uri.parse("${RemoteData.apiWp}/posts?categories=30&_embed=wp:featuredmedia&_fields=id,excerpt,title,date,categories,_links.wp:featuredmedia,_embedded"),
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
  Future getListArtikellain() async {
    final response = await http.get(
        Uri.parse("${RemoteData.apiWp}/posts?exclude[0]=${Get.parameters['id']}&categories=30&_embed=wp:featuredmedia&_fields=id,excerpt,title,date,categories,_links.wp:featuredmedia,_embedded"),
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
  Future getDetailArtikel() async {
    final response = await http.get(
        Uri.parse("${RemoteData.apiWp}/posts/${Get.parameters['id']}?categories=30&_embed=wp:featuredmedia&_fields=id,excerpt,title,date,categories,content,_links.wp:featuredmedia,_embedded"),
        headers: <String, String>{
          // 'Authorization': "Bearer ${authStore.read('jwt')}",
          'Content-Type': 'application/json; charset=UTF-8',
        });
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      // json['code'] = response.statusCode;
      // print(json);
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
