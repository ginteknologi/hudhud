import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

/// State halaman Pengaturan Alquran.
///
/// Pengganti field `.obs` milik `AlquranPengaturanController` (GetX):
/// `isLoadingList`, `paused`, `cancelled`, `download`, `totalTerDownload`,
/// `progresDownload`, `persenDownload`.
class QuranDownloadState {
  const QuranDownloadState({
    this.isLoadingList = false,
    this.paused = false,
    this.cancelled = false,
    this.download = false,
    this.totalTerDownload = 0,
    this.progresDownload = 0.0,
    this.persenDownload = 0,
  });

  final bool isLoadingList;
  final bool paused;
  final bool cancelled;
  final bool download;
  final int totalTerDownload;
  final double progresDownload;
  final int persenDownload;

  QuranDownloadState copyWith({
    bool? isLoadingList,
    bool? paused,
    bool? cancelled,
    bool? download,
    int? totalTerDownload,
    double? progresDownload,
    int? persenDownload,
  }) {
    return QuranDownloadState(
      isLoadingList: isLoadingList ?? this.isLoadingList,
      paused: paused ?? this.paused,
      cancelled: cancelled ?? this.cancelled,
      download: download ?? this.download,
      totalTerDownload: totalTerDownload ?? this.totalTerDownload,
      progresDownload: progresDownload ?? this.progresDownload,
      persenDownload: persenDownload ?? this.persenDownload,
    );
  }
}

/// Unduh gambar mushaf (halaman / madinah / tajwid) ke dokumen aplikasi.
///
/// Port langsung dari `AlquranPengaturanController.downloadFile` GetX —
/// jalur file (`dart:io` + `path_provider`) dipertahankan apa adanya.
class QuranDownloadNotifier extends StateNotifier<QuranDownloadState> {
  QuranDownloadNotifier() : super(const QuranDownloadState());

  Future<void> downloadFile(String type) async {
    try {
      if (kDebugMode) {
        debugPrint(state.paused.toString());
      }
      String jsonString;
      state = state.copyWith(download: true);
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
      final listSurah = json.decode(jsonString) as List<dynamic>;
      final String dir = (await getApplicationDocumentsDirectory()).path;
      final String filePath = '$dir/quran/$type';
      if (kDebugMode) {
        debugPrint(filePath);
      }
      final directory = Directory(filePath);
      if (await directory.exists()) {
        if (kDebugMode) {
          debugPrint('Folder ada');
        }
      } else {
        await directory.create(recursive: true);
      }
      for (var i = 0; i < listSurah.length; i++) {
        if (state.cancelled) {
          // Jika cancel, keluar dari perulangan
          break;
        }
        while (state.paused) {
          // Jika di-pause, tunggu sampai tidak di-pause lagi
          await Future.delayed(const Duration(seconds: 1));
        }
        final element = listSurah[i] as Map<String, dynamic>;
        final response = await http.get(Uri.parse(element['file'] as String));
        final bytes = response.bodyBytes;
        final file = File('$filePath/${element['hal']}.jpg');
        await file.writeAsBytes(bytes);
        final total = state.totalTerDownload + 1;
        final progres = total / listSurah.length;
        state = state.copyWith(
          totalTerDownload: total,
          progresDownload: progres,
          persenDownload: (progres * 100).toInt(),
          download: i == listSurah.length - 1 ? false : state.download,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint(e.toString());
      }
    }
  }

  // Fungsi untuk pause download
  void pauseDownload() {
    state = state.copyWith(paused: true);
  }

  // Fungsi untuk resume download
  void resumeDownload() {
    state = state.copyWith(paused: false);
  }

  // Fungsi untuk cancel download
  void cancelDownload() {
    state = state.copyWith(cancelled: true);
  }
}

final quranDownloadProvider =
    StateNotifierProvider<QuranDownloadNotifier, QuranDownloadState>(
        (ref) => QuranDownloadNotifier());
