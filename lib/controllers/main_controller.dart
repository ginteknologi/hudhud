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

  loadHistoryQuran() async {
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

  logout() async {
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

  updateLokasi({required ketLokasi, required lat, required long}) async {
    mylokasi.value = LokasiSayaData(
      keteranganLokasi: ketLokasi,
      lat: lat,
      long: long,
    );
    // lokasiSaatIni = ketLokasi;
  }

  saveStorage(json) async {
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

  removeStorage() async {
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

  getCacheLokasi() async {
    try {
      // 1. Ambil data terakhir dari cache dulu (sebagai fallback cepat)
      var lokasiTerakhir = lokasiStorage.getLokasi();
      mylokasi.value = lokasiTerakhir;
      
      // 2. Cek izin lokasi
      var statusLokasi = await Permission.location.status;
      
      // 3. Jika diizinkan, coba ambil lokasi terbaru (Proaktif)
      if (statusLokasi.isGranted) {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
            
        var ket = "";
        List<Placemark> placemarks;
        try {
          placemarks = await placemarkFromCoordinates(
              position.latitude, position.longitude);
          if (placemarks.isNotEmpty) {
            Placemark place = placemarks[0];
            ket = "${place.locality.toString()}, ${place.country.toString()}";
          } else {
            ket = "Lokasi Ditemukan";
          }
        } catch (e) {
          ket = "Lokasi Terdeteksi";
        }

        // Update data terbaru
        mylokasi.value = LokasiSayaData(
          keteranganLokasi: ket,
          lat: position.latitude,
          long: position.longitude,
          gpsizin: true,
        );
        
        // Simpan ke cache
        lokasiStorage.saveLokasi(mylokasi.value);
        print("Lokasi otomatis terupdate: ${mylokasi.value.keteranganLokasi}");
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
