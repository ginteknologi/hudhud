class HaditsBookModel {
  final int id;
  final String nama;
  final String namaArab;
  final int totalHadits;

  HaditsBookModel({
    required this.id,
    required this.nama,
    this.namaArab = '',
    this.totalHadits = 0,
  });

  factory HaditsBookModel.fromJson(Map<String, dynamic> json) {
    return HaditsBookModel(
      id: json['ID_Kitab'] is int
          ? json['ID_Kitab'] as int
          : (json['id'] is int ? json['id'] as int : int.tryParse(json['ID_Kitab']?.toString() ?? json['id']?.toString() ?? '1') ?? 1),
      nama: json['Kitab_Indonesia'] as String? ?? json['nama'] as String? ?? '',
      namaArab: json['Kitab_Arab'] as String? ?? json['nama_arab'] as String? ?? '',
      totalHadits: json['total'] is int ? json['total'] as int : 0,
    );
  }
}

class HaditsItemModel {
  final int no;
  final int bookId;
  final String arab;
  final String arti;

  HaditsItemModel({
    required this.no,
    this.bookId = 1,
    required this.arab,
    required this.arti,
  });

  factory HaditsItemModel.fromJson(Map<String, dynamic> json) {
    return HaditsItemModel(
      no: json['NoHdt'] is int
          ? json['NoHdt'] as int
          : (json['no'] is int ? json['no'] as int : int.tryParse(json['NoHdt']?.toString() ?? json['no']?.toString() ?? '1') ?? 1),
      bookId: json['ID_Kitab'] is int ? json['ID_Kitab'] as int : 1,
      arab: json['Isi_Arab'] as String? ?? json['arab'] as String? ?? '',
      arti: json['Isi_Indonesia'] as String? ?? json['arti'] as String? ?? '',
    );
  }
}
