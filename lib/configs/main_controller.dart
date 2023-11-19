import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mesjid_app/configs/main_service.dart';
import 'package:simple_moment/simple_moment.dart';
// import 'package:mesjid_app/pages/akun/profile/profile_service.dart';

class MainController extends GetxController {
  final dataStore = GetStorage();
  var isLogin = false.obs;
  var userLogin = {}.obs;

  // data waktu Solat
  var loadingwaktusolat = true.obs;
  var todayDate = "".obs;
  var dataTerbaru = {}.obs;
  var duration = 0.obs;
  var txttime = "".obs;
  var listWaktu = [].obs;
  // end data waktu Solat

  Future waktusolatData() async {
    try {
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
      loadingwaktusolat.value = false;
    } catch (e) {
      dataStore.write('isLogin', false);
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
  }

  startWaktu() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      txttime.value = getTimeRemaining(duration.value);
      if (duration.value == 0) {
        getWaktu();
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
      print(dataStore.read('perAyatLastRead'));
      if (dataStore.read('perAyatLastRead') == null) {
        dataStore.write(
            'perAyatLastRead', {'id': 0, 'suratName': '', 'ayatNumber': 0});
      }
      print(dataStore.read('perHalamanLastRead'));
      if (dataStore.read('perHalamanLastRead') == null) {
        dataStore
            .write('perHalamanLastRead', {'id': 0, 'suratName': '', 'page': 0});
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void onInit() async {
    await waktusolatData();
    getWaktu();
    startWaktu();
    loadStorage();
    loadHistoryQuran();
    super.onInit();
  }
}
