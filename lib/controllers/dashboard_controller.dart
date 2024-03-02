import 'dart:async';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:masjid_app/configs/firebase_message_setup.dart';
import 'package:masjid_app/controllers/main_controller.dart';
import 'package:masjid_app/models/artikelData.dart';
import 'package:masjid_app/models/kajianData.dart';
import 'package:masjid_app/models/kontenSosmed.dart';
import 'package:masjid_app/pages/home/home_service.dart';
import 'package:get_storage/get_storage.dart';
import 'package:masjid_app/service/dashboard_service.dart';
import 'package:permission_handler/permission_handler.dart';

class DashboardController extends GetxController {
  final ctrlmain = Get.find<MainController>();

  final dataStore = GetStorage();
  var isLoadingKajianLive = true.obs;
  var isLoadingKajian = true.obs;
  var isLoadingArtikel = true.obs;
  var isLoadingLokasi = false.obs;
  var isLoadingKontenSosmed = true.obs;

  var listMenuHome = [].obs;
  var listKajianSlider = <KajianData>[
    KajianData(
        id: 1,
        judul: 'judul',
        subjudul: 'subjudul',
        image: 'https://dummyimage.com/600x400/000/fff',
        link: 'link'),
    KajianData(
        id: 1,
        judul: 'judul',
        subjudul: 'subjudul',
        image: 'https://dummyimage.com/600x400/000/fff',
        link: 'link'),
    KajianData(
        id: 1,
        judul: 'judul',
        subjudul: 'subjudul',
        image: 'https://dummyimage.com/600x400/000/fff',
        link: 'link'),
  ].obs;
  var listKajian = [].obs;
  var listKontenSosmed = [].obs;
  var listArtikel = <ArtikelData>[
    ArtikelData(
        id: 1,
        judul: "dummy",
        updatedAt: "1992-10-10",
        image: "https://dummyimage.com/600x400/000/fff"),
  ].obs;
  var listAllMenu = [].obs;
  var listKota = [].obs;
  var latestArtikel = {}.obs;

  getLokasi() async {
    var statusLokasi = await Permission.location.request();
    if (statusLokasi.isGranted) {
      isLoadingLokasi.value = true;
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];
      ctrlmain.updateLokasi(
        ketLokasi: "${place.locality.toString()}, ${place.country.toString()}",
        lat: position.latitude,
        long: position.longitude,
      );
      await Scheduling();
      isLoadingLokasi.value = false;
      Get.back();
    } else if (statusLokasi.isDenied) {
      print('Izin ditolak');
      Get.back();
    } else if (statusLokasi.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  GetDataArtikel() async {
    try {
      final artikelbaru = await DashboardService().getListArtikelBaru();
      listArtikel.value = [];
      for (var element in artikelbaru['data']) {
        listArtikel.add(ArtikelData(
            id: element['id'],
            judul: element['judul'],
            updatedAt: element['updatedAt'],
            image: element['image']));
      }
      isLoadingArtikel.value = false;
    } catch (e) {
      print(e);
    }
  }

  getMenuHome() async {
    return listMenuHome.value = [
      {
        "label": "Sedekah",
        "icon": "assets/icons/sedekah_blur.svg",
        "urlNav": ""
      },
      {
        "label": "Kiblat",
        "icon": "assets/icons/kiblat.svg",
        "urlNav": "/kiblat"
      },
      {"label": "Do'a", "icon": "assets/icons/doa.svg", "urlNav": "/doa"},
      {
        "label": "Informasi",
        "icon": "assets/icons/informasi.svg",
        "urlNav": "/artikel"
      },
      {
        "label": "Hadits",
        "icon": "assets/icons/hadits.svg",
        "urlNav": "/hadits"
      },
      {
        "label": "Dzikir Pagi Petang",
        "icon": "assets/icons/dzikir_pagi_petang.svg",
        "urlNav": "/dzikir"
      },
      {
        "label": "Jadwal Imsakiyah",
        "icon": "assets/icons/jadwal_imsak.svg",
        "urlNav": "/kalenderdzulhijjah"
      },
    ];
  }

  getSliderKajianLive() async {
    try {
      final result = await DashboardService().getSliderKajian();
      listKajianSlider.value = [];
      for (var element in result['data']) {
        listKajianSlider.add(KajianData(
            id: element['id'],
            judul: element['judul'],
            subjudul: element['subjudul'],
            image: element['image'],
            link: element['link']));
      }
      isLoadingKajianLive.value = false;
    } catch (e) {
      print(e);
    }
  }

  getSliderKontenSosmed() async {
    try {
      final result = await DashboardService().getSliderKajiLive();
      listKontenSosmed.value = [];
      for (var i = 0; i < result['data'].length; i++) {
        var element = result['data'][i];
        listKontenSosmed.add(SosmedData(
            id: element['id'], image: element['image'], link: element['link']));
      }
      isLoadingKontenSosmed.value = false;
    } catch (e) {
      print(e);
    }
  }

  Future getKajianLive() async {
    try {
      final listresult = await DashboardService().getListKajiLive();
      listKajian.value = listresult['data'];
      isLoadingKajian.value = false;
    } catch (e) {
      print(e);
    }
  }

  Future getKajianTafsir() async {
    try {
      final listresult = await DashboardService().getListKajian();
      listKajian.value = listresult['data'];
      isLoadingKajian.value = false;
    } catch (e) {
      print(e);
    }
  }

  setFcm() async {
    try {
      final isLogin = dataStore.read('isLogin');
      if (isLogin.toString() == 'true') {
        final fcm = dataStore.read('fcmtoken');
        await HomeService().setToken(fcm);
        print('done fcm saving');
      }
    } catch (e) {
      print("<<<<<<<<<<Error set fcm>>>>>>>>>>>>");
      print(e);
    }
  }

  @override
  void onInit() async {
    super.onInit();

    getSliderKajianLive();
    GetDataArtikel();
    getMenuHome();
    getSliderKontenSosmed();
    setFcm();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
