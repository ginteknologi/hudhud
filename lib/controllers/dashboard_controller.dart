import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:masjid_app/configs/firebase_message_setup.dart';
import 'package:masjid_app/controllers/main_controller.dart';
import 'package:masjid_app/models/artikelData.dart';
import 'package:masjid_app/models/kajianData.dart';
import 'package:masjid_app/pages/home/home_service.dart';
import 'package:get_storage/get_storage.dart';
import 'package:masjid_app/service/dashboard_service.dart';
import 'package:permission_handler/permission_handler.dart';

class DashboardController extends GetxController {
  final ctrlmain = Get.find<MainController>();

  final dataStore = GetStorage();
  var isLoadingKajianLive = true.obs;
  var isLoadingKajianTafsir = true.obs;
  var isLoadingArtikel = true.obs;
  var isLoadingLokasi = false.obs;
  var isLoadingDoaDashboard = true.obs;

  var listMenuHome = [].obs;
  var listKajianSlider = <KajianData>[].obs;
  var listKajianLiveSlider = <KajianData>[].obs;
  var listDoaSlider = <KajianData>[].obs;
  var listArtikel = <ArtikelData>[].obs;
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
            category_artikel: element['category_artikel'],
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
        "label": "Al Quran",
        "icon": "assets/icons/newQuran.svg",
        "urlNav": "/quran",
        "typeLink": "slide"
      },
      {
        "label": "Kiblat",
        "icon": "assets/icons/kiblat.svg",
        "urlNav": "/kiblat",
        "typeLink": "newtab"
      },
      {
        "label": "Do'a", 
        "icon": "assets/icons/doa.svg", 
        "urlNav": "/doa",
        "typeLink": "newtab"
      },
      {
        "label": "Informasi",
        "icon": "assets/icons/informasi.svg",
        "urlNav": "/artikel",
        "typeLink": "newtab"

      },
      {
        "label": "Hadits",
        "icon": "assets/icons/hadits.svg",
        "urlNav": "/hadits",
        "typeLink": "newtab"
      },
      {
        "label": "Dzikir Pagi Petang",
        "icon": "assets/icons/dzikir_pagi_petang.svg",
        "urlNav": "/dzikir",
        "typeLink": "newtab"
      },
      {
        "label": "Jadwal Imsakiyah",
        "icon": "assets/icons/jadwal_imsak.svg",
        "urlNav": "/kalenderdzulhijjah",
        "typeLink": "newtab"
      },
      {
        "label": "Cari Masjid",
        "icon": "assets/icons/wews.svg",
        "urlNav": "",
        "typeLink": "newtab"

      },
      {
        "label": "Instagram",
        "icon": "assets/icons/insta2.svg",
        "urlNav": "https://www.instagram.com/marbot.aplikasi/",
        "typeLink": "external"

      },
      {
        "label": "Youtube",
        "icon": "assets/icons/Youtube.svg",
        "urlNav": "https://www.youtube.com/@MarbotAplikasi",
        "typeLink": "external"

      },
    ];
  }

  getSliderKajianTafsir() async {
    try {
      final result = await DashboardService().getSliderKajian('tafsir');
      for (var element in result['data']) {
        listKajianSlider.add(KajianData(
            id: element['id'],
            judul: element['judul'],
            subjudul: element['subjudul'],
            image: element['image'],
            link: element['link']));
      }
      isLoadingKajianTafsir.value = false;
    } catch (e) {
      print(e);
      print('<<<<<<<<error getSliderKajian>>>>>>>>');
    }
  }
  getSliderKajianLive() async {
    try {
      final result = await DashboardService().getSliderKajian('live');
      for (var element in result['data']) {
        listKajianLiveSlider.add(KajianData(
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

  getSliderDoaDashboard() async {
    try {
      final result = await DashboardService().getSliderKajian('doa_ramadhan');
      for (var i = 0; i < result['data'].length; i++) {
        var element = result['data'][i];
        listDoaSlider.add(KajianData(
            id: element['id'], image: element['image'], link: element['link']));
      }
      isLoadingDoaDashboard.value = false;
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
    getSliderKajianTafsir();
    GetDataArtikel();
    getMenuHome();
    getSliderDoaDashboard();
    setFcm();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
