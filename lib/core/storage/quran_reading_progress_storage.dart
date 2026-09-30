import 'dart:convert';

import 'package:masjid_app/core/storage/preferences_service.dart';

enum QuranReadingMode { ayat, indonesia, madinah, tajwid }

class QuranReadingProgress {
  const QuranReadingProgress({
    required this.mode,
    required this.surahName,
    this.surahNumber = 0,
    this.ayatNumber = 0,
    this.pageNumber = 0,
  });

  final QuranReadingMode mode;
  final String surahName;
  final int surahNumber;
  final int ayatNumber;
  final int pageNumber;

  String get detail => switch (mode) {
        QuranReadingMode.ayat => 'Ayat $ayatNumber • Bacaan per ayat',
        QuranReadingMode.indonesia => 'Halaman $pageNumber • Mushaf Indonesia',
        QuranReadingMode.madinah => 'Halaman $pageNumber • Mushaf Madinah',
        QuranReadingMode.tajwid => 'Halaman $pageNumber • Mushaf Tajwid',
      };

  Map<String, dynamic> toJson() => {
        'mode': mode.name,
        'surahName': surahName,
        'surahNumber': surahNumber,
        'ayatNumber': ayatNumber,
        'pageNumber': pageNumber,
      };

  static QuranReadingProgress? fromJson(Map<String, dynamic> json) {
    final mode = QuranReadingMode.values.where((m) => m.name == json['mode']);
    if (mode.isEmpty) return null;
    final surahNumber = json['surahNumber'] as int? ?? 0;
    final ayatNumber = json['ayatNumber'] as int? ?? 0;
    final pageNumber = json['pageNumber'] as int? ?? 0;
    if (mode.first == QuranReadingMode.ayat &&
        (surahNumber <= 0 || ayatNumber <= 0)) {
      return null;
    }
    if (mode.first != QuranReadingMode.ayat && pageNumber <= 0) return null;
    return QuranReadingProgress(
      mode: mode.first,
      surahName: json['surahName'] as String? ?? '',
      surahNumber: surahNumber,
      ayatNumber: ayatNumber,
      pageNumber: pageNumber,
    );
  }
}

class QuranReadingProgressStorage {
  static const _key = 'quran_reading_progress_v1';

  static QuranReadingProgress? getLatest() {
    final raw = PreferencesService.getString(_key);
    if (raw == null) return null;
    try {
      final json = jsonDecode(raw);
      return json is Map<String, dynamic>
          ? QuranReadingProgress.fromJson(json)
          : null;
    } catch (_) {
      return null;
    }
  }

  static void save(QuranReadingProgress progress) {
    if (progress.mode == QuranReadingMode.ayat &&
        (progress.surahNumber <= 0 || progress.ayatNumber <= 0)) {
      return;
    }
    if (progress.mode != QuranReadingMode.ayat && progress.pageNumber <= 0) {
      return;
    }
    final current = getLatest();
    if (current != null &&
        jsonEncode(current.toJson()) == jsonEncode(progress.toJson())) {
      return;
    }
    PreferencesService.setString(_key, jsonEncode(progress.toJson()));
  }
}
