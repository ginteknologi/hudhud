class KajianData {
  int id;
  String? kategori;
  String judul, subjudul, image, link;
  KajianData(
      {required this.id,
      required this.judul,
      required this.subjudul,
      this.kategori,
      required this.image,
      required this.link});
}
