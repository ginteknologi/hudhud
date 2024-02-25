import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masjid_app/pages/quran/quran_service.dart';
import 'package:get_storage/get_storage.dart';
import 'package:masjid_app/configs/main_controller.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ListAyatQuranController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final dataStore = GetStorage();
  final gctrl = Get.find<MainController>();
  final surahId = Get.parameters['id'];
  final surahName = Get.parameters['nama_surah'];
  var isLoadingList = true.obs;
  var isLoadingDetail = false.obs;
  // var lastRead = {}.obs;

  var txtController = TextEditingController();
  var inputAyat = TextEditingController();
  var inputSurah = TextEditingController();

  List<ItemScrollController> itemScrollController = [];

  var myTabs = <Tab>[].obs;
  var tabIndex = 0.obs;
  var contentTab = [].obs;
  var list = [].obs;
  RxList listReverse = [].obs;
  List listSurah = [].obs;
  RxList listAyat = [].obs;
  RxMap detail = {}.obs;
  var searchController = TextEditingController();
  late TabController tabController;
  var pageController = PageController(initialPage: 0);
  int offset = 0;
  int limit = 10;

  Future getData() async {
    try {
      isLoadingList.value = true;
      final result = await QuranService().getList('');
      list.value = result['data'];
      for (var i = 0; i < result['data'].length; i++) {
        myTabs.add(Tab(
          text: result['data'][i]['nama'],
        ));
        contentTab.add({
          'idContent': result['data'][i]['id'],
          'list': [],
        });
        itemScrollController.add(ItemScrollController());
      }
      listReverse.value = result['data'];
      isLoadingList.value = false;
    } catch (e) {
      print("<<<<<<<erorr get data ayat quran>>>>>>>");
      print(e);
    }
  }

  prosesPencarian() async {
    print(inputAyat.text);
    print(inputSurah.text);
    var ddd = list.indexWhere((element) => element['nama'] == inputSurah.text);
    var getSurah = list.where((p0) => p0['nama'] == inputSurah.text).first;
    var newindex = myTabs.length - ddd - 1;
    print("ctrl : " + newindex.toString());
    await getDetailData(getSurah['id'], newindex);
    pageController.jumpToPage(newindex);
    await Future.delayed(Duration(milliseconds: 100));
    itemScrollController[newindex].jumpTo(
      index: int.parse(inputAyat.text) - 1,
    );
    Get.back();
  }

  Future getDetailData(surahId, index) async {
    try {
      int targetDataIndex =
          contentTab.indexWhere((data) => data["idContent"] == surahId);
      int cek = contentTab[targetDataIndex]['list'].length;
      if (cek == 0) {
        isLoadingDetail.value = true;
        final result = await QuranService().getDetail(surahId.toString());
        contentTab[targetDataIndex]['list'] = result['data']['list'];
        isLoadingDetail.value = false;
      }
    } catch (e) {
      print(e);
    }
  }

  getDataSearch() async {
    // lastRead.value = dataStore.read('perAyatLastRead');
    isLoadingDetail.value = true;
    final result = await QuranService().getList(searchController.text);
    list.value = result['data'];
    isLoadingList.value = false;
  }

  bookmark(selectedData, ayatBookmarked, index) async {
    isLoadingDetail.value = true;
    if (ayatBookmarked) {
      gctrl.perAyatLastRead['ayatNumber'] = 0;
      gctrl.perAyatLastRead['suratName'] = '';
      gctrl.perAyatLastRead['id'] = 0;
      dataStore.write('perAyatLastRead', gctrl.perAyatLastRead);
    } else {
      gctrl.perAyatLastRead['ayatNumber'] = selectedData['ayat'];
      gctrl.perAyatLastRead['suratName'] = detail['nama'];
      gctrl.perAyatLastRead['id'] = detail['id'];
      dataStore.write('perAyatLastRead', gctrl.perAyatLastRead);
    }
    isLoadingDetail.value = false;
  }

  // void scrollToIndex() {
  //   isLoadingDetail.value = true;
  //   if (itemScrollController.isAttached) {
  //     if (dataStore.read('perAyatLastRead')['id'] == detail['id']) {
  //       itemScrollController.scrollTo(
  //         index: dataStore.read('perAyatLastRead')['ayatNumber'] - 1,
  //         duration: Duration(milliseconds: 500),
  //         curve: Curves.easeInOut,
  //       );
  //     }
  //   } else {
  //     print('ScrollController tidak berhasil diperoleh');
  //     Timer(Duration(seconds: 1), () {
  //       // Tunggu 1 detik (bisa disesuaikan) dan lakukan scrollToIndex lagi
  //       scrollToIndex();
  //     });
  //   }
  //   isLoadingDetail.value = false;
  // }
  changeTabIndex(index) async {
    tabIndex.value = index;
    detail.value = list[index];
    await getDetailData(detail['id'], index);
    update();
  }

  void dataGoTo(surah, ayat) async {
    try {
      isLoadingDetail.value = true;
      await getDetailData(surah['id']);
      int lastIndex = list.length;
      num reverseIndex = lastIndex - surah['id'];
      tabController.animateTo(reverseIndex.toInt());
      goToIndex(surah, ayat);
    } catch (e) {
      print(e);
    }
  }

  void goToIndex(surah, ayat) async {
    try {
      if (itemScrollController.isAttached) {
        if (surah['id'] == detail['id']) {
          itemScrollController.scrollTo(
            index: int.parse(ayat) - 1,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      } else {
        Timer(Duration(seconds: 1), () {
          goToIndex(surah, ayat);
        });
      }
      isLoadingDetail.value = false;
    } catch (e) {
      print(e);
    }
  }

  @override
  void onInit() async {
    // scrollToIndex();
    super.onInit();
    await getData();
    if (dataStore.read('perAyatLastRead')['audio'] == null) {
      dataStore.write(
          'perAyatLastRead', {'audio': 'ar.alafasy', 'audiosource': 'server'});
    }
    list.value = list.reversed.toList();

    // int lastIndex = list.length;
    // int perAyatLastReadId = dataStore.read('perAyatLastRead')['id'] ?? 0;
    // int result =
    //     perAyatLastReadId > 0 ? lastIndex - perAyatLastReadId : lastIndex - 1;
    detail.value = list[myTabs.length - 1];
    print(detail);
    tabController = TabController(
        vsync: this, length: myTabs.length, initialIndex: myTabs.length - 1);
    await getDetailData(1, 0);
  }

  @override
  void onClose() {
    tabController.dispose();
    pageController.dispose();
    super.onClose();
  }
}
