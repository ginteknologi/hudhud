class SurahModel {
  final int id;
  final String nama;
  final String asma;
  final int jumlahAyat;
  final String tipe;
  final String arti;
  final String audioUrl;

  SurahModel({
    required this.id,
    required this.nama,
    this.asma = '',
    required this.jumlahAyat,
    this.tipe = '',
    this.arti = '',
    this.audioUrl = '',
  });

  factory SurahModel.fromJson(Map<String, dynamic> json) {
    return SurahModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? '1') ?? 1,
      nama: json['nama'] as String? ?? json['name'] as String? ?? '',
      asma: json['asma'] as String? ?? json['arabic'] as String? ?? '',
      jumlahAyat: json['ayat'] is int
          ? json['ayat'] as int
          : int.tryParse(json['ayat']?.toString() ?? '0') ?? 0,
      tipe: json['type'] as String? ?? '',
      arti: json['arti'] is Map ? (json['arti']['text'] ?? '') : json['arti']?.toString() ?? '',
      audioUrl: json['audio'] is Map ? (json['audio']['ar.alafasy'] ?? '') : json['audio']?.toString() ?? '',
    );
  }
}

class AyatModel {
  final int surat;
  final int ayat;
  final String arab;
  final String latin;
  final String arti;
  final String audioUrl;
  final bool isBookmarked;

  AyatModel({
    required this.surat,
    required this.ayat,
    required this.arab,
    this.latin = '',
    required this.arti,
    this.audioUrl = '',
    this.isBookmarked = false,
  });

  factory AyatModel.fromJson(Map<String, dynamic> json, {bool isBookmarked = false}) {
    String artiText = '';
    if (json['arti'] is Map) {
      artiText = json['arti']['text'] as String? ?? '';
    } else if (json['arti'] is String) {
      artiText = json['arti'] as String;
    }

    String audio = '';
    if (json['audio'] is Map) {
      audio = json['audio']['ar.alafasy'] as String? ?? '';
    } else if (json['audio'] is String) {
      audio = json['audio'] as String;
    }

    return AyatModel(
      surat: json['surat'] is int ? json['surat'] as int : int.tryParse(json['surat']?.toString() ?? '1') ?? 1,
      ayat: json['ayat'] is int ? json['ayat'] as int : int.tryParse(json['ayat']?.toString() ?? '1') ?? 1,
      arab: json['arab'] as String? ?? '',
      latin: json['latin_karakter'] as String? ?? json['latin'] as String? ?? '',
      arti: artiText,
      audioUrl: audio,
      isBookmarked: isBookmarked,
    );
  }

  AyatModel copyWith({bool? isBookmarked}) {
    return AyatModel(
      surat: surat,
      ayat: ayat,
      arab: arab,
      latin: latin,
      arti: arti,
      audioUrl: audioUrl,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }
}

class QuranPageItem {
  final int id;
  final String surat;
  final int hal;
  final String file;

  QuranPageItem({
    required this.id,
    required this.surat,
    required this.hal,
    required this.file,
  });

  factory QuranPageItem.fromJson(Map<String, dynamic> json) {
    return QuranPageItem(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? '1') ?? 1,
      surat: json['surat'] as String? ?? '',
      hal: json['hal'] is int ? json['hal'] as int : int.tryParse(json['hal']?.toString() ?? '1') ?? 1,
      file: json['file'] as String? ?? '',
    );
  }
}

class QuranBookmark {
  final String namaSurat;
  final int surat;
  final int ayat;
  final int totalAyat;

  QuranBookmark({
    required this.namaSurat,
    required this.surat,
    required this.ayat,
    this.totalAyat = 0,
  });

  factory QuranBookmark.fromJson(Map<String, dynamic> json) {
    return QuranBookmark(
      namaSurat: json['namaSurat'] as String? ?? 'Al-Fatihah',
      surat: json['surat'] is int ? json['surat'] as int : int.tryParse(json['surat']?.toString() ?? '1') ?? 1,
      ayat: json['ayat'] is int ? json['ayat'] as int : int.tryParse(json['ayat']?.toString() ?? '1') ?? 1,
      totalAyat: json['totalAyat'] is int ? json['totalAyat'] as int : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'namaSurat': namaSurat,
      'surat': surat,
      'ayat': ayat,
      'totalAyat': totalAyat,
    };
  }
}
