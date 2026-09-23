class DoaCategoryModel {
  final int id;
  final String nama;
  final String icon;

  DoaCategoryModel({
    required this.id,
    required this.nama,
    this.icon = '',
  });

  factory DoaCategoryModel.fromJson(Map<String, dynamic> json) {
    return DoaCategoryModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? '1') ?? 1,
      nama: json['nama'] as String? ?? json['name'] as String? ?? '',
      icon: json['icon'] as String? ?? '',
    );
  }
}

class DoaItemModel {
  final int id;
  final String judul;
  final String arab;
  final String latin;
  final String arti;
  final String riwayat;

  DoaItemModel({
    required this.id,
    required this.judul,
    required this.arab,
    this.latin = '',
    required this.arti,
    this.riwayat = '',
  });

  factory DoaItemModel.fromJson(Map<String, dynamic> json) {
    return DoaItemModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? '1') ?? 1,
      judul: json['judul'] as String? ?? json['title'] as String? ?? '',
      arab: json['arab'] as String? ?? json['arabic'] as String? ?? '',
      latin: json['latin'] as String? ?? '',
      arti: json['arti'] as String? ?? json['translation'] as String? ?? '',
      riwayat: json['riwayat'] as String? ?? json['source'] as String? ?? '',
    );
  }
}

class DzikirItemModel {
  final int id;
  final String judul;
  final String arab;
  final String arti;
  final int targetCount;
  final String waktu; // pagi, petang, solat

  DzikirItemModel({
    required this.id,
    required this.judul,
    required this.arab,
    required this.arti,
    this.targetCount = 33,
    this.waktu = 'solat',
  });

  factory DzikirItemModel.fromJson(Map<String, dynamic> json) {
    return DzikirItemModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? '1') ?? 1,
      judul: json['judul'] as String? ?? '',
      arab: json['arab'] as String? ?? '',
      arti: json['arti'] as String? ?? '',
      targetCount: json['count'] is int ? json['count'] as int : 33,
      waktu: json['waktu'] as String? ?? 'solat',
    );
  }
}
