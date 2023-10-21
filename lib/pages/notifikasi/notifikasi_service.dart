import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mesjid_app/configs/remote_data.dart';

class NotifikasiService extends GetConnect {
  final authStore = GetStorage();

  Future getList(
      {required page, required limit, status = "", priority = ""}) async {
    final response = await http.get(
        Uri.parse("${RemoteData.api}doa?page=$page&limit=$limit"),
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
