import 'dart:convert';
import 'package:masjid_app/core/storage/preferences_service.dart';

class AppStorage {
  Map<String, dynamic> get(dynamic id) {
    try {
      final key = id.toString();
      final str = PreferencesService.getString(key);
      if (str == null) {
        throw "empty";
      }
      final dynamic result = jsonDecode(str);
      return {
        "code": 200,
        "message": "Success.",
        "data": result,
      };
    } catch (_) {
      return {
        "code": 404,
        "message": "Not found.",
        "data": [],
      };
    }
  }

  Map<String, Object> write(dynamic id, dynamic data) {
    final key = id.toString();
    PreferencesService.setString(key, jsonEncode(data));
    return {
      "code": 200,
      "message": "Success",
      "data": [],
    };
  }

  Map<String, Object> remove(dynamic id) {
    final key = id.toString();
    PreferencesService.remove(key);
    return {
      "code": 200,
      "message": "Success.",
      "data": [],
    };
  }
}
