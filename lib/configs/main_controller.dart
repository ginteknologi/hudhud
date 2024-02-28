import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:masjid_app/configs/main_service.dart';
import 'package:masjid_app/models/bookmarkData.dart';
import 'package:masjid_app/models/lokasiSayaData.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:simple_moment/simple_moment.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:masjid_app/routes/auth/index.dart';

enum DialogPopupInfaq { subuh, pagi }

class MainController extends GetxController {
  final dataStore = GetStorage();
  var isLogin = false.obs;
  var userLogin = {}.obs;

  Rx<LokasiSayaData> mylokasi =
      LokasiSayaData(keteranganLokasi: "Belum ada lokasi", lat: 0.0, lang: 0.0)
          .obs;

  Rx<bookmarkData> ayatBookmark = bookmarkData(
          namaSurat: "Belum ada bookmark", surat: 0, ayat: 0, totalAyat: 0)
      .obs;

  var perAyatLastRead = {}.obs;
  var indonesiaLastRead = {}.obs;
  var tajwidLastRead = {}.obs;
  var madinahLastRead = {}.obs;
  var imsak = "".obs;
  var berbuka = "".obs;
  //  ============ data dialog infaq
  var showPopupInfaq = true.obs;
  DialogPopupInfaq dialogPopupInfaq = DialogPopupInfaq.subuh;
  // ============ end data dialog infaq

  // ============ data waktu Solat
  var loadingwaktusolat = true.obs;
  var todayDate = "".obs;
  var dataTerbaru = {}.obs;
  var duration = 0.obs;
  var txttime = "".obs;
  var listWaktu = [].obs;
  var HijriDate = '';
  // DateTime hijriDate ;
  // ============ end data waktu Solat

  //  ============ data dialog filter
  var selectedJuz = true.obs;
  var loadingFilter = false.obs;
  TextEditingController inputFilter = TextEditingController();
  //  ============ end data dialog filter

  Future<void> waktusolatData() async {
    try {
      var hijriDateNow = HijriCalendar.now();
      HijriDate = hijriDateNow.toFormat('MMMM dd yyyy');
      final getdata = await MainService().waktuSolat();

      listWaktu.value = [
        {
          "label": "Subuh",
          "waktu": getdata['data']['fajr'],
          "active": false,
          "id": 1,
          "cardImage": "assets/img/card/card_subuh.png"
        },
        {
          "label": "Dzuhur",
          "waktu": getdata['data']['dhuhr'],
          "active": false,
          "id": 2,
          "cardImage": "assets/img/card/card_dzuhur.png"
        },
        {
          "label": "Ashar",
          "waktu": getdata['data']['asr'],
          "active": false,
          "id": 3,
          "cardImage": "assets/img/card/card_ashar.png"
        },
        {
          "label": "Maghrib",
          "waktu": getdata['data']['maghrib'],
          "active": false,
          "id": 4,
          "cardImage": "assets/img/card/card_maghrib.png"
        },
        {
          "label": "Isya",
          "waktu": getdata['data']['isha'],
          "active": false,
          "id": 5,
          "cardImage": "assets/img/card/card_isya.png"
        }
      ];
      DateTime parsedTimeImsak =
          DateFormat('HH:mm').parse(getdata['data']['imsak']);
      String formattedTimeImsak = DateFormat('h:mm a').format(parsedTimeImsak);
      DateTime parsedTimeBerbuka =
          DateFormat('HH:mm').parse(getdata['data']['sunset']);
      String formattedTimeBerbuka =
          DateFormat('h:mm a').format(parsedTimeBerbuka);

      imsak.value = formattedTimeImsak.toString();
      berbuka.value = formattedTimeBerbuka.toString();
      dataStore.write('waktusolat', listWaktu);
    } catch (e) {
      // dataStore.write('isLogin', false);
      isLogin.value = false;
    }
  }

