import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:masjid_app/models/bookmarkData.dart';
import 'package:masjid_app/models/listayatData.dart';
import 'package:masjid_app/pages/quran/quran_service.dart';
import 'package:get_storage/get_storage.dart';
import 'package:masjid_app/configs/main_controller.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ListAyatQuranController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final player = AudioPlayer();
  RxList<AudioSource> listAudio = <AudioSource>[].obs;
  var isPlaySound = false.obs;
  final dataStore = GetStorage();
  final gctrl = Get.find<MainController>();
  final surahId = Get.parameters['id'];
  final surahName = Get.parameters['nama_surah'];
  var isLoadingList = true.obs;
  var isLoadingDetail = false.obs;

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
  late PageController pageController;
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
          'list': <listayatData>[],
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
    var ddd = list.indexWhere((element) => element['nama'] == inputSurah.text);
    var getSurah = list.where((p0) => p0['nama'] == inputSurah.text).first;
    var newindex = myTabs.length - ddd - 1;
    await getDetailData(surahId: getSurah['id']);
    pageController.jumpToPage(newindex);
    await Future.delayed(Duration(milliseconds: 100));
    itemScrollController[newindex].jumpTo(
      index: int.parse(inputAyat.text) - 1,
    );
    Get.back();
  }

  Future<void> getDetailData({
    required surahId,
    jumpto = 0,
  }) async {
    try {
      int targetDataIndex =
          contentTab.indexWhere((data) => data["idContent"] == surahId);
      int cek = contentTab[targetDataIndex]['list'].length;
      bookmarkData resultBookmark = gctrl.ayatBookmark.value;
      if (cek == 0) {
        print('fetch detail');
        print(cek);
        print(surahId);
        isLoadingDetail.value = true;
        final result = await QuranService().getDetail(surahId.toString());
        for (var i = 0; i < result['data']['list'].length; i++) {
          var dataitem = result['data']['list'][i];

          contentTab[targetDataIndex]['list'].add(listayatData(
              initialBook: resultBookmark.surat == surahId &&
                  resultBookmark.ayat == dataitem['ayat'],
              surat: dataitem['surat'],
              ayat: dataitem['ayat'],
              arab: dataitem['arab'],
              madinah: dataitem['madinah'],
              latin_karakter: dataitem['latin_karakter'],
              alafasy: dataitem['audio']['ar.alafasy'],
              arti: dataitem['arti']['text']));
        }
        isLoadingDetail.value = false;
        if (jumpto > 0) {
          // delay
          await Future.delayed(Duration(milliseconds: 100));
          if (itemScrollController[targetDataIndex].isAttached) {
            itemScrollController[targetDataIndex].jumpTo(
              index: jumpto,
            );
          }
          // print(itemScrollController[targetDataIndex].isAttached);
        }
      } else {
        if (resultBookmark.surat == surahId) {
          for (var i = 0; i < contentTab[targetDataIndex]['list'].length; i++) {
            if (resultBookmark.ayat ==
                contentTab[targetDataIndex]['list'][i].ayat) {
              contentTab[targetDataIndex]['list'][i].book.value = true;
            } else {
              contentTab[targetDataIndex]['list'][i].book.value = false;
            }
          }
        } else {
          for (var i = 0; i < contentTab[targetDataIndex]['list'].length; i++) {
            contentTab[targetDataIndex]['list'][i].book.value = false;
          }
        }
      }
    } catch (e) {
      print(e);
    }
  }

  playMurotal(listayatData item) async {
    try {
      int targetDataIndex =
          contentTab.indexWhere((data) => data["idContent"] == item.surat);

      List<listayatData> listAyat = contentTab[targetDataIndex]['list'];
      listAudio.value = [];
      int defaultInit = 0;
      for (var i = 0; i < listAyat.length; i++) {
        if ((listAyat[i].ayat) == (item.ayat)) {
          defaultInit = i;
        }
        listAudio.add(AudioSource.uri(Uri.parse(listAyat[i].alafasy)));
      }
      final playlist = ConcatenatingAudioSource(
        useLazyPreparation: true,
        children: listAudio,
      );
      await player.setAudioSource(playlist,
          initialIndex: defaultInit, initialPosition: Duration.zero);
      player.play();
      player.currentIndexStream.listen((event) {
        if (event != null) {
          itemScrollController[targetDataIndex].jumpTo(
            index: event,
          );
        }
      });

      player.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          isPlaySound.value = false;
          listAudio.value = [];
        }
      });

      isPlaySound.value = true;
    } catch (e) {
      print("error murotal");
      print(e);
    }
  }

  changeTabIndex(index) async {
    tabIndex.value = index;
    detail.value = list[index];
    await getDetailData(surahId: detail['id']);
    update();
  }

  Future<void> bookmark(listayatData data) async {
    try {
      isLoadingDetail.value = true;
      int targetDataIndex = list.indexWhere((z) => z["id"] == data.surat);
      int targetSuratIndex =
          contentTab.indexWhere((z) => z["idContent"] == data.surat);

      int getIndexListAyat = contentTab[targetSuratIndex]['list']
          .indexWhere((element) => element.ayat == data.ayat);

      for (var i = 0; i < contentTab[targetSuratIndex]['list'].length; i++) {
        contentTab[targetSuratIndex]['list'][i].book.value = false;
      }
      contentTab[targetSuratIndex]['list'][getIndexListAyat].book.value = true;
      var detail = list[targetDataIndex];

      gctrl.ayatBookmark.value = bookmarkData(
          namaSurat: detail['nama'],
          surat: data.surat,
          ayat: data.ayat,
          totalAyat: detail['ayat']);

      Fluttertoast.showToast(
          msg: "Ayat Berhasil Ditandai",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black54,
          textColor: Colors.white,
          fontSize: Get.width / 30);

      isLoadingDetail.value = false;
      update();
    } catch (e) {
      print("error bookmark");
      print(e);
    }
  }

  @override
  void onInit() async {
    super.onInit();
    await getData();
    // if (dataStore.read('perAyatLastRead')['audio'] == null) {
    //   dataStore.write(
    //       'perAyatLastRead', {'audio': 'ar.alafasy', 'audiosource': 'server'});
    // }
    list.value = list.reversed.toList();
    final bookmarkData book = gctrl.ayatBookmark.value;
    if (Get.parameters['bookmarks'] == "true" && book.surat != 0) {
      int getindexbysurah =
          list.indexWhere((element) => element['id'] == book.surat);
      int newindex = myTabs.length - 1 - getindexbysurah;
      pageController = PageController(initialPage: newindex);
      detail.value = list[getindexbysurah];
      tabController = TabController(
          vsync: this, length: myTabs.length, initialIndex: getindexbysurah);
      await getDetailData(surahId: book.surat, jumpto: book.ayat - 1);
    } else {
      detail.value = list[myTabs.length - 1];
      pageController = PageController(initialPage: 0);
      tabController = TabController(
          vsync: this, length: myTabs.length, initialIndex: myTabs.length - 1);
      await getDetailData(surahId: 1);
    }
  }

  @override
  void onClose() {
    tabController.dispose();
    pageController.dispose();
    player.stop();
    super.onClose();
  }
}
