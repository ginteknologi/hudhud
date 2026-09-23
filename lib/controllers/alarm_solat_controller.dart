import 'package:adhan/adhan.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:masjid_app/models/waktu_solat_data.dart';
import 'package:masjid_app/storage/lokasi_saya_storage.dart';

class AlarmSolatController extends GetxController {
  var isLoading = false.obs;
  final lokasiStorage = LokasiStorage();
  RxList<WaktuSolatData> list = <WaktuSolatData>[].obs;

  Future loadData() async {
    final myCoordinates = Coordinates(
        lokasiStorage.getLokasi().lat, lokasiStorage.getLokasi().long);
    final waktu = CalculationMethod.singapore.getParameters();
    final prayerTimes = PrayerTimes.today(myCoordinates, waktu);
    list.value = [
      WaktuSolatData(
          label: "Subuh",
          time: DateFormat.jm().format(prayerTimes.fajr),
          time24: DateFormat.Hm().format(prayerTimes.fajr),
          status: false),
      WaktuSolatData(
          label: "Terbit",
          time: DateFormat.jm().format(prayerTimes.sunrise),
          time24: DateFormat.Hm().format(prayerTimes.sunrise),
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

    isLoading.value = false;
  }

  @override
  void onInit() async {
    super.onInit();
    await loadData();
  }
}
