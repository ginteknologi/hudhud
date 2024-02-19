import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:masjid_app/components/button/elevatedbutton.dart';
import 'package:masjid_app/components/button/iconbutton.dart';
import 'package:masjid_app/components/input/InputText.dart';
import 'package:masjid_app/configs/main_service.dart';
import 'package:masjid_app/routes/sedekah/index.dart';
import 'package:masjid_app/pages/home/home_service.dart';
import 'package:simple_moment/simple_moment.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:masjid_app/routes/auth/index.dart';
// import 'package:masjid_app/pages/akun/profile/profile_service.dart';

enum DialogPopupInfaq { subuh, pagi }

class MainController extends GetxController {
  final dataStore = GetStorage();
  var isLogin = false.obs;
  var userLogin = {}.obs;
  var perAyatLastRead = {}.obs;
  var indonesiaLastRead = {}.obs;
  var tajwidLastRead = {}.obs;
  var madinahLastRead = {}.obs;
  var lokasiSaatIni = "";

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

  Future waktusolatData() async {
    try {
      var hijriDateNow = HijriCalendar.now();
      HijriDate = hijriDateNow.toFormat('MMMM dd yyyy');
      lokasiSaatIni = dataStore.read('lokasiSaatIni') ?? "Pilih Lokasi";
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
    print(thistime);
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

  void showPopup() {
    Get.defaultDialog(
      backgroundColor: Colors.transparent,
      barrierDismissible: true,
      contentPadding:
          const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 20),
      title: '',
      titleStyle: const TextStyle(height: 0),
      titlePadding: const EdgeInsets.all(0),
      content: Column(
        children: [
          Row(
            children: [
              const Expanded(child: Text("")),
              ButtonIcon(
                onTap: () {
                  Get.back();
                },
                bgcolor: Colors.transparent,
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Container(
            constraints: BoxConstraints.loose(Size.infinite),
            height: 400,
            width: Get.width - 42,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: dialogPopupInfaq == DialogPopupInfaq.pagi
                      ? const AssetImage('assets/img/infaq_pagi.png')
                      : const AssetImage('assets/img/infaq_subuh.png'),
                  fit: BoxFit.fill,
                  alignment: Alignment.topCenter),
            ),
          ),
          Container(
              width: Get.width,
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(color: Colors.white),
              child: ButtonElevated(
                title: 'Siap, Bismillah Infaq',
                width: 165,
                bgcolor: dialogPopupInfaq == DialogPopupInfaq.pagi
                    ? const Color(0xFFD9A04A)
                    : Get.theme.primaryColor,
                height: 45,
                color: Colors.white,
                radius: 7,
                shadow: false,
                onPressed: () {
                  // Navigator.pop(context);
                  Get.back();
                  Get.toNamed('${RoutesSedekah.root}/1');
                },
              ))
        ],
      ),
    );
  }

  showDialogFilter(flag) {
    Get.defaultDialog(
      backgroundColor: Colors.transparent,
      barrierDismissible: true,
      radius: 7,
      contentPadding:
          const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 20),
      title: '',
      titleStyle: const TextStyle(height: 0),
      titlePadding: const EdgeInsets.all(0),
      content: Column(
        children: [
          Container(
            width: Get.width - 25,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Color(0xFF189A8C),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(7), topRight: Radius.circular(7))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Pergi Ke',
                  // "Q.S Al-Muthaffifiin :  34",
                  style: Get.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.normal, color: Colors.white),
                ),
                ButtonIcon(
                  onTap: () {
                    Get.back();
                  },
                  bgcolor: Colors.transparent,
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Obx(() => loadingFilter == true
              ? Text("data")
              : Container(
                  width: Get.width - 25,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(7),
                          bottomRight: Radius.circular(7))),
                  child: !flag
                      ? Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            ButtonElevated(
                              title: 'Ayat',
                              width: 120,
                              bgcolor: Get.theme.primaryColor,
                              height: 30,
                              color: Colors.white,
                              radius: 5,
                              onPressed: () {},
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: Get.width / 2.5,
                                  child: Text(
                                    "1. Alfatihah",
                                    style: TextStyle(
                                        fontSize:
                                            Get.textTheme.bodySmall?.fontSize),
                                  ),
                                  margin: EdgeInsets.only(right: 10),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 12),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Get
                                              .theme.colorScheme.onBackground
                                              .withOpacity(.1)),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                ),
                                Container(
                                  width: Get.width / 3,
                                  child: InputText(
                                    controller: inputFilter,
                                    labelPosition: "none",
                                    placeholder: "1-100",
                                    textAlign: TextAlign.center,
                                    isFill: true,
                                    placeholderStyle: Get.textTheme.bodyMedium,
                                    inputAction: TextInputAction.next,
                                    onSubmit: (newValue) {},
                                    onEditingComplete: () {},
                                    onChanged: (newValue) {},
                                    validator: (newValue) {
                                      if (newValue!.isEmpty) {
                                        return "Mohon untuk diisi.";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              width: Get.width - 25,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 15),
                              decoration: BoxDecoration(
                                  color: Color(0xFFDCDCDC),
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(7),
                                      bottomRight: Radius.circular(7))),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ButtonElevated(
                                      title: 'Buka Ayat',
                                      // width: 120,
                                      shadow: false,
                                      bgcolor: Colors.transparent,
                                      height: 30,
                                      size: Get.textTheme.bodySmall?.fontSize,
                                      color: Colors.black,
                                      radius: 0,
                                      onPressed: () {
                                        selectedJuz.value = !selectedJuz.value;
                                      },
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    ButtonElevated(
                                      title: 'Buka Ayat',
                                      width: 160,
                                      size: Get.textTheme.bodySmall?.fontSize,
                                      bgcolor: Color(0xFF2128C2),
                                      height: 30,
                                      color: Colors.white,
                                      radius: 5,
                                      onPressed: () {},
                                    ),
                                  ]),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ButtonElevated(
                                  title: 'Juz',
                                  width: 120,
                                  bgcolor: selectedJuz.value == true
                                      ? Get.theme.primaryColor
                                      : Get.theme.secondaryHeaderColor,
                                  height: 30,
                                  color: selectedJuz.value == true
                                      ? Colors.white
                                      : Colors.black,
                                  radius: 0,
                                  onPressed: () {
                                    selectedJuz.value = !selectedJuz.value;
                                  },
                                ),
                                ButtonElevated(
                                  title: 'Halaman',
                                  width: 120,
                                  bgcolor: selectedJuz.value == false
                                      ? Get.theme.primaryColor
                                      : Get.theme.secondaryHeaderColor,
                                  height: 30,
                                  color: selectedJuz.value == false
                                      ? Colors.white
                                      : Colors.black,
                                  radius: 0,
                                  onPressed: () {
                                    selectedJuz.value = !selectedJuz.value;
                                  },
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: InputText(
                                controller: inputFilter,
                                labelPosition: "none",
                                placeholder: "1-100",
                                textAlign: TextAlign.center,
                                isFill: true,
                                placeholderStyle: Get.textTheme.bodyMedium,
                                inputAction: TextInputAction.next,
                                onSubmit: (newValue) {},
                                onEditingComplete: () {},
                                onChanged: (newValue) {},
                                validator: (newValue) {
                                  if (newValue!.isEmpty) {
                                    return "Mohon untuk diisi.";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Container(
                              width: Get.width - 25,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 15),
                              decoration: BoxDecoration(
                                  color: Color(0xFFDCDCDC),
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(7),
                                      bottomRight: Radius.circular(7))),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: selectedJuz.value
                                      ? [
                                          ButtonElevated(
                                            title: 'Buka Ayat',
                                            // width: 120,
                                            shadow: false,
                                            bgcolor: Colors.transparent,
                                            height: 30,
                                            size: Get
                                                .textTheme.bodySmall?.fontSize,
                                            color: selectedJuz.value == false
                                                ? Colors.white
                                                : Colors.black,
                                            radius: 0,
                                            onPressed: () {
                                              selectedJuz.value =
                                                  !selectedJuz.value;
                                            },
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          ButtonElevated(
                                            title: 'Buka Juz',
                                            size: Get
                                                .textTheme.bodySmall?.fontSize,
                                            bgcolor: Color(0xFF2128C2),
                                            height: 30,
                                            color: Colors.white,
                                            radius: 5,
                                            onPressed: () {},
                                          ),
                                        ]
                                      : [
                                          ButtonElevated(
                                            title: 'Buka Ayat',
                                            // width: 120,
                                            shadow: false,
                                            bgcolor: Colors.transparent,
                                            height: 30,
                                            size: Get
                                                .textTheme.bodySmall?.fontSize,
                                            color: selectedJuz.value == false
                                                ? Colors.white
                                                : Colors.black,
                                            radius: 0,
                                            onPressed: () {
                                              selectedJuz.value =
                                                  !selectedJuz.value;
                                            },
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          ButtonElevated(
                                            title: 'Buka Halaman',
                                            width: 160,
                                            size: Get
                                                .textTheme.bodySmall?.fontSize,
                                            bgcolor: Color(0xFF2128C2),
                                            height: 30,
                                            color: Colors.white,
                                            radius: 5,
                                            onPressed: () {},
                                          ),
                                        ]),
                            ),
                          ],
                        ))),
        ],
      ),
    );
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
        dataStore.write(
            'perAyatLastRead', {'id': 0, 'suratName': '', 'ayatNumber': 0, 'audio':'ar.alafasy', 'audiosource': 'server'});
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
      perAyatLastRead.value = dataStore.read('perAyatLastRead');
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
      // dataStore.remove('token');
      isLogin.value = false;
      // dataStore.write('token', "");
      Get.offAllNamed(RoutesAuth.root);
    } catch (e) {
      print(e);
      print('gk ada session');
    }
  }

  updateLokasi(updateLokasi) async {
    dataStore.write('lokasiSaatIni', updateLokasi);
    lokasiSaatIni = updateLokasi;
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

  @override
  void onInit() async {
    await waktusolatData();
    await getWaktu();
    await startWaktu();
    await loadStorage();
    await loadHistoryQuran();
    // await Scheduling();
    loadingwaktusolat.value = false;
    super.onInit();
  }
}
