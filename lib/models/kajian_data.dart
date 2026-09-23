class KajianData {
  int id;
  String? judul, kategori, subjudul;
  String image, link;
  KajianData(
      {required this.id,
      this.judul,
      this.subjudul,
      this.kategori,
      required this.image,
      required this.link});

  factory KajianData.fromJson(Map<String, dynamic> json) {
    return KajianData(
      id: json['id'],
      judul: json['judul'],
      subjudul: json['subjudul'] ?? "Tidak ada keterangan",
      image: json['image'],
      link: json['link'],
    );
  }
}
