class KajianModel {
  final int id;
  final String judul;
  final String ustadz;
  final String subjudul;
  final String image;
  final String link;
  final String type; // tafsir / live / muadzin / doa_ramadhan / quotes

  KajianModel({
    required this.id,
    required this.judul,
    this.ustadz = '',
    this.subjudul = '',
    required this.image,
    this.link = '',
    this.type = 'list',
  });

  factory KajianModel.fromJson(Map<String, dynamic> json) {
    return KajianModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? '1') ?? 1,
      judul: json['judul'] as String? ?? json['title'] as String? ?? '',
      ustadz: json['ustadz'] as String? ?? json['speaker'] as String? ?? '',
      subjudul: json['subjudul'] as String? ?? json['description'] as String? ?? '',
      image: json['image'] as String? ?? json['thumbnail'] as String? ?? '',
      link: json['link'] as String? ?? json['url'] as String? ?? '',
      type: json['tipe'] as String? ?? json['type'] as String? ?? 'list',
    );
  }
}
