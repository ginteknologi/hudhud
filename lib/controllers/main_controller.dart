import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:masjid_app/models/bookmarkData.dart';
import 'package:masjid_app/models/lokasiSayaData.dart';
import 'package:masjid_app/models/userData.dart';
import 'package:masjid_app/storage/lokasiSaya_storage.dart';
import 'package:masjid_app/storage/quran_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:masjid_app/routes/auth/index.dart';
import 'package:just_audio/just_audio.dart';

enum DialogPopupInfaq { subuh, pagi }

class MainController extends GetxController {
  final lokasiStorage = LokasiStorage();
  final player = AudioPlayer();
  final dataStore = GetStorage();

  var isLogin = false.obs;
  var isloadingCache = true.obs;
  Rx<UserData> userLogin = Rx(UserData(
    id: 0,
    nama: "Guest",
    email: "guest",
    photo: "https://nos.wjv-1.neo.id/marbot/assets/app_icon.png",
    total_sedekah: 0,
  ));

  Rx<LokasiSayaData> mylokasi = LokasiSayaData(
          keteranganLokasi: "Belum ada lokasi",
          lat: -6.195438799475241,
          long: 106.82264795337655)
      .obs;

  Rx<bookmarkData> ayatBookmark = bookmarkData(
          namaSurat: "Belum ada bookmark", surat: 0, ayat: 0, totalAyat: 0)
      .obs;
  Rx<bookmarkData> indonesiaBookmark = bookmarkData(
          namaSurat: "Belum ada bookmark", surat: 0, ayat: 0, totalAyat: 0)
      .obs;
  Rx<bookmarkData> madinahBookmark = bookmarkData(
          namaSurat: "Belum ada bookmark", surat: 0, ayat: 0, totalAyat: 0)
      .obs;
  Rx<bookmarkData> tajwidBookmark = bookmarkData(
          namaSurat: "Belum ada bookmark", surat: 0, ayat: 0, totalAyat: 0)
      .obs;

  var perAyatLastRead = {}.obs;
  var indonesiaLastRead = {}.obs;
  var tajwidLastRead = {}.obs;
  var madinahLastRead = {}.obs;

  TextEditingController inputFilter = TextEditingController();

  Future loadStorage() async {
    try {
      isLogin.value = dataStore.read('isLogin');
      if (isLogin.isTrue) {
        userLogin.value = dataStore.read('userLogin');
      }
    } catch (e) {
      print(e);
      dataStore.write('isLogin', false);
      isLogin.value = false;
    }
  }

  Future<void> loadHistoryQuran() async {
    try {
      if (dataStore.read('perAyatLastRead') == null) {
        dataStore.write('perAyatLastRead', {
          'id': 0,
          'suratName': '',
          'ayatNumber': 0,
          'audio': 'ar.alafasy',
          'audiosource': 'server'
        });
      }
      if (dataStore.read('indonesiaLastRead') == null) {
        dataStore.write('indonesiaLastRead', {'id': 0, 'surat': '', 'hal': 0});
      }
      if (dataStore.read('tajwidLastRead') == null) {
        dataStore.write('tajwidLastRead', {'id': 0, 'surat': '', 'hal': 0});
      }
      if (dataStore.read('madinahLastRead') == null) {
        dataStore.write('madinahLastRead', {'id': 0, 'surat': '', 'hal': 0});
      }
      // perAyatLastRead.value = dataStore.read('perAyatLastRead');
      indonesiaLastRead.value = dataStore.read('indonesiaLastRead');
      tajwidLastRead.value = dataStore.read('tajwidLastRead');
      madinahLastRead.value = dataStore.read('madinahLastRead');
    } catch (e) {
      print(e);
    }
  }

  Future<void> logout() async {
    try {
      dataStore.remove('userLogin');
      dataStore.remove('isLogin');

      lokasiStorage.removeLokasi();
      QuranStorage().removeQuranHistory();

      isLogin.value = false;
      Get.offAllNamed(RoutesAuth.root);
    } catch (e) {
      print(e);
      print('gk ada session');
    }
  }

