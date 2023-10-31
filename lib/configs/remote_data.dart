import 'package:get_storage/get_storage.dart';

final authStore = GetStorage();

class RemoteData {
  static const String api = "http://192.168.1.99:3000/api/v1";
  static const String quran = "http://192.168.1.99:3787/";

  // static const String api = "http://103.174.115.34:7714/api/office/apps";
}
