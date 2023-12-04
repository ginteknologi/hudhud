import 'dart:convert';

import 'package:masjid_app/configs/remote_data.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class TransaksiSedekahServices extends GetConnect {
  final json = {
    "success": false,
    "message": "Mohon cek kembali koneksi anda.",
    "data": {},
  };

  Future getData() async {
    var api = '${RemoteData.api}/transaksi/list_payment';
    final response = await http.get(Uri.parse(api));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return jsonDecode(jsonEncode(json));
    }
  }

  Future postData() async {
    var api = '${RemoteData.api}/transaksi/order';
    final input = authStore.read('inputDataPembayaran');
    final response = await http.post(
      Uri.parse(api),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'name': input['nama'],
        'email': input['email'],
        'phone': input['nomor'],
        'metode': input['metode'],
        'anonim': input['anonim'],
        'pesan': input['pesan'],
        'nominal': input['nominal'],
        'paymentMethod': input['idPayment'],
        // 'phoneovo': input['phoneovo'],
      }),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return jsonDecode(jsonEncode(json));
    }
  }

  Future getDataInvoice(invoice) async {
    var api = '${RemoteData.api}/transaksi/detail/$invoice';
    // var api = '${RemoteData.api}/transaksi/detail/INV-MA-CxTxrlv';
    final response = await http.get(Uri.parse(api));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return jsonDecode(jsonEncode(json));
    }
  }
}
