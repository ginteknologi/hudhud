import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:masjid_app/configs/remote_data.dart';

class EventCountDownService {
  static Future getData({
    tahun,
    bulan,
  }) async {
    final apiUrl = '${RemoteData.api}/event';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final data = jsonData['data'];
        return data;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      if (kDebugMode) {
        debugPrint("error di service");
      }
      if (kDebugMode) {
        debugPrint(error.toString());
      }
      // Handle general error
      rethrow;
    }
  }
}