  /// Ambil nama lokasi dari koordinat.
  /// geocoding 5.x: method bukan lagi top-level function, tapi method
  /// dari instance `Geocoding`. Mengembalikan null jika gagal.
  Future<String?> _reverseGeocode(double lat, double long) async {
    try {
      List<Placemark> placemarks =
          await Geocoding().placemarkFromCoordinates(lat, long);
      if (placemarks.isEmpty) return null;

      Placemark place = placemarks[0];
      var namaLokasi = [
        place.locality ?? '',
        place.country ?? '',
      ].where((e) => e.isNotEmpty).join(', ');

      return namaLokasi.isEmpty ? null : namaLokasi;
    } catch (e) {
      print("<<<<<<<< error reverse geocoding >>>>>>>>");
      print(e);
      return null;
    }
  }

  /// Simpan hasil geolokasi terbaru ke state + cache.
  void _setLokasiTerbaru(Position position, String keterangan) {
    mylokasi.value = LokasiSayaData(
      keteranganLokasi: keterangan,
      lat: position.latitude,
      long: position.longitude,
      gpsizin: true,
    );
    lokasiStorage.saveLokasi(mylokasi.value);
    print("Lokasi otomatis terupdate: ${mylokasi.value.keteranganLokasi}");
  }

  Future<void> updateLokasi({required ketLokasi, required lat, required long}) async {
    mylokasi.value = LokasiSayaData(
      keteranganLokasi: ketLokasi,
      lat: lat,
      long: long,
    );
    lokasiStorage.saveLokasi(mylokasi.value);
  }

  Future<void> saveStorage(json) async {
    try {
      dataStore.write('isLogin', true);
      dataStore.write('userLogin', json);
      isLogin.value = true;
      userLogin.value = UserData(
        id: json['id'],
        nama: json['nama'],
        email: json['email'],
        photo: json['photo'] ??
            'https://nos.wjv-1.neo.id/marbot/assets/app_icon.png',
        total_sedekah: json['total_sedekah'],
        phone: json['phone'],
      );
    } catch (e) {
      print('<<<error saveStorage main_controller>>>');
      print(e);
    }
  }

  Future<void> removeStorage() async {
    dataStore.remove('userLogin');
    dataStore.write('isLogin', false);
    isLogin.value = false;
    userLogin.value = UserData(
      id: 0,
      nama: "Guest",
      email: "guest",
      photo: "https://nos.wjv-1.neo.id/marbot/assets/app_icon.png",
      total_sedekah: 0,
    );
  }

  Future<void> getCacheLokasi() async {
    try {
      // 1. Ambil data terakhir dari cache dulu (sebagai fallback cepat)
      var lokasiTerakhir = lokasiStorage.getLokasi();
      mylokasi.value = lokasiTerakhir;
      
      // 2. Cek izin lokasi
      var statusLokasi = await Permission.location.status;
      
      // 3. Jika diizinkan, coba ambil lokasi terbaru (Proaktif)
      if (statusLokasi.isGranted) {
        // geolocator 14.x: pakai parameter `locationSettings`,
        // `desiredAccuracy` sudah deprecated.
        Position position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            timeLimit: Duration(seconds: 20),
          ),
        );

        // Reverse geocoding dipisah, kalau gagal kita tetap simpan
        // koordinatnya dengan keterangan fallback.
        var ket = await _reverseGeocode(position.latitude, position.longitude) ??
            "Lokasi Terdeteksi";

        _setLokasiTerbaru(position, ket);
      } else if (statusLokasi.isDenied) {
        // Izin ditolak: tetap pakai cache, tapi tandai gps belum aktif.
        mylokasi.value = LokasiSayaData(
          keteranganLokasi: mylokasi.value.keteranganLokasi,
          lat: mylokasi.value.lat,
          long: mylokasi.value.long,
          gpsizin: false,
        );
      }
      
      isloadingCache.value = false;
    } catch (e) {
      print("error getCacheLokasi: $e");
      // Jika error (misal GPS mati), pastikan loading berhenti agar UI tampil
      isloadingCache.value = false;
    }
  }

  @override
  void onInit() async {
    super.onInit();
    await loadStorage();
    await player.setUrl(// Load a URL
        'https://cdn.islamic.network/quran/audio/64/ar.alafasy/1.mp3'); // Schemes: (https: | file: | asset: )
    player.play();

    await getCacheLokasi();
    // await waktusolatData();
    // await getWaktu();
    // await startWaktu();
    await loadHistoryQuran();
  }
}
