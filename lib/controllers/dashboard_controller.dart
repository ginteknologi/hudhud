import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:masjid_app/configs/firebase_message_setup.dart';
import 'package:masjid_app/controllers/main_controller.dart';
import 'package:masjid_app/models/artikelData.dart';
import 'package:masjid_app/models/kajianData.dart';
import 'package:masjid_app/controllers/home_controller.dart';
import 'package:masjid_app/models/sedangLiveData.dart';
import 'package:masjid_app/pages/home/home_service.dart';
import 'package:get_storage/get_storage.dart';
import 'package:masjid_app/service/dashboard_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class DashboardController extends GetxController {
  final ctrlmain = Get.find<MainController>();
  final ctrlhome = Get.find<HomeController>();

  final dataStore = GetStorage();
  var isLoadingKajianLive = true.obs;
  var isLoadingKajianTafsir = true.obs;
  var isLoadingArtikel = true.obs;
  var isLoadingLokasi = false.obs;
  var isLoadingDoaDashboard = true.obs;
  var isLoadingLive = true.obs;

  var listMenuHome = [].obs;
  var listSedangLive = <SedangLiveData>[].obs;
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
  var listKajianLiveSlider = <KajianData>[
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
  var listDoaSlider = <KajianData>[
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
  var listArtikel = <ArtikelData>[
    ArtikelData(
        id: 1,
        judul: "dummy",
        updatedAt: "1992-10-10",
        image: "https://dummyimage.com/600x400/000/fff"),
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
            category_artikel: element['category_artikel'],
            updatedAt: element['updatedAt'],
            image: element['image']));
      }
      isLoadingArtikel.value = false;
    } catch (e) {
      print(e);
    }
  }

  GetDataSedangLive() async {
    try {
      final data = await DashboardService().getSedangLive();
      print(data);
      listSedangLive.value = data;
      isLoadingLive.value = false;
    } catch (e) {
      print(e);
    }
  }

  getMenuHome() async {
    return listMenuHome.value = [
      {
        "label": "Al Quran",
        "icon": "assets/icons/newQuran.svg",
        "onTap": () async {
          ctrlhome.type.value = ctrlhome.bottomMenuList[1].navType;
          ctrlhome.selectedIdx.value = 1;
        }
      },
      {
        "label": "Kiblat",
        "icon": "assets/icons/kiblat.svg",
        "onTap": () async {
          Get.toNamed("/kiblat");
        }
      },
      {
        "label": "Do'a",
        "icon": "assets/icons/doa.svg",
        "onTap": () async {
          Get.toNamed("/doa");
        }
      },
      {
        "label": "Informasi",
        "icon": "assets/icons/informasi.svg",
        "onTap": () async {
          Get.toNamed("/artikel");
        }
      },
      {
        "label": "Hadits",
        "icon": "assets/icons/hadits.svg",
        "onTap": () async {
          Get.toNamed("/hadits");
        }
      },
      {
        "label": "Dzikir Pagi Petang",
        "icon": "assets/icons/dzikir_pagi_petang.svg",
        "onTap": () async {
          Get.toNamed("/dzikir");
        }
      },
      {
        "label": "Jadwal Imsakiyah",
        "icon": "assets/icons/jadwal_imsak.svg",
        "onTap": () async {
          Get.toNamed("/kalenderdzulhijjah");
        }
      },
      {
        "label": "Cari Masjid",
        "icon": "assets/icons/wews.svg",
        "onTap": () async {
          Fluttertoast.showToast(
            msg: "Fitur ini sedang dalam tahap pengembangan",
          );
        }
      },
      {
        "label": "Instagram",
        "icon": "assets/icons/insta2.svg",
        "onTap": () async {
          if (!await launchUrl(
              Uri.parse("https://www.instagram.com/marbot.aplikasi/"))) {
            Fluttertoast.showToast(
              msg: "Tidak dapat membuka link instagram",
            );
          }
        }
      },
      {
        "label": "Youtube",
        "icon": "assets/icons/Youtube.svg",
        "onTap": () async {
          if (!await launchUrl(
              Uri.parse("https://www.youtube.com/@MarbotAplikasi"))) {
            Fluttertoast.showToast(
              msg: "Tidak dapat membuka link Youtube",
            );
          }
        }
      },
    ];
  }

  getSliderKajianTafsir() async {
    try {
      final result = await DashboardService().getSliderKajian('tafsir');
      listKajianSlider.value = [];
      for (var element in result['data']) {
        listKajianSlider.add(KajianData(
            id: element['id'],
            judul: element['judul'],
            subjudul: element['subjudul'] ?? "Tidak ada keterangan",
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
      listKajianLiveSlider.value = [];
      for (var element in result['data']) {
        listKajianLiveSlider.add(KajianData(
            id: element['id'],
            judul: element['judul'],
            subjudul: element['subjudul'] ?? "Tidak ada keterangan",
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
      listDoaSlider.value = [];
      for (var i = 0; i < result['data'].length; i++) {
        print(result['data'][i]['image']);
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
    GetDataSedangLive();
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
