import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:masjid_app/configs/remote_data.dart';

class KalenderdzulhijjahService {
  static Future getData({
    tahun,
    bulan,
  }) async {
    final apiUrl = '${RemoteData.api}/waktusolat/kalender';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> data = jsonData['data'];
        return data;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print("error di service");
      print(error);
      // Handle general error
      rethrow;
    }
  }
}
