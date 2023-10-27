import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mesjid_app/pages/home/home_controller.dart';
import 'package:mesjid_app/pages/quran/halaman/halaman_quran_page.dart';
import 'package:mesjid_app/pages/quran/quran_service.dart';

class HalamanQuranController extends GetxController
    with GetSingleTickerProviderStateMixin {
  var isLoadingList = true.obs;
  var list = {}.obs;
  List listSurah = [].obs;
  var visible = true.obs;

  var bookmarked = false.obs;

  var txtController = TextEditingController();
  late AnimationController animateController;

  final hctrl = Get.find<HomeController>();

  getData() async {
    final result = await QuranService().getList(page: 0, limit: 10);
    list.value = result['data'];
    isLoadingList.value = false;
  }

  getQuran() async {
    listSurah = [
      'assets/img/quran/1.png',
      'assets/img/quran/2.png',
      'assets/img/quran/3.png',
      'assets/img/quran/4.png'
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
