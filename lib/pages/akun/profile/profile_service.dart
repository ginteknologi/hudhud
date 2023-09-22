import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mesjid_app/configs/remote_data.dart';

class ProfileService extends GetConnect {
  final authStore = GetStorage();

    Future setToken(token) async {
    final response = await http.post(Uri.parse("${RemoteData.api}/fcm/set"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': "Bearer ${authStore.read('jwt')}",
        },
        body: jsonEncode({"token": token}));
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
