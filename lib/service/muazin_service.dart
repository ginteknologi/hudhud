import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:masjid_app/configs/remote_data.dart';
import 'package:masjid_app/models/kajian_data.dart';

class MuazinService {
  static Future getMuadzin({pageKey, pageSize}) async {
    final response = await http.get(
        Uri.parse(
            "${RemoteData.api}/kajian/list?page=$pageKey&limit=$pageSize&type=muadzin"),
        headers: <String, String>{
          'Authorization': "Bearer ${authStore.read('jwt')}",
          'Content-Type': 'application/json; charset=UTF-8',
        });
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> data = jsonData['data'];
      final List<KajianData> newData = data.map((json) {
        return KajianData.fromJson(json);
      }).toList();
      return newData;
    } else if (response.statusCode == 401) {
    } else {
      final json = jsonDecode(response.body);
      json['code'] = response.statusCode;

      return json;
    }
  }
}
