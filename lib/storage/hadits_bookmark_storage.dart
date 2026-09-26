import 'dart:convert';

import 'package:masjid_app/core/storage/preferences_service.dart';

/// Satu entri tersimpan: hadits yang dibuka (riwayat) dan/atau di-bookmark.
///
/// Riwayat dan bookmark sengaja satu daftar — bookmark = entri riwayat yang
/// di-pin (`isBookmark`). Satu key, satu notifier, satu urutan.
class HaditsBookmarkData {
  final String namaTabel;
  final String longNama;

  /// Field warisan v1. Tidak pernah dipakai untuk routing lagi.
  final int idKitab;
  final String kitabIndonesia;
  final int? idBab;
  final String? babIndonesia;

  final int noHdt;
  final int totalHadits;
  final String? snippet;

  /// Milidetik saat entri terakhir disentuh. 0 = data lama tanpa stempel.
  final int savedAt;

  /// true = di-bookmark user, false = hanya riwayat baca.
  final bool isBookmark;

  const HaditsBookmarkData({
    required this.namaTabel,
    required this.longNama,
    this.idKitab = 0,
    this.kitabIndonesia = '',
    this.idBab,
    this.babIndonesia,
    required this.noHdt,
    this.totalHadits = 0,
    this.snippet,
    this.savedAt = 0,
    this.isBookmark = false,
  });

  bool get isValid => namaTabel.isNotEmpty && noHdt > 0;

  HaditsBookmarkData copyWith({
    String? longNama,
    String? babIndonesia,
    int? totalHadits,
    String? snippet,
    int? savedAt,
    bool? isBookmark,
  }) {
    return HaditsBookmarkData(
      namaTabel: namaTabel,
      longNama: longNama ?? this.longNama,
      idKitab: idKitab,
      kitabIndonesia: kitabIndonesia,
      idBab: idBab,
      babIndonesia: babIndonesia ?? this.babIndonesia,
      noHdt: noHdt,
      totalHadits: totalHadits ?? this.totalHadits,
      snippet: snippet ?? this.snippet,
      savedAt: savedAt ?? this.savedAt,
      isBookmark: isBookmark ?? this.isBookmark,
    );
  }

  Map<String, dynamic> toJson() => {
        'namaTabel': namaTabel,
        'longNama': longNama,
        'idKitab': idKitab,
        'kitabIndonesia': kitabIndonesia,
        'idBab': idBab,
        'babIndonesia': babIndonesia,
        'noHdt': noHdt,
        'totalHadits': totalHadits,
        'snippet': snippet,
        'savedAt': savedAt,
        'isBookmark': isBookmark,
      };

  factory HaditsBookmarkData.fromJson(Map<String, dynamic> json) {
    return HaditsBookmarkData(
      namaTabel: json['namaTabel'] as String? ?? '',
      longNama: json['longNama'] as String? ?? '',
      idKitab: json['idKitab'] as int? ?? 0,
      kitabIndonesia: json['kitabIndonesia'] as String? ?? '',
      idBab: json['idBab'] as int?,
      babIndonesia: json['babIndonesia'] as String?,
      noHdt: json['noHdt'] as int? ?? 0,
      totalHadits: json['totalHadits'] as int? ?? 0,
      snippet: json['snippet'] as String?,
      savedAt: json['savedAt'] as int? ?? 0,
      isBookmark: json['isBookmark'] as bool? ?? false,
    );
  }
}

class HaditsBookmarkStorage {
  /// Key daftar baru. Data lama (9 key flat) dimigrasi sekali ke sini.
  static const String _keyList = 'hadits_saved_v2';
  static const String _prefix = 'hadits_last_read';

  /// Batas entri riwayat. Bookmark tidak pernah dibuang.
  static const int _maxEntries = 100;

  static String _identity(String namaTabel, int noHdt) => '$namaTabel#$noHdt';

