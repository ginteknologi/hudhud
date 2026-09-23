class ArtikelModel {
  final int id;
  final String judul;
  final String slug;
  final String konten;
  final String thumbnail;
  final String createdAt;

  ArtikelModel({
    required this.id,
    required this.judul,
    this.slug = '',
    required this.konten,
    required this.thumbnail,
    this.createdAt = '',
  });

  factory ArtikelModel.fromJson(Map<String, dynamic> json) {
    return ArtikelModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? '1') ?? 1,
      judul: json['judul'] as String? ?? json['title'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      konten: json['konten'] as String? ?? json['content'] as String? ?? '',
      thumbnail: json['thumbnail'] as String? ?? json['image'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? '',
    );
  }
}
