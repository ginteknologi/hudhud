import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:masjid_app/configs/remote_data.dart';
import 'package:masjid_app/models/sedangLiveData.dart';

class DashboardService extends GetConnect {
  final authStore = GetStorage();

  Future getListArtikelBaru() async {
    final response = await http.get(
        Uri.parse("${RemoteData.api}/artikel/terbaru"),
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

  Future getSliderKajian(type) async {
    final response = await http.get(
        Uri.parse("${RemoteData.api}/kajian/slider?type=$type"),
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

  Future getListKajian(type) async {
    print(type);
    final response = await http.get(
        Uri.parse("${RemoteData.api}/kajian/list?type=$type"),
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

  Future<List<SedangLiveData>> getSedangLive(
      {pageKey = 0, pageSize = 20}) async {
    try {
      final response = await http
          .get(Uri.parse("${RemoteData.api}/live"), headers: <String, String>{
        'Authorization': "Bearer ${authStore.read('jwt')}",
        'Content-Type': 'application/json; charset=UTF-8',
      });
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> data = jsonData['data'];
        final List<SedangLiveData> newData = data.map((json) {
          return SedangLiveData.fromJson(json);
        }).toList();
        return newData;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print("error di service getSedangLive");
      print(error);
      throw error;
    }
  }
}
