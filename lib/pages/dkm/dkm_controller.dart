import 'package:get/get.dart';
import 'package:masjid_app/pages/dkm/dkm_service.dart';

class DkmController extends GetxController {
  var isLoadingList = true.obs;
  var list = {}.obs;
  List listDkm = [].obs;
  List listMemberDkm = [].obs;
  List listKontak = [].obs;
  List listKontakv2 = [].obs;

  getData() async {
    final result = await DkmService().getList(page: 0, limit: 10);
    list.value = result['data'];
    isLoadingList.value = false;
  }

  getListDkm() async {
    listDkm = [
      {"id": 1, "label": "Membangun Ukhuwah", "value": "semua"},
      {"id": 2, "label": "Mengawal Aqidah", "value": "sejarah"},
      {"id": 3, "label": "Menghindari Iftiraq", "value": "amalan"},
      {"id": 3, "label": "Memahami Ikhtilaf", "value": "sedekah"},
    ];
    return listDkm;
  }

  getListMemberDkm() async {
    listMemberDkm = [
      {"id": 1, "nama": "Fajar Sidiq", "role": "Ketua"},
      {"id": 2, "nama": "Bambang Martono", "role": "Sekretaris"},
      {"id": 3, "nama": "Denny Sukmaputra", "role": "Bendahara"},
      {"id": 4, "nama": "Sugeng Pribadi", "role": "Ketua Bidang Keagamaan"},
      {"id": 5, "nama": "Ponca Kaliga", "role": "Ketua Bidang Sosial"},
      {"id": 6, "nama": "Ramdhan A Maruto", "role": "Ketua Bidang Kemanusiaan"},
    ];
    return listDkm;
  }

  getListKontak() async {
    listKontak = [
      {
        "id": 1,
        "title": "Marbot Aplikasi",
        "category": "Youtube",
        "icon": "assets/icons/youtube-solid.svg",
        'link': 'https://api.whatsapp.com/send?phone=628575647xxxx'
      },
      {
        "id": 1,
        "title": "Marbot Aplikasi",
        "category": "Instagram",
        "icon": "assets/icons/instagram-solid.svg",
        'link': 'https://api.whatsapp.com/send?phone=628575647xxxx'
      },
      {
        "id": 1,
        "title": "Marbot Aplikasi",
        "category": "Facebook Page",
        "icon": "assets/icons/fb-solid.svg",
        'link': 'https://api.whatsapp.com/send?phone=628575647xxxx'
      },
      {
        "id": 1,
        "title": "Marbot Aplikasi",
        "category": "Tik Tok",
        "icon": "assets/icons/tiktok-solid.svg",
        'link': 'https://api.whatsapp.com/send?phone=628575647xxxx'
      },
      {
        "id": 1,
        "title": "+62-8575-647-xxxx",
        "category": "Telepon/WhatsApp",
        "icon": "assets/icons/wa-solid.svg",
        'link': 'https://api.whatsapp.com/send?phone=628575647xxxx'
      },
      {
        "id": 1,
        "title":
            "CitraGran Cibubur, RT005/011, Jatikarya, Jatisampurna, Bekasi, West Java 17435",
        "category": "Alamat",
        "icon": "assets/icons/pin-solid.svg",
        'link': 'https://goo.gl/maps/1Hw5yqj5qzJY5kEj8'
      }      
      // {
      //   "id": 1,
      //   "title": "https://linktr.ee/AnNimahTV",
      //   "category": "LinkTree",
      //   "icon": "assets/icons/tele.svg",
      //   "link": "https://linktr.ee/AnNimahTV"
      // },
    ];
    return listKontak;
  }

  getListKontakv2() async {
    listKontakv2 = [
      {
        "id": 1,
        "title": "+62-8575-647-xxxx",
        "category": "Telepon/WhatsApp",
        "icon": "assets/icons/wa-solid.svg",
        'link': 'https://api.whatsapp.com/send?phone=628575647xxxx'
      },
      {
        "id": 2,
        "title":
            "Masjid An Nimah, CitraGran Cibubur, RT.005/RW.011, Jatikarya, Jatisampurna, Bekasi, West Java 17435",
        "category": "Alamat",
        "icon": "assets/icons/pin-solid.svg",
        'link': 'https://goo.gl/maps/1Hw5yqj5qzJY5kEj8'
      },
    ];
    return listKontakv2;
  }

  @override
  void onInit() {
    getListDkm();
    // getListMemberDkm();
    getListKontak();
    getListKontakv2();
    super.onInit();
  }
}
