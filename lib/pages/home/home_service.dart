import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:masjid_app/configs/remote_data.dart';

class HomeService extends GetConnect {
  final authStore = GetStorage();

  // Future getList(
  //   {required page, required limit, status = "", priority = ""}) async {
  //   final response = await http.get(
  //       Uri.parse("${RemoteData.api}home?page=$page&limit=$limit"),
  //       headers: <String, String>{
  //         'Authorization': "Bearer ${authStore.read('jwt')}",
  //         'Content-Type': 'application/json; charset=UTF-8',
  //       });
  //   if (response.statusCode == 200) {
  //     final json = jsonDecode(response.body);
  //     json['code'] = response.statusCode;
  //     return json;
  //   } else if (response.statusCode == 401) {
  //     // RemoteData.authError();
  //   } else {
  //     final json = jsonDecode(response.body);
  //     json['code'] = response.statusCode;

  //     return json;
  //   }
  // }

  Future cekToken(token) async {
    final dataUser = authStore.read('userLogin') as Map<String, dynamic>;
    var api = '${RemoteData.api}/fcm?token=$token&user=${dataUser['id']}';
    final response = await http.get(Uri.parse(api));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return jsonDecode(jsonEncode(json));
    }
  }

  Future setToken(token) => cekToken(token).then((hasilcek) async {
        try {
          final dataUser = authStore.read('userLogin') as Map<String, dynamic>;
          if (hasilcek['data'].length > 0) {
            var api = '${RemoteData.api}/fcm/${hasilcek['data'][0]['id']}';
            final response = await http.put(
              Uri.parse(api),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(<String, dynamic>{
                'user': dataUser['id'],
                'token': token,
              }),
            );
            return response;
          } else {
            var api = '${RemoteData.api}/fcm';
            final response = await http.post(
              Uri.parse(api),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(<String, dynamic>{
                'user': dataUser['id'],
                'token': token,
              }),
            );
            print('<<<<<<<<<response>>>>>>>>>');
            return response;
          }
        } catch (e) {
          print("<<<<<<Error SetToken Service>>>>>>");
          print(e);
        }
      });
}
