import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:masjid_app/configs/remote_data.dart';

class AuthService extends GetConnect {
  final authStore = GetStorage();

  Future getProfile(userGoogle) async {
    try {
      final response = await http.post(
          Uri.parse("${RemoteData.api}/profile"),
          headers: <String, String>{
            'Authorization': "Bearer ${authStore.read('jwt')}",
            'Content-Type': 'application/json; charset=UTF-8',
          },
        body: jsonEncode(<String, dynamic>{
          'name': userGoogle['name'],
          'email': userGoogle['email'],
          'photo': userGoogle['photo'],
        }),);
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
      print('<<<<<<<start>>>>>>>');
      print(e);
    }
  }
}