  /// Semua entri, terbaru dulu.
  static List<HaditsBookmarkData> getAll() {
    final raw = PreferencesService.getString(_keyList);
    if (raw == null || raw.isEmpty) {
      final migrated = _migrateLegacy();
      return migrated ?? [];
    }
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return [];
      final list = decoded
          .whereType<Map>()
          .map((e) => HaditsBookmarkData.fromJson(Map<String, dynamic>.from(e)))
          .where((e) => e.isValid)
          .toList();
      list.sort((a, b) => b.savedAt.compareTo(a.savedAt));
      return list;
    } catch (_) {
      // Data rusak — mulai dari kosong daripada crash.
      return [];
    }
  }

  static List<HaditsBookmarkData> getBookmarks() =>
      getAll().where((e) => e.isBookmark).toList();

  /// Riwayat baca: semua entri termasuk yang di-bookmark.
  static List<HaditsBookmarkData> getHistory() => getAll();

  /// Entri terbaru (dipakai kartu "Terakhir Dibaca").
  static HaditsBookmarkData? getBookmark() {
    final all = getAll();
    return all.isEmpty ? null : all.first;
  }

  static int? getSavedAt(String namaTabel, int noHdt) {
    for (final e in getAll()) {
      if (e.namaTabel == namaTabel && e.noHdt == noHdt) return e.savedAt;
    }
    return null;
  }

  /// Simpan/ulangi sebagai bookmark.
  static void saveBookmark(HaditsBookmarkData data) {
    if (!data.isValid) return;
    _upsert(data.copyWith(savedAt: _now(), isBookmark: true));
  }

  /// Catat sebagai riwayat baca. Kalau entri sudah ada dan di-bookmark,
  /// status bookmark-nya dipertahankan.
  static void markRead(HaditsBookmarkData data) {
    if (!data.isValid) return;
    final existing = _find(data.namaTabel, data.noHdt);
    _upsert(
      data.copyWith(
        savedAt: _now(),
        isBookmark: existing?.isBookmark ?? false,
        snippet: data.snippet ?? existing?.snippet,
      ),
    );
  }

  /// Lepas bookmark tapi entri tetap ada sebagai riwayat baca.
  static void unbookmark(String namaTabel, int noHdt) {
    final list = getAll();
    for (var i = 0; i < list.length; i++) {
      final e = list[i];
      if (e.namaTabel == namaTabel && e.noHdt == noHdt) {
        list[i] = e.copyWith(isBookmark: false, savedAt: _now());
      }
    }
    _write(list);
  }

  static void remove(String namaTabel, int noHdt) {
    final list = getAll()
      ..removeWhere((e) => e.namaTabel == namaTabel && e.noHdt == noHdt);
    _write(list);
  }

  static void clear() {
    _write([]);
  }

  static HaditsBookmarkData? _find(String namaTabel, int noHdt) {
    for (final e in getAll()) {
      if (e.namaTabel == namaTabel && e.noHdt == noHdt) return e;
    }
    return null;
  }

  static void _upsert(HaditsBookmarkData data) {
    final id = _identity(data.namaTabel, data.noHdt);
    final list = getAll()
      ..removeWhere((e) => _identity(e.namaTabel, e.noHdt) == id)
      ..add(data);
    _write(list);
  }

  static void _write(List<HaditsBookmarkData> list) {
    list.sort((a, b) => b.savedAt.compareTo(a.savedAt));
    _prune(list);
    PreferencesService.setString(
      _keyList,
      jsonEncode(list.map((e) => e.toJson()).toList()),
    );
  }

  /// Buang entri riwayat paling lama kalau melebihi batas. Bookmark aman.
  static void _prune(List<HaditsBookmarkData> list) {
    if (list.length <= _maxEntries) return;
    final overflow = list.length - _maxEntries;
    var removed = 0;
    for (var i = list.length - 1; i >= 0 && removed < overflow; i--) {
      if (!list[i].isBookmark) {
        list.removeAt(i);
        removed++;
      }
    }
  }

  static int _now() => DateTime.now().millisecondsSinceEpoch;

  /// Pindahkan 9 key flat v1 ke daftar baru. Sekali saja.
  static List<HaditsBookmarkData>? _migrateLegacy() {
    final namaTabel = PreferencesService.getString('${_prefix}_namaTabel');
    final noHdt = PreferencesService.getInt('${_prefix}_noHdt');
    if (namaTabel == null || namaTabel.isEmpty || noHdt == null || noHdt <= 0) {
      return null;
    }
    final entry = HaditsBookmarkData(
      namaTabel: namaTabel,
      longNama: PreferencesService.getString('${_prefix}_longNama') ?? '',
      idKitab: PreferencesService.getInt('${_prefix}_idKitab') ?? 0,
      kitabIndonesia: PreferencesService.getString('${_prefix}_kitabIndonesia') ?? '',
      idBab: PreferencesService.getInt('${_prefix}_idBab'),
      babIndonesia: PreferencesService.getString('${_prefix}_babIndonesia'),
      noHdt: noHdt,
      totalHadits: PreferencesService.getInt('${_prefix}_totalHadits') ?? 0,
      snippet: PreferencesService.getString('${_prefix}_snippet'),
      savedAt: _now(),
      isBookmark: true,
    );
    _write([entry]);
    for (final suffix in const [
      'namaTabel',
      'longNama',
      'idKitab',
      'kitabIndonesia',
      'idBab',
      'babIndonesia',
      'noHdt',
      'totalHadits',
      'snippet',
    ]) {
      PreferencesService.remove('${_prefix}_$suffix');
    }
    return [entry];
  }
}
