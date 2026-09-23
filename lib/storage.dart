import 'package:get_storage/get_storage.dart';

class AppStorage {
  final authStore = GetStorage();
  Map<String, dynamic> get(id) {
    try {
      var result = authStore.read(id);
      if (result == null) {
        throw "empty";
      }
      var json = {
        "code": 200,
        "message": "Success.",
        "data": result,
      };
      return json;
    } catch (_) {
      var json = {
        "code": 404,
        "message": "Not found.",
        "data": [],
      };
      return json;
    }
  }

  Map<String, Object> write(id, data) {
    authStore.write(id, data);
    var json = {
      "code": 200,
      "message": "Success",
      "data": [],
    };
    return json;
  }

  Map<String, Object> remove(id) {
    authStore.remove(id);
    var json = {
      "code": 200,
      "message": "Success.",
      "data": [],
    };
    return json;
  }
}
