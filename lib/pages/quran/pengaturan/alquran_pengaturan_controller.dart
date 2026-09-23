import "dart:io";
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:masjid_app/controllers/main_controller.dart';
import 'package:flutter/services.dart';

class AlquranPengaturanController extends GetxController {
  final dataStore = GetStorage();
  final gctrl = Get.find<MainController>();
  var isLoadingList = false.obs;

  var paused = false.obs;
  var cancelled = false.obs;
  var download = false.obs;
  var fileSource = "".obs;
  var totalTerDownload = 0.obs;
  var progresDownload = 0.0.obs;
  var persenDownload = 0.obs;

  void downloadFile(String type) async {
    try {
      if (kDebugMode) {
        debugPrint(paused.value.toString());
      }
      String jsonString = '';
      download.value = true;
      if (type == 'halaman') {
        jsonString =
            await rootBundle.loadString('assets/img/quran/quran-page.json');
      } else if (type == 'madinah') {
        jsonString = await rootBundle
            .loadString('assets/img/quran/quran-page-madinah.json');
      } else {
        jsonString = await rootBundle
            .loadString('assets/img/quran/quran-page-tajwid.json');
      }
      final listSurah = json.decode(jsonString);
      String dir = (await getApplicationDocumentsDirectory()).path;
      String filePath = '$dir/quran/$type';
      if (kDebugMode) {
        debugPrint(filePath.toString());
      }
      Directory directory = Directory(filePath);
      bool exists = await directory.exists();
      if (exists) {
        if (kDebugMode) {
          debugPrint('Folder ada');
        }
      } else {
        directory.create(recursive: true);
      }
      for (var i = 0; i < listSurah.length; i++) {
        if (cancelled.value) {
          // Jika cancel, keluar dari perulangan
          break;
        }
        while (paused.value) {
          // Jika di-pause, tunggu sampai tidak di-pause lagi
          await Future.delayed(Duration(seconds: 1));
        }
        var element = listSurah[i];
        var response = await http.get(Uri.parse(element['file']));
        var bytes = response.bodyBytes;
        File file = File('$filePath/${element['hal']}.jpg');
        await file.writeAsBytes(bytes);
        totalTerDownload++;
        progresDownload.value = (totalTerDownload / listSurah.length);
        persenDownload.value = (progresDownload * 100).toInt();
        if (kDebugMode) {
          debugPrint(progresDownload.toString());
        }
        if (kDebugMode) {
          debugPrint(persenDownload.toString());
        }
        if (i == listSurah.length - 1) {
          download.value = false;
          if (kDebugMode) {
            debugPrint(download.toString());
          }
        }
      }
      if (kDebugMode) {
        debugPrint(listSurah.toString());
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint(e.toString());
      }
    }
  }

  // Fungsi untuk pause download
  void pauseDownload() {
    paused.value = true;
  }

  // Fungsi untuk resume download
  void resumeDownload() {
    paused.value = false;
  }

  // Fungsi untuk cancel download
  void cancelDownload() {
    cancelled.value = true;
  }

}
