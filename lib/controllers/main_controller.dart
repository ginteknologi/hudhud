import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:masjid_app/models/bookmarkData.dart';
import 'package:masjid_app/models/lokasiSayaData.dart';
import 'package:masjid_app/storage/lokasiSaya_storage.dart';
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
  var userLogin = {}.obs;

  Rx<LokasiSayaData> mylokasi =
      LokasiSayaData(keteranganLokasi: "Belum ada lokasi", lat: 0.0, long: 0.0)
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
    dataStore.write('isLogin', true);
    dataStore.write('userLogin', json);
    isLogin.value = true;
    userLogin.value = json;
  }

  removeStorage() async {
    dataStore.remove('userLogin');
    dataStore.remove('isLogin');
    isLogin.value = false;
    userLogin.value = {};
  }

  getCacheLokasi() async {
    try {
      var lokasiSaatIni = lokasiStorage.getLokasi();

      print("getwaktusolat 0 long main: ${lokasiSaatIni.long}");
      print("getwaktusolat 0 lat main: ${lokasiSaatIni.lat}");
      if (lokasiSaatIni.long == 0.0 || lokasiSaatIni.lat == 0.0) {
        var statusLokasi = await Permission.location.request();
        if (statusLokasi.isGranted) {
          Position position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high);
          var ket = "";
          List<Placemark> placemarks;

          try {
            placemarks = await placemarkFromCoordinates(
                position.latitude, position.longitude);
          } catch (e) {
            print('error placemarkFromCoordinates');
            placemarks = [];
          }

          if (placemarks.length > 0) {
            Placemark place = placemarks[0];
            ket = "${place.locality.toString()}, ${place.country.toString()}";
          } else {
            ket = "Lokasi Tidak Ditemukan";
          }
          mylokasi.value = LokasiSayaData(
            keteranganLokasi: ket,
            lat: position.latitude,
            long: position.longitude,
          );
          print("getwaktusolat 1 main: ${mylokasi.value.keteranganLokasi}");
          print("getwaktusolat 1 main: ${position.latitude}");
          print("getwaktusolat 1 main: ${position.longitude}");
          lokasiStorage.saveLokasi(mylokasi.value);
        } else if (statusLokasi.isDenied) {
          mylokasi.value = LokasiSayaData(
              keteranganLokasi: "Silahkan mengaktifkan izin lokasi",
              lat: 0,
              long: 0,
              gpsizin: false);

          lokasiStorage.saveLokasi(mylokasi.value);
          print("getwaktusolat 3 main: ${mylokasi.value.keteranganLokasi}");
          print("getwaktusolat 3 main: ${mylokasi.value.lat}");
          print("getwaktusolat 3 main: ${mylokasi.value.long}");
        }
      } else {
        mylokasi.value = lokasiSaatIni;

        print("getwaktusolat 4 main: ${mylokasi.value.keteranganLokasi}");
        print("getwaktusolat 4 main: ${mylokasi.value.lat}");
        print("getwaktusolat 4 main: ${mylokasi.value.long}");
      }
      isloadingCache.value = false;
    } catch (e) {
      print("error cache lokasi");
      mylokasi.value = LokasiSayaData(
          keteranganLokasi: "aktifkan izin lokasi",
          lat: 0,
          long: 0,
          gpsizin: false);
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
