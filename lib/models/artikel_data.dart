class ArtikelData {
  int id;
  String judul, publishDate, updatedAt, image;
  String? isi, idCategoryArtikel;
  Map? categoryArtikel;
  ArtikelData(
      {required this.id,
      required this.judul,
      required this.image,
      required this.updatedAt,
      required this.publishDate,
      this.idCategoryArtikel,
      this.isi,
      this.categoryArtikel});
}
