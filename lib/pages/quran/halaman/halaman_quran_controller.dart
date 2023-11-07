import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mesjid_app/pages/home/home_controller.dart';
import 'package:mesjid_app/pages/quran/halaman/halaman_quran_page.dart';
import 'package:mesjid_app/pages/quran/quran_service.dart';
import 'package:get_storage/get_storage.dart';

class HalamanQuranController extends GetxController with GetSingleTickerProviderStateMixin {
  final dataStore = GetStorage();
  var lastReadPerhalaman = {}.obs;
  var isLoadingList = true.obs;
  var list = {}.obs;
  List listSurah = [].obs;
  var visible = true.obs;

  var bookmarked = false.obs;

  var txtController = TextEditingController();
  late AnimationController animateController;

  final hctrl = Get.find<HomeController>();

  getData() async {
    final result = await QuranService().getList('all');
    list.value = result['data'];
    isLoadingList.value = false;
  }

  getQuran() async {
    lastReadPerhalaman.value = dataStore.read('perHalamanLastRead');
    listSurah = [
      {
        'id': 1,
        'name': 'Al-Fatihah',
        'image': 'assets/img/quran/1.jpg'
      },
      {
        'id': 2,
        'name': 'Al-Fatihah',
        'image': 'assets/img/quran/2.jpg'
      },
      {
        'id': 3,
        'name': 'Al-Fatihah',
        'image': 'assets/img/quran/3.jpg'
      },
      {
        'id': 4,
        'name': 'Al-Fatihah',
        'image': 'assets/img/quran/4.jpg'
      },
      {
        'id': 5,
        'name': 'Al-Fatihah',
        'image': 'assets/img/quran/5.jpg'
      }
    ];
    // listSurah.sort((b, a) => a.compareTo(b));
    return listSurah;
  }

  bookmark() async {
    Fluttertoast.showToast(
        msg: "Halaman berhasil ditandai",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black87,
        timeInSecForIosWeb: 1,
        fontSize: Get.width / 30);
  }

  @override
  void onInit() {
    animateController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
    getQuran();
    print(listSurah);
    super.onInit();
  }
}
