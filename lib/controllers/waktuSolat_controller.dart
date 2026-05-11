import 'dart:async';

import 'package:get/get.dart';
import 'package:adhan/adhan.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:masjid_app/controllers/main_controller.dart';
import 'package:masjid_app/models/waktuSolatData.dart';
import 'package:masjid_app/storage/lokasiSaya_storage.dart';
import 'package:simple_moment/simple_moment.dart';

class WaktuSolatController extends GetxController {
  final lokasiStorage = LokasiStorage();
  final MainController gctrl = Get.find();
  Timer? timer;

  var isLoading = true.obs;
  var hijriDateNow = HijriCalendar.now();
  var hijriahDate = "".obs;
  var todayDate = "".obs;
  var jarakWaktu = "".obs;
  var imsak = "".obs;
  var berbuka = "".obs;
  var hijriDate = {}.obs;

  Rx<WaktuSolatData> waktuSolat =
      WaktuSolatData(label: "label", time: "time", status: true).obs;
  RxList<WaktuSolatData> list = <WaktuSolatData>[
    WaktuSolatData(
      label: "label",
      time: "time",
      status: true,
      time24: "time",
    ),
    WaktuSolatData(
      label: "label",
      time: "time",
      time24: "time",
      status: true,
    ),
    WaktuSolatData(
      label: "label",
      time: "time",
      time24: "time",
      status: true,
    ),
    WaktuSolatData(
      label: "label",
      time: "time",
      time24: "time",
      status: true,
    ),
  ].obs;
  Future getWaktuSolat() async {
    try {
      final myCoordinates = Coordinates(
          gctrl.mylokasi.value.lat, gctrl.mylokasi.value.long,
          validate: true);
      
      // Standar KEMENAG RI: Fajr 20.0, Isha 18.0
      final waktu = CalculationParameters(fajrAngle: 20.0, ishaAngle: 18.0);
      waktu.method = CalculationMethod.other;
      
      // Ikhtiyat (Waktu Pengaman) standar KEMENAG adalah +2 menit
      waktu.adjustments.fajr = 2;
      waktu.adjustments.isha = 2;
      waktu.adjustments.asr = 2;
      waktu.adjustments.maghrib = 2;
      waktu.adjustments.dhuhr = 2;

      final prayerTimes = PrayerTimes.today(myCoordinates, waktu);
      list.value = [
        WaktuSolatData(
            label: "Subuh",
            time: DateFormat.jm().format(prayerTimes.fajr),
            time24: DateFormat.Hm().format(prayerTimes.fajr),
            status: false),
        WaktuSolatData(
            label: "Dzuhur",
            time: DateFormat.jm().format(prayerTimes.dhuhr),
            time24: DateFormat.Hm().format(prayerTimes.dhuhr),
            status: false),
        WaktuSolatData(
            label: "Ashar",
            time: DateFormat.jm().format(prayerTimes.asr),
            time24: DateFormat.Hm().format(prayerTimes.asr),
            status: false),
        WaktuSolatData(
            label: "Maghrib",
            time: DateFormat.jm().format(prayerTimes.maghrib),
            time24: DateFormat.Hm().format(prayerTimes.maghrib),
            status: false),
        WaktuSolatData(
            label: "Isya",
            time: DateFormat.jm().format(prayerTimes.isha),
            time24: DateFormat.Hm().format(prayerTimes.isha),
            status: false),
      ];

      final fajrTime = prayerTimes.fajr;
      imsak.value =
          DateFormat.jm().format(fajrTime.subtract(Duration(minutes: 10)));
      berbuka.value = DateFormat.jm().format(prayerTimes.maghrib);
      _updateNextSalat();
      isLoading.value = false;
    } catch (e) {
      print("error getwaktusolat");
      print(e);
    }
  }

  void _updateNextSalat() {
    try {
      DateTime now = DateTime.now();
      int index = 0;
      for (int i = 0; i < list.length; i++) {
        var cekwaktu = list[i].time24!.contains(".");
        var default_split = ":";
        if (cekwaktu) {
          default_split = ".";
        }
        DateTime salatTime = DateTime(
          now.year,
          now.month,
          now.day,
          int.parse(list[i].time24!.split(default_split)[0]),
          int.parse(list[i].time24!.split(default_split)[1]),
        );
        if (salatTime.isAfter(now)) {
          index = i;
          break;
        }
      }
      list[index].status = true;
      waktuSolat.value = list[index];
      timer = Timer.periodic(Duration(seconds: 1), (_) {
        _calculateTimeToNextSalat(waktuSolat.value.time24!);
      });
      isLoading.value = false;
    } catch (e) {
      print("error _updateNextSalat");
      print(e);
    }
  }

  void _calculateTimeToNextSalat(String nextSalatTime) {
    try {
      var cekwaktu = nextSalatTime.contains(".");
      var default_split = ":";
      if (cekwaktu) {
        default_split = ".";
      }
      DateTime now = DateTime.now();
      DateTime nextSalatDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        int.parse(nextSalatTime.split(default_split)[0]),
        int.parse(nextSalatTime.split(default_split)[1]),
      );

      if (nextSalatDateTime.isBefore(now)) {
        nextSalatDateTime = nextSalatDateTime.add(Duration(
            days:
                1)); // Tambahkan 1 hari untuk mendapatkan waktu di hari berikutnya
      }
      Duration difference = nextSalatDateTime.difference(now);
      int hours = difference.inHours;
      int minutes = difference.inMinutes.remainder(60);
      jarakWaktu.value = "$hours Jam $minutes Menit";
      if (hours == 0) {
        jarakWaktu.value = "$minutes Menit";
      }
      if (now.isAfter(nextSalatDateTime)) {
        int index = 0;
        for (int i = 0; i < list.length; i++) {
          list[i].status = false;
          DateTime salatTime = DateTime(
            now.year,
            now.month,
            now.day,
            int.parse(list[i].time24!.split(":")[0]),
            int.parse(list[i].time24!.split(":")[1]),
          );
          if (salatTime.isAfter(now)) {
            index = i;
            break;
          }
        }
        list[index].status = true;
        waktuSolat.value = list[index];
      }
    } catch (e) {
      print("error _calculateTimeToNextSalat");
      print(e);
    }
  }

  @override
  void onInit() async {
    super.onInit();
    var hijriDateNow = HijriCalendar.now();
    hijriDate.value = {
      "bulan": hijriDateNow.toFormat('MMMM'),
      "tahun": hijriDateNow.toFormat('yyyy'),
      "hari": hijriDateNow.toFormat('dd'),
    };
    todayDate.value =
        Moment.now().format("EEEE, dd MMMM", localeOverride: 'id');
    hijriahDate.value = hijriDateNow.toFormat('MMMM dd yyyy');
    await getWaktuSolat();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
