class KajianData {
  int id;
  String? kategori, subjudul;
  String judul, image, link;
  KajianData(
      {required this.id,
      required this.judul,
       this.subjudul,
      this.kategori,
      required this.image,
      required this.link});

    factory KajianData.fromJson(Map<String, dynamic> json) {
      return KajianData(
        id: json['id'],
        judul: json['judul'],
        subjudul: json['subjudul'],
        image: json['image'],
        link: json['link'],
      );
    }
}
