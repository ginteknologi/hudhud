import 'package:flutter/foundation.dart';
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

  Future<Map<String, dynamic>> cekToken(String token) async {
    final dataUser = authStore.read('userLogin') as Map<String, dynamic>;
    var api = '${RemoteData.api}/fcm?token=$token&user=${dataUser['id']}';
    final response = await http.get(Uri.parse(api));
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      return <String, dynamic>{};
    }
  }

  Future<http.Response?> setToken(String token) =>
      cekToken(token).then((hasilCek) async {
        try {
          final dataUser = authStore.read('userLogin') as Map<String, dynamic>;
          if (hasilCek['data'] != null &&
              (hasilCek['data'] as List).isNotEmpty) {
            final api = '${RemoteData.api}/fcm/${hasilCek['data'][0]['id']}';
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
            final api = '${RemoteData.api}/fcm';
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
            if (kDebugMode) {
              debugPrint('<<<<<<<<<response>>>>>>>>>');
            }
            return response;
          }
        } catch (e) {
          if (kDebugMode) {
            debugPrint("<<<<<<Error SetToken Service>>>>>>");
            debugPrint(e.toString());
          }
          return null;
        }
      });
}
