// Model v3 — Hadits: Kitab (imam) → Bab → Hadits, plus tema.

/// Data satu imam/perawi (dari GET /hadits)
class ImamData {
  final int imamId;
  final int imamSorting;
  final int hadits;
  final String longNama;
  final String namaTabel;

  /// Jumlah bab kitab ini. 0 = kitab belum punya level bab, layar bab dilewati.
  final int babCount;

  const ImamData({
    required this.imamId,
    required this.imamSorting,
    required this.hadits,
    required this.longNama,
    required this.namaTabel,
    this.babCount = 0,
  });

  factory ImamData.fromMap(Map<String, dynamic> map) {
    return ImamData(
      imamId: map['imamId'] as int? ?? 0,
      imamSorting: map['imamSorting'] as int? ?? 0,
      hadits: map['hadits'] as int? ?? 0,
      longNama: map['longNama'] as String? ?? '',
      namaTabel: map['namaTabel'] as String? ?? '',
      babCount: map['babCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
        'imamId': imamId,
        'imamSorting': imamSorting,
        'hadits': hadits,
        'longNama': longNama,
        'namaTabel': namaTabel,
        'babCount': babCount,
      };
}

/// Data satu hadits (dari GET /hadits/detail/:namaTabel atau /hadits/search)
class HaditsData {
  /// Diisi pada hasil pencarian; daftar per kitab mengabaikannya.
  final String namaTabel;
  final int noHdt;
  final String isiArab;
  final String isiIndonesia;

  const HaditsData({
    this.namaTabel = '',
    required this.noHdt,
    required this.isiArab,
    required this.isiIndonesia,
  });

  factory HaditsData.fromMap(Map<String, dynamic> map) {
    return HaditsData(
      namaTabel: map['namaTabel'] as String? ?? '',
      noHdt: map['NoHdt'] as int? ?? 0,
      isiArab: map['Isi_Arab'] as String? ?? '',
      isiIndonesia: map['Isi_Indonesia'] as String? ?? '',
    );
  }
}

/// Satu bab dalam kitab (dari GET /hadits/bab/:namaTabel)
class HaditsBab {
  final int id;
  final String nama;
  final String? namaArab;
  final int urutan;
  final int noAwal;
  final int noAkhir;

  const HaditsBab({
    required this.id,
    required this.nama,
    this.namaArab,
    required this.urutan,
    required this.noAwal,
    required this.noAkhir,
  });

  factory HaditsBab.fromMap(Map<String, dynamic> map) {
    return HaditsBab(
      id: map['id'] as int? ?? 0,
      nama: map['nama'] as String? ?? '',
      namaArab: map['namaArab'] as String?,
      urutan: map['urutan'] as int? ?? 0,
      noAwal: map['noAwal'] as int? ?? 0,
      noAkhir: map['noAkhir'] as int? ?? 0,
    );
  }
}

/// Kategori tema (dari GET /hadits/tema) — jumlah = banyak hadits di dalamnya
class HaditsTema {
  final int id;
  final String nama;
  final int jumlah;

  const HaditsTema({required this.id, required this.nama, this.jumlah = 0});

  factory HaditsTema.fromMap(Map<String, dynamic> map) {
    return HaditsTema(
      id: map['id'] as int? ?? 0,
      nama: map['nama'] as String? ?? '',
      jumlah: map['jumlah'] as int? ?? 0,
    );
  }
}

/// Satu hadits dalam koleksi tema (dari GET /hadits/tema/:id)
class HaditsKoleksi {
  final int id;
  final String judul;
  final String arab;
  final String indo;

  const HaditsKoleksi({
    required this.id,
    required this.judul,
    required this.arab,
    required this.indo,
  });

  factory HaditsKoleksi.fromMap(Map<String, dynamic> map) {
    return HaditsKoleksi(
      id: map['id'] as int? ?? 0,
      judul: map['judul'] as String? ?? '',
      arab: map['arab'] as String? ?? '',
      indo: map['indo'] as String? ?? '',
    );
  }
}

/// Metadata pagination dari API (ada di root response, bukan di dalam `data`)
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
