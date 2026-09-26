// Model v2 — Hadits flat structure (tanpa kitab/bab)

/// Data satu imam/perawi (dari GET /hadits)
class ImamData {
  final int imamId;
  final int imamSorting;
  final int hadits;
  final String longNama;
  final String namaTabel;

  const ImamData({
    required this.imamId,
    required this.imamSorting,
    required this.hadits,
    required this.longNama,
    required this.namaTabel,
  });

  factory ImamData.fromMap(Map<String, dynamic> map) {
    return ImamData(
      imamId: map['imamId'] as int? ?? 0,
      imamSorting: map['imamSorting'] as int? ?? 0,
      hadits: map['hadits'] as int? ?? 0,
      longNama: map['longNama'] as String? ?? '',
      namaTabel: map['namaTabel'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
        'imamId': imamId,
        'imamSorting': imamSorting,
        'hadits': hadits,
        'longNama': longNama,
        'namaTabel': namaTabel,
      };
}

/// Data satu hadits (dari GET /hadits/detail/:namaTabel)
class HaditsData {
  final int noHdt;
  final String isiArab;
  final String isiIndonesia;

  const HaditsData({
    required this.noHdt,
    required this.isiArab,
    required this.isiIndonesia,
  });

  factory HaditsData.fromMap(Map<String, dynamic> map) {
    return HaditsData(
      noHdt: map['NoHdt'] as int? ?? 0,
      isiArab: map['Isi_Arab'] as String? ?? '',
      isiIndonesia: map['Isi_Indonesia'] as String? ?? '',
    );
  }
}

/// Metadata pagination dari API
class HaditsPagination {
  final int page;
  final int limit;
  final int total;
  final int totalPages;

  const HaditsPagination({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });

  factory HaditsPagination.fromMap(Map<String, dynamic> map) {
    return HaditsPagination(
      page: map['page'] as int? ?? 1,
      limit: map['limit'] as int? ?? 20,
      total: map['total'] as int? ?? 0,
      totalPages: map['totalPages'] as int? ?? 1,
    );
  }
}

/// Hasil satu page hadits
class HaditsPageResult {
  final List<HaditsData> items;
  final HaditsPagination pagination;

  const HaditsPageResult({required this.items, required this.pagination});
}

// ----------------------------------------------------------------
// Model lama — dipertahankan agar file lain tidak compile error
// ----------------------------------------------------------------
class ListKitabData {
  int idKitab;
  int? noHdt;
  int? idBab;
  String kitabIndonesia;
  String? kitabArab;

  ListKitabData({
    required this.idKitab,
    required this.kitabIndonesia,
    this.kitabArab,
    this.noHdt,
    this.idBab,
  });
}

class ListBabData {
  int idBab;
  int idKitab;
  String babIndonesia;
  String babArab;

  ListBabData({
    required this.idBab,
    required this.idKitab,
    required this.babIndonesia,
    required this.babArab,
  });
}

class ListHadistData {
  int noHdt;
  int? idKitab;
  int? idBab;
  String isiIndonesia;
  String isiArab;

  ListHadistData({
    required this.noHdt,
    this.idBab,
    this.idKitab,
    required this.isiIndonesia,
    required this.isiArab,
  });
}