  getWaktu() async {
    var timeleft = DateTime.now();
    todayDate.value =
        Moment.parse("$timeleft").format("EEEE, dd MMMM", localeOverride: 'id');
    int hourminutes = int.parse("${timeleft.hour}${timeleft.minute}");
    var thistime = getNextLargerNumber(hourminutes, listWaktu);
    if (thistime == -1) {
      print(thistime);
      listWaktu[0]['active'] = true;
      var time = listWaktu[0]['waktu'].split(':');
      var setTimeTo = DateTime(timeleft.year, timeleft.month, timeleft.day + 1,
          int.parse(time[0]), int.parse(time[1]));
      duration.value = timesBetween(timeleft, setTimeTo);
    } else {
      for (var el in listWaktu) {
        el['active'] = false;
        if (thistime['id'] == el['id']) {
          el['active'] = true;
          var time = el['waktu'].split(':');
          var setTimeTo = DateTime(timeleft.year, timeleft.month, timeleft.day,
              int.parse(time[0]), int.parse(time[1]));
          duration.value = timesBetween(timeleft, setTimeTo);
        }
      }
    }

    if (timeleft.hour > 6 && timeleft.hour < 10) {
      dialogPopupInfaq = DialogPopupInfaq.pagi;
      showPopupInfaq.value = true;
    } else if (timeleft.hour > 2 && timeleft.hour < 6) {
      dialogPopupInfaq = DialogPopupInfaq.subuh;
      showPopupInfaq.value = true;
    } else {
      showPopupInfaq.value = false;
    }
  }

  startWaktu() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      txttime.value = getTimeRemaining(duration.value);
      if (duration.value == 0) {
        // getWaktu();
      }
      duration.value--;
    });
  }

  getNextLargerNumber(int number, List array) {
    for (var i = 0; i < array.length; i++) {
      var numberTime = int.parse(array[i]['waktu'].split(':').join());
      if (number < numberTime) {
        return array[i];
      }
    }
    return -1;
  }

  int timesBetween(DateTime from, DateTime to) {
    return (to.difference(from).inSeconds);
  }

  getTimeRemaining(waktu) {
    var detik = waktu;
    var h = (detik / 3600).floor();
    var m = ((detik % 3600) / 60).floor();
    var hDisplay = h > 0 ? '$h jam ' : '';
    var mDisplay = m > 0 ? '$m menit' : '';
    return hDisplay + mDisplay;
  }

  loadStorage() async {
    try {
      isLogin.value = dataStore.read('isLogin');
      if (isLogin.isTrue) {
        userLogin.value = dataStore.read('userLogin');
        if (!kIsWeb) {
          // await ProfileService().setToken(dataStore.read('fcmtoken'));
        }
      }
    } catch (e) {
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

      isLogin.value = false;
      Get.offAllNamed(RoutesAuth.root);
    } catch (e) {
      print(e);
      print('gk ada session');
    }
  }

  updateLokasi({required ketLokasi, required lat, required lang}) async {
    dataStore.write('lokasiSaatIni', ketLokasi);
    dataStore.write('lat', lat);
    dataStore.write('lang', lang);
    mylokasi.value = LokasiSayaData(
      keteranganLokasi: ketLokasi,
      lat: lat,
      lang: lang,
    );
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

  getCache() async {
    try {
      var lokasiSaatIni = dataStore.read('lokasiSaatIni');
      var lat = dataStore.read('lat');
      var lang = dataStore.read('lang');
      if (lokasiSaatIni == null) {
        print('ambil lokasi');
        var statusLokasi = await Permission.location.request();
        if (statusLokasi.isGranted) {
          Position position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high);
          List<Placemark> placemarks = await placemarkFromCoordinates(
              position.latitude, position.longitude);
          Placemark place = placemarks[0];
          mylokasi.value = LokasiSayaData(
            keteranganLokasi:
                "${place.locality.toString()}, ${place.country.toString()}",
            lat: position.latitude,
            lang: position.longitude,
          );
        } else if (statusLokasi.isDenied) {
          mylokasi.value = LokasiSayaData(
              keteranganLokasi: "Silahkan mengaktifkan izin lokasi",
              lat: 0,
              lang: 0,
              gpsizin: false);
        }
      } else {
        mylokasi.value = LokasiSayaData(
          keteranganLokasi: lokasiSaatIni,
          lat: lat,
          lang: lang,
        );
      }
    } catch (e) {
      mylokasi.value = LokasiSayaData(
          keteranganLokasi: "Silahkan mengaktifkan izin lokasi",
          lat: 0,
          lang: 0,
          gpsizin: false);
      print(e);
    }
  }

  @override
  void onInit() async {
    super.onInit();
    await getCache();
    await waktusolatData();
    await getWaktu();
    await startWaktu();
    await loadStorage();
    await loadHistoryQuran();
    loadingwaktusolat.value = false;
  }
}
