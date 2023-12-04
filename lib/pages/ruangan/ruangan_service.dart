import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:masjid_app/configs/remote_data.dart';

class RuanganService extends GetConnect {
  final authStore = GetStorage();

  Future getList() async {
    final response = await http.get(
        Uri.parse("${RemoteData.api}/ruangan/booking"),
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
  Future getDetail(tanggal,bulan, tahun) async {
    final response = await http.get(
        Uri.parse("${RemoteData.api}/ruangan/booking?tanggal=$tanggal&bulan=$bulan&tahun=$tahun"),
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
 Future postData(input) async {
  print(input['']);
    var api = '${RemoteData.api}/ruangan/booking';
    final response = await http.post(
      Uri.parse(api),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'tanggal': input['tanggal'],
        'jam_mulai': input['jam_mulai'],
        'jam_selesai': input['jam_selesai'],
        'nama_kegiatan': input['nama_kegiatan'],
        'nama_pemesan': input['nama_pemesan'],
        'permintaan_khusus': input['permintaan_khusus'],
        'kontak_pemesan': input['kontak_pemesan'],
      }),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return jsonDecode(jsonEncode(json));
    }
  }
}
