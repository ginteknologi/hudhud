import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:masjid_app/configs/remote_data.dart';

class NotifikasiService extends GetConnect {
  final authStore = GetStorage();

  Future<Map<String, dynamic>?> getList() async {
    final dataUser = authStore.read('userLogin') as Map<String, dynamic>;
    final response = await http.get(
        Uri.parse("${RemoteData.api}/notif/${dataUser['id']}"),
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
      return null;
    } else {
      final json = jsonDecode(response.body);
      json['code'] = response.statusCode;

      return json;
    }
  }
  Future<Map<String, dynamic>?> getDetail(dynamic id) async {
    final response = await http.get(
        Uri.parse("${RemoteData.api}/notif/detail/$id"),
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
      return null;
    } else {
      final json = jsonDecode(response.body);
      json['code'] = response.statusCode;

      return json;
    }
  }
  Future<Map<String, dynamic>?> getDetailInvoice(dynamic id) async {
    final response = await http.get(
        Uri.parse("${RemoteData.api}/transaksi/detail/invoice/$id"),
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
      return null;
    } else {
      final json = jsonDecode(response.body);
      json['code'] = response.statusCode;

      return json;
    }
  }
}
