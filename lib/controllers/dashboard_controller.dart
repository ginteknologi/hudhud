import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
// import 'package:masjid_app/configs/firebase_message_setup.dart';
import 'package:masjid_app/controllers/main_controller.dart';
import 'package:masjid_app/models/artikel_data.dart';
import 'package:masjid_app/models/kajian_data.dart';
import 'package:masjid_app/controllers/home_controller.dart';
import 'package:masjid_app/models/sedang_live_data.dart';
import 'package:masjid_app/pages/home/home_service.dart';
import 'package:get_storage/get_storage.dart';
import 'package:masjid_app/service/dashboard_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';

class DashboardController extends GetxController {
  final ctrlmain = Get.find<MainController>();
  final ctrlhome = Get.find<HomeController>();
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
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
        image: "https://dummyimage.com/600x400/000/fff",
        publishDate: ''),
    ArtikelData(
        id: 1,
        judul: "dummy",
        updatedAt: "1992-10-10",
        image: "https://dummyimage.com/600x400/000/fff",
        publishDate: ''),
  ].obs;
  var listAllMenu = [].obs;
  var listKota = [].obs;
  var latestArtikel = {}.obs;

  Future<void> getLokasi() async {
    var statusLokasi = await Permission.location.request();
    if (statusLokasi.isGranted) {
      isLoadingLokasi.value = true;
      try {
        // geolocator 14.x: pakai parameter `locationSettings`,
        // `desiredAccuracy` sudah deprecated.
        Position position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            timeLimit: Duration(seconds: 20),
          ),
        );

        // geocoding 5.x: method tidak lagi berupa top-level function,
        // tapi method dari instance `Geocoding`.
        var ket = "Lokasi Terdeteksi";
        try {
          List<Placemark> placemarks = await Geocoding()
              .placemarkFromCoordinates(position.latitude, position.longitude);
          if (placemarks.isNotEmpty) {
            Placemark place = placemarks[0];
            var namaLokasi = [
              place.locality ?? '',
              place.country ?? '',
            ].where((e) => e.isNotEmpty).join(', ');
            if (namaLokasi.isNotEmpty) ket = namaLokasi;
          }
        } catch (e) {
          if (kDebugMode) {
            debugPrint("<<<<<<<< error reverse geocoding >>>>>>>>");
            debugPrint(e.toString());
          }
        }

        // Update data terbaru (sekaligus simpan ke cache)
        ctrlmain.updateLokasi(
          ketLokasi: ket,
          lat: position.latitude,
          long: position.longitude,
        );
        if (kDebugMode) {
          debugPrint(
              "Lokasi terupdate: ${ctrlmain.mylokasi.value.keteranganLokasi}");
        }
      } catch (e) {
        if (kDebugMode) {
          debugPrint("<<<<<<<< error getLokasi >>>>>>>>");
          debugPrint(e.toString());
        }
        Fluttertoast.showToast(
          msg: "Gagal mengambil lokasi, pastikan GPS aktif dan coba lagi",
        );
      } finally {
        isLoadingLokasi.value = false;
      }
      // await Scheduling();
      Get.back();
    } else if (statusLokasi.isDenied) {
      if (kDebugMode) {
        debugPrint('Izin ditolak');
      }
      Get.back();
    } else if (statusLokasi.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  Future<void> getDataArtikel() async {
    try {
      final artikelbaru = await DashboardService().getListArtikelBaru();
      listArtikel.value = [];

      // Sort data by publish_date descending (newest first)
      List data = artikelbaru['data'] ?? [];
      data.sort((a, b) {
        DateTime dateA = DateTime.tryParse(a['publish_date'] ?? '') ??
            DateTime.fromMillisecondsSinceEpoch(0);
        DateTime dateB = DateTime.tryParse(b['publish_date'] ?? '') ??
            DateTime.fromMillisecondsSinceEpoch(0);
        return dateB.compareTo(dateA);
      });

      for (var element in data) {
        listArtikel.add(ArtikelData(
            id: element['id'],
            judul: element['judul'],
            categoryArtikel: element['category_artikel'],
            updatedAt: element['updatedAt'],
            publishDate: element['publish_date'],
            image: element['image']));
      }
      isLoadingArtikel.value = false;
    } catch (e) {
      if (kDebugMode) {
        debugPrint("<<<<<<<< error GetDataArtikel >>>>>>>>");
        debugPrint(e.toString());
      }
    }
  }

  Future<void> getDataSedangLive() async {
    try {
      final data = await DashboardService().getSedangLive();
      if (kDebugMode) {
        debugPrint("<<<<<<<< GetDataSedangLive >>>>>>>>");
        debugPrint(data.toString());
      }
      listSedangLive.value = data;
      isLoadingLive.value = false;
    } catch (e) {
      if (kDebugMode) {
        debugPrint("<<<<<<<< error GetDataSedangLive >>>>>>>>");
        debugPrint(e.toString());
      }
    }
  }

  Future<List<dynamic>> getMenuHome() async {
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

  Future<void> getSliderKajianTafsir() async {
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
      if (kDebugMode) {
        debugPrint("<<<<<<<< error getSliderKajian >>>>>>>>");
        debugPrint(e.toString());
      }
    }
  }

  Future<void> getSliderKajianLive() async {
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
      if (kDebugMode) {
        debugPrint("<<<<<<<< error getSliderKajianLive >>>>>>>>");
        debugPrint(e.toString());
      }
    }
  }

  Future<void> getSliderDoaDashboard() async {
    try {
      final result = await DashboardService().getSliderKajian('doa_ramadhan');
      listDoaSlider.value = [];
      for (var i = 0; i < result['data'].length; i++) {
        if (kDebugMode) {
          debugPrint(result['data'][i]['image']);
        }
        var element = result['data'][i];
        listDoaSlider.add(KajianData(
            id: element['id'], image: element['image'], link: element['link']));
      }
      isLoadingDoaDashboard.value = false;
    } catch (e) {
      if (kDebugMode) {
        debugPrint("<<<<<<<< error getSliderDoaDashboard >>>>>>>>");
        debugPrint(e.toString());
      }
    }
  }

  Future<void> setFcm() async {
    try {
      final isLogin = dataStore.read('isLogin');
      if (isLogin.toString() == 'true') {
        final fcm = dataStore.read('fcmtoken');
        await HomeService().setToken(fcm);
        if (kDebugMode) {
          debugPrint('done fcm saving');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint("<<<<<<<<<<Error set fcm>>>>>>>>>>>>");
        debugPrint(e.toString());
      }
    }
  }

  @override
  void onInit() async {
    super.onInit();
    getDataSedangLive();
    getSliderKajianLive();
    getSliderKajianTafsir();
    getDataArtikel();
    getMenuHome();
    getSliderDoaDashboard();
    setFcm();
  }
}
