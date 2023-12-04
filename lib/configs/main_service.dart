import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:masjid_app/configs/remote_data.dart';
import 'package:google_sign_in/google_sign_in.dart';

class MainService extends GetConnect {
  final authStore = GetStorage();

  Future waktuSolat() async {
    final response = await http.get(Uri.parse("${RemoteData.api}/waktusolat"),
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
}

class GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;

  final http.Client _client = http.Client();

  GoogleAuthClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _client.send(request..headers.addAll(_headers));
  }
}

class GoogleLogin {
  googleSignIn() async {
    try {
      var status = {
        "code": 400,
        "message": "Mohon cek kembali koneksi anda.",
        "data": {}
      };
      GoogleSignIn google = GoogleSignIn.standard(
          scopes: ['email', "https://www.googleapis.com/auth/userinfo.profile"]);
      await google.signIn().then((account) async {
        if (account != null) {
          var auth = await google.currentUser?.authHeaders;
          var userLogin = {
            "id": account.id,
            "name": account.displayName,
            "email": account.email,
            "photo": account.photoUrl,
            "bearer": auth?['Authorization'],
          };
          status = {"code": 200, "message": "Login berhasil.", "data": userLogin};
        }
      });
      return status;
    } catch (e) {
      print('<<<<<<<<<<Start Google SignIn>>>>>>>>>>');
      print(e);
      print('<<<<<<<<<<End Google SignIn>>>>>>>>>>');
    }
  }

  googleSignOut() async {
    var status = {"code": 200, "message": "Anda berhasil keluar."};
    await GoogleSignIn().disconnect();
    return status;
  }
}
