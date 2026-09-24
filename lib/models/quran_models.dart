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
      asma: json['asma'] as String? ?? json['arabic'] as String? ?? json['arab'] as String? ?? '',
      jumlahAyat: json['ayat'] is int
          ? json['ayat'] as int
          : int.tryParse(json['ayat']?.toString() ?? '0') ?? 0,
      tipe: json['type'] as String? ?? json['tipe'] as String? ?? '',
      arti: json['arti'] is Map ? (json['arti']['text'] ?? '') : json['arti']?.toString() ?? json['translation']?.toString() ?? '',
      audioUrl: json['audio'] is Map ? (json['audio']['ar.alafasy'] ?? '') : json['audio']?.toString() ?? '',
    );
  }
}

class AyatModel {
  final int surat;
  final int ayat;
  final String arab;
  final String latin;

  /// Teks aksara Arab versi Madinah — field `madinah` dari API
  /// (dipakai pembaca per-ayat, dulu `ListAyatData.madinah`).
  final String madinah;
  final String arti;
  final String audioUrl;
  final bool isBookmarked;

  AyatModel({
    required this.surat,
    required this.ayat,
    required this.arab,
    this.latin = '',
    this.madinah = '',
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
      madinah: json['madinah'] as String? ?? '',
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
      madinah: madinah,
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

class JuzModel {
  final int juzNumber;
  final String name;
  final String arabicName;
  final String startSurahName;
  final int startSurahNumber;
  final int startAyat;
  final int startPage;
  final int endPage;

  const JuzModel({
    required this.juzNumber,
    required this.name,
    required this.arabicName,
    required this.startSurahName,
    required this.startSurahNumber,
    required this.startAyat,
    required this.startPage,
    required this.endPage,
  });
}

const List<JuzModel> kQuranJuzList = [
  JuzModel(juzNumber: 1, name: 'Juz 1', arabicName: 'آلم', startSurahName: 'Al-Fatihah', startSurahNumber: 1, startAyat: 1, startPage: 1, endPage: 21),
  JuzModel(juzNumber: 2, name: 'Juz 2', arabicName: 'سَيَقُولُ', startSurahName: 'Al-Baqarah', startSurahNumber: 2, startAyat: 142, startPage: 22, endPage: 41),
  JuzModel(juzNumber: 3, name: 'Juz 3', arabicName: 'تِلْكَ الرُّسُلُ', startSurahName: 'Al-Baqarah', startSurahNumber: 2, startAyat: 253, startPage: 42, endPage: 61),
  JuzModel(juzNumber: 4, name: 'Juz 4', arabicName: 'لَنْ تَنَالُوا', startSurahName: 'Ali \'Imran', startSurahNumber: 3, startAyat: 93, startPage: 62, endPage: 81),
  JuzModel(juzNumber: 5, name: 'Juz 5', arabicName: 'وَالْمُحْصَنَاتُ', startSurahName: 'An-Nisa\'', startSurahNumber: 4, startAyat: 24, startPage: 82, endPage: 101),
  JuzModel(juzNumber: 6, name: 'Juz 6', arabicName: 'لَا يُحِبُّ اللَّهُ', startSurahName: 'An-Nisa\'', startSurahNumber: 4, startAyat: 148, startPage: 102, endPage: 121),
  JuzModel(juzNumber: 7, name: 'Juz 7', arabicName: 'وَإِذَا سَمِعُوا', startSurahName: 'Al-Ma\'idah', startSurahNumber: 5, startAyat: 82, startPage: 122, endPage: 141),
  JuzModel(juzNumber: 8, name: 'Juz 8', arabicName: 'وَلَوْ أَنَّنَا', startSurahName: 'Al-An\'am', startSurahNumber: 6, startAyat: 111, startPage: 142, endPage: 161),
  JuzModel(juzNumber: 9, name: 'Juz 9', arabicName: 'قَالَ الْمَلَأُ', startSurahName: 'Al-A\'raf', startSurahNumber: 7, startAyat: 88, startPage: 162, endPage: 181),
  JuzModel(juzNumber: 10, name: 'Juz 10', arabicName: 'وَاعْلَمُوا', startSurahName: 'Al-Anfal', startSurahNumber: 8, startAyat: 41, startPage: 182, endPage: 201),
  JuzModel(juzNumber: 11, name: 'Juz 11', arabicName: 'يَعْتَذِرُونَ', startSurahName: 'At-Taubah', startSurahNumber: 9, startAyat: 93, startPage: 202, endPage: 221),
  JuzModel(juzNumber: 12, name: 'Juz 12', arabicName: 'وَمَا مِنْ دَابَّةٍ', startSurahName: 'Hud', startSurahNumber: 11, startAyat: 6, startPage: 222, endPage: 241),
  JuzModel(juzNumber: 13, name: 'Juz 13', arabicName: 'وَمَا أُبَرِّئُ', startSurahName: 'Yusuf', startSurahNumber: 12, startAyat: 53, startPage: 242, endPage: 261),
  JuzModel(juzNumber: 14, name: 'Juz 14', arabicName: 'رُبَمَا', startSurahName: 'Al-Hijr', startSurahNumber: 15, startAyat: 1, startPage: 262, endPage: 281),
  JuzModel(juzNumber: 15, name: 'Juz 15', arabicName: 'سُبْحَانَ الَّذِي', startSurahName: 'Al-Isra\'', startSurahNumber: 17, startAyat: 1, startPage: 282, endPage: 301),
  JuzModel(juzNumber: 16, name: 'Juz 16', arabicName: 'قَالَ أَلَمْ', startSurahName: 'Al-Kahf', startSurahNumber: 18, startAyat: 75, startPage: 302, endPage: 321),
  JuzModel(juzNumber: 17, name: 'Juz 17', arabicName: 'اقْتَرَبَ', startSurahName: 'Al-Anbiya\'', startSurahNumber: 21, startAyat: 1, startPage: 322, endPage: 341),
  JuzModel(juzNumber: 18, name: 'Juz 18', arabicName: 'قَدْ أَفْلَحَ', startSurahName: 'Al-Mu\'minun', startSurahNumber: 23, startAyat: 1, startPage: 342, endPage: 361),
  JuzModel(juzNumber: 19, name: 'Juz 19', arabicName: 'وَقَالَ الَّذِينَ', startSurahName: 'Al-Furqan', startSurahNumber: 25, startAyat: 21, startPage: 362, endPage: 381),
  JuzModel(juzNumber: 20, name: 'Juz 20', arabicName: 'أَمَّنْ خَلَقَ', startSurahName: 'An-Naml', startSurahNumber: 27, startAyat: 56, startPage: 382, endPage: 401),
  JuzModel(juzNumber: 21, name: 'Juz 21', arabicName: 'اتْلُ مَا أُوحِيَ', startSurahName: 'Al-\'Ankabut', startSurahNumber: 29, startAyat: 46, startPage: 402, endPage: 421),
  JuzModel(juzNumber: 22, name: 'Juz 22', arabicName: 'وَمَنْ يَقْنُتْ', startSurahName: 'Al-Ahzab', startSurahNumber: 33, startAyat: 31, startPage: 422, endPage: 441),
  JuzModel(juzNumber: 23, name: 'Juz 23', arabicName: 'وَمَا لِيَ', startSurahName: 'Ya-Sin', startSurahNumber: 36, startAyat: 28, startPage: 442, endPage: 461),
  JuzModel(juzNumber: 24, name: 'Juz 24', arabicName: 'فَمَنْ أَظْلَمُ', startSurahName: 'Az-Zumar', startSurahNumber: 39, startAyat: 32, startPage: 462, endPage: 481),
  JuzModel(juzNumber: 25, name: 'Juz 25', arabicName: 'إِلَيْهِ يُرَدُّ', startSurahName: 'Fussilat', startSurahNumber: 41, startAyat: 47, startPage: 482, endPage: 501),
  JuzModel(juzNumber: 26, name: 'Juz 26', arabicName: 'حم', startSurahName: 'Al-Ahqaf', startSurahNumber: 46, startAyat: 1, startPage: 502, endPage: 521),
  JuzModel(juzNumber: 27, name: 'Juz 27', arabicName: 'قَالَ فَمَا خَطْبُكُمْ', startSurahName: 'Az-Zariyat', startSurahNumber: 51, startAyat: 31, startPage: 522, endPage: 541),
  JuzModel(juzNumber: 28, name: 'Juz 28', arabicName: 'قَدْ سَمِعَ اللَّهُ', startSurahName: 'Al-Mujadilah', startSurahNumber: 58, startAyat: 1, startPage: 542, endPage: 561),
  JuzModel(juzNumber: 29, name: 'Juz 29', arabicName: 'تَبَارَكَ الَّذِي', startSurahName: 'Al-Mulk', startSurahNumber: 67, startAyat: 1, startPage: 562, endPage: 581),
  JuzModel(juzNumber: 30, name: 'Juz 30', arabicName: 'عَمَّ يَتَسَاءَلُونَ', startSurahName: 'An-Naba\'', startSurahNumber: 78, startAyat: 1, startPage: 582, endPage: 604),
];